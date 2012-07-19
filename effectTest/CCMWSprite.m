//
//  CCMWSprite.mm
//
//  Created by Jack Ng on 24/05/2010.
//  Copyright 2010 Jack Ng. All rights reserved.
//

#import "CCMWSprite.h"
#import "CCSpriteFrame.h"

#import "CCSprite.h"
#import "CCSpriteBatchNode.h"
#import "CCGameSprite.h"
#import "GameConfig.h"

#define DEFAULT_MIN_FRAME_INTERVAL 0.03f


@implementation CCMWSprite
@synthesize spriteList;
@synthesize spriteSheetList;
@synthesize imageIndexOfSprite;
@synthesize isSpriteSheetExternal;
@synthesize animationFileData;
@synthesize animationData;
@synthesize curAnimationIndex;
@synthesize curFrame;
@synthesize numOfFrame;
@synthesize isReverse;
@synthesize shouldLoop;
@synthesize isAnimationEnded;
@synthesize collisionRect;
@synthesize delegate;
@synthesize minFrameInterval;
//@synthesize playTimes;
@synthesize mirror;


-(void)initData
{
    if(spriteList == nil) spriteList = [[NSMutableArray alloc] init];
    if(imageIndexOfSprite == nil) imageIndexOfSprite = [[NSMutableArray alloc] init];
    if(spriteSheetList == nil) spriteSheetList = [[NSMutableArray alloc] init];
    if(isSpriteSheetExternal == nil) isSpriteSheetExternal = [[NSMutableArray alloc] init];
    if(collisionRect == nil) collisionRect = [[NSMutableArray alloc]init];
}
- (id) initWithMWFile:(NSString*) fileName withImageName:(NSString*) imageName withAnimationIndex:(int) index{
	return [self initWithMWFile:fileName 
				  withImageList:[NSArray arrayWithObjects:imageName,nil] 
			 withAnimationIndex:index];
}

- (id) initWithMWFile:(NSString*) fileName withImageList:(NSArray*) imageList  withAnimationIndex:(int) index{
	
	self = [super init];
    [self initData];
    
	if(self != nil){
		self.animationFileData = [[CCMWFrameDataPool sharedDataPool] loadFrameData:fileName];
	//	animationData = [[CCMWFrameDataPool sharedDataPool] getAnimationData:index withFileName:fileName];
		NSAssert(animationFileData->numOfImage >= [imageList count],@"Image list passed in excess the image used in MW File!");
		
		for(unsigned int i = 0;i < [imageList count];i++){
        
            [spriteSheetList addObject:[CCSpriteBatchNode batchNodeWithFile:[imageList objectAtIndex:i]]];
            [isSpriteSheetExternal addObject:@"0"];
			[self addChild:(CCSpriteBatchNode*)[spriteSheetList objectAtIndex:i]];
			
	//		spriteSheetList[i].position = CGPointMake(50,50);
		}
		
		curAnimationIndex = -1;
		minFrameInterval = DEFAULT_MIN_FRAME_INTERVAL;
		
	}
    
	return self;
}

-(void)setMirror:(BOOL)ismirror
{
    if ((ismirror&&self.scaleX>0)||
        (!ismirror&&!self.scaleX<0)) 
    {
        self.scaleX = -self.scaleX;
    }
}

- (void) initSpriteFromAnimationData{
	int maxImageClipNum = 0;
	for(int i = 0; i < numOfFrame; i++){
		maxImageClipNum = fmax(((CCMWFrameData*)[animationData.frameDataList objectAtIndex:i]).numOfImageClip,maxImageClipNum);
	}

	int numDifference = maxImageClipNum - [spriteList count];
    
	for(int i=0;i<numDifference;i++){
		CCSprite* temp = [[CCSprite alloc] init];
		temp.anchorPoint = CGPointMake(0.0f,0.0f);
        [spriteList addObject:temp];
		[temp release];
		[imageIndexOfSprite addObject:@"-1"];
		//spriteList[i].anchorPoint = CGPointMake(0.0f,0.0f);
	}	
}

- (void) dealloc
{
    
    NSLog(@"this position = (%f, %f)  retaincount:%d",self.position.x , self.position.y,self.retainCount);
	[spriteList release];	
    [imageIndexOfSprite release];
	[spriteSheetList release];
    [isSpriteSheetExternal release];
    [collisionRect release];
    
	[animationFileData release];
	[animationData release];
	
	[super dealloc];
}

- (void) tick:(ccTime) timeStep_{
    if(stopAnimation) [self playAnimation:0];
    
	if(isAnimationEnded && !shouldLoop){
//		return;
        [self playAnimation:0];
	}
	
	if(curDuration >= frameDuration){
		//end of animation in reverse mode
		int nextFrame;
		BOOL tempIsAnimationEnded = NO;
		if(isReverse && curFrame == 0){
			nextFrame = numOfFrame - 1;
			tempIsAnimationEnded = YES;
		}
		//end of animation in forward mode
		else if(!isReverse && curFrame == numOfFrame - 1){
			nextFrame = 0;				
			tempIsAnimationEnded = YES;
		}
		else{
			nextFrame = curFrame + (isReverse?-1:1);
		}
		
		//if animation ended
		if(tempIsAnimationEnded){
			//if the animation need looping
			//set isAnimationEnded back to false
			if(!shouldLoop){
				isAnimationEnded = tempIsAnimationEnded;
			}

			if(delegate != nil){
				[delegate didMWAnimationEnded:curAnimationIndex sender:self];	
			}
		}
		
		if(!isAnimationEnded){
			[self setFrameIndex:nextFrame];
		}
	}
	else{
		curDuration += timeStep_;
	}
}

- (void) playAnimation:(int) index{
	// if index not equal to current AnimationIndex
	// fetch animation data from CCMWFrameDataPool and re-init the sprite needed
    if (index < 0){
        return;
    }    
	if(index != curAnimationIndex){
		self.animationData = [[CCMWFrameDataPool sharedDataPool] getAnimationData:index withAnimationFileData:animationFileData];
		numOfFrame = [animationData.frameDataList count];
       
		[self initSpriteFromAnimationData];
	}
		
	isAnimationEnded = NO;
	if(isReverse){
		[self setFrameIndex:numOfFrame - 1];
	}
	else{
		[self setFrameIndex:0];
	}	
	
	curAnimationIndex = index;
}


- (void) setFrameIndex:(int) index{
	curFrame = index;
    
	//clear all child of spritesheet
//	for(unsigned int i=0;i<spriteSheetList.size();i++){
//		[spriteSheetList[i] removeAllChildrenWithCleanup:true];
//	}
    
	//need to remove one by one as external SpriteSheet may used
	for(unsigned int i = 0; i < [imageIndexOfSprite count]; i++){
		if(![([imageIndexOfSprite objectAtIndex:i]) isEqualToString:@"-1"]){
			[[spriteSheetList objectAtIndex:[[imageIndexOfSprite objectAtIndex:i] integerValue]] removeChild:[spriteList objectAtIndex:i] cleanup:true];
		}
		//上面删除完了后 先把imageIndexOfSprite[] 全部设为-1
		[imageIndexOfSprite replaceObjectAtIndex:i withObject:@"-1"];
	}
	[collisionRect removeAllObjects];
	
	CCMWFrameData* frameData = [animationData.frameDataList objectAtIndex:index];
    
	//since not all clip data are image clip
	int imageClipindex = 0;
	for(unsigned int i = 0;i < [frameData.clipDataList count]; i++){
		CCMWClipData* tempClipData = [frameData.clipDataList objectAtIndex:i];
		
        CGRect imageRect = tempClipData.clipAdditionalData.imageRect;
        
        float x  = imageRect.origin.x;
        float y  = imageRect.origin.y;
        float width = imageRect.size.width;
        float height= imageRect.size.height;
        
        
        
        if (isRetina)
        {
            x = x;
            y = y;
            width  = width;
            height = height;
        }
		//it is a image clip
		if(tempClipData.type % 2 == 0){	
			// set the frame
			
            
            imageRect = CGRectMake(x,y, width,height);
			CCTexture2D* texture = ((CCSpriteBatchNode*)[spriteSheetList objectAtIndex:tempClipData.imageIndex]).textureAtlas.texture;
//			CCSpriteFrame* tempSpriteFrame = [CCSpriteFrame frameWithTexture:texture 
//																		rect:imageRect 
//																	  offset:CGPointMake(0,0)];

            CCSpriteFrame *tempSpriteFrame = [CCSpriteFrame frameWithTexture:texture rect:imageRect];
            tempSpriteFrame.offsetInPixels = CGPointMake(0,0);
            
            CCSprite* tempSprite = (CCSprite*)[spriteList objectAtIndex:imageClipindex];
			[tempSprite setDisplayFrame:tempSpriteFrame];
			tempSprite.visible = true;

			[imageIndexOfSprite replaceObjectAtIndex:imageClipindex withObject:[NSString stringWithFormat:@"%d",tempClipData.imageIndex]];
            
			//all sprite will be transformed to world position if external sprite sheet is using
			int flag = [[isSpriteSheetExternal objectAtIndex:[[imageIndexOfSprite objectAtIndex:imageClipindex] intValue]] intValue];
            
            CGPoint pos = ccp(tempClipData.clipPos.x, tempClipData.clipPos.y);
            if (isRetina)
                pos = ccp(pos.x, pos.y);
            
			if(flag == 1){
				tempSprite.position = [self convertToWorldSpaceAR:pos];
				tempSprite.rotation = self.rotation;
				tempSprite.scale = self.scale;
			}
			else{
				tempSprite.position = pos;
//                if (curAnimationIndex == 4){
//                    NSLog(@"position =(%f , %f)",spriteList[imageClipindex].position.x , spriteList[imageClipindex].position.y);
                    
//                    CCSprite *cs = spriteList[imageClipindex];
//                    NSLog(@"cs.parent.position=(%f,%f)",cs.parent.position.x,cs.parent.position.y);
                
//                }
			}
			
		
			tempSprite.flipX = false;
			tempSprite.flipX = false;
			
			ClipType tempType = (ClipType)(tempClipData.type % 8);
			if(tempType != 0){
				if(tempType % ClipType_ImageFlipXY == 0){
					tempSprite.flipX = true;
					tempSprite.flipX = true;
				}
				else if(tempType % ClipType_ImageFlipY == 0){
					tempSprite.flipX = true;
				}
				else if(tempType % ClipType_ImageFlipX == 0){
					tempSprite.flipX = true;
				}		
			}
      
			[((CCSpriteBatchNode*)[spriteSheetList objectAtIndex:tempClipData.imageIndex]) addChild:tempSprite];
			imageClipindex++;
		}		
		else if(tempClipData.type == ClipType_CollisionRect){
			CGRect tempRect;
			tempRect.origin = [self convertToWorldSpaceAR:tempClipData.clipPos];
			tempRect.size = tempClipData.clipAdditionalData.size;
			[collisionRect addObject:NSStringFromCGRect(tempRect)];
		}
	}
	
	curDuration = 0;
	frameDuration = frameData.delay*minFrameInterval;
    
	if(delegate != nil){
		[delegate didMWAnimationFrameChanged:curAnimationIndex sender:self];	
	}
	
	for(unsigned int i = [frameData.clipDataList count]; i < [spriteList count]; i++){
		CCSprite* temp = (CCSprite*)[spriteList objectAtIndex:i];
		temp.visible = false;
        temp.anchorPoint = CGPointMake(0.0f, 0.0f);
	}	
}

- (void) setExternalSpriteSheet:(CCSpriteBatchNode*) spriteSheet forImageIndex:(unsigned int) index{
	[self setExternalSpriteSheet:spriteSheet forImageIndex:index withZOrderForSprite:0];
}

- (void) setExternalSpriteSheet:(CCSpriteBatchNode*) spriteSheet forImageIndex:(unsigned int) index withZOrderForSprite:(int) z{
	NSAssert(index < animationFileData->numOfImage,@"Animation File do not have spriteSheet at this index");
	
	//if the SpriteSheet at index has not been created
	if(index >= [spriteSheetList count]){
		[spriteSheetList addObject:spriteSheet];
		[isSpriteSheetExternal addObject:@"1"];
	}
	else{
		CCSpriteBatchNode* tempSpriteSheet = [spriteSheetList objectAtIndex:index];
		[spriteSheetList insertObject:spriteSheet atIndex:index];
		
		//remove the sprite added to the SpriteSheet
		for(unsigned int i = 0; i < [imageIndexOfSprite count];i++){
			if(([[imageIndexOfSprite objectAtIndex:i] intValue]) != -1 && (unsigned int)[[imageIndexOfSprite objectAtIndex:i] intValue] == index){
				[tempSpriteSheet removeChild:(CCSprite*)[spriteList objectAtIndex:i] cleanup:true];
			}
		}	
		[self removeChild:tempSpriteSheet cleanup:true];
		[tempSpriteSheet release];
		
		for(unsigned int i = 0; i < [imageIndexOfSprite count];i++){
			if([[imageIndexOfSprite objectAtIndex:i] intValue] != -1 && (unsigned int)[[imageIndexOfSprite objectAtIndex:i] intValue] == index){
				CCSprite* temp = (CCSprite*)[spriteList objectAtIndex:i];
				[spriteSheet addChild:temp z:z];
				
				//if previous SpriteSheet is not external, transform the position of sprite to world space 
				if([[isSpriteSheetExternal objectAtIndex:index] intValue] == 0){
					temp.position = [self convertToWorldSpaceAR:temp.position];
					temp.rotation = self.rotation;
					temp.scale = self.scale;
				}
			}
		}	
		
		[isSpriteSheetExternal replaceObjectAtIndex:index withObject:@"1"];
	}
	
}
- (void) startAnimation
{
    stopAnimation = NO;
    [self playAnimation:0];
    [self schedule:@selector(tick:)];
}
- (void) stopAnimation
{
    stopAnimation = YES;
}
@end

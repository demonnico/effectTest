//
//  GleeMWFrameDataPool.m
//  MWTestSprite
//
//  Created by xu Jesse on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCMWFrameDataPool.h"

@implementation CCMWClipAdditionalData
@synthesize startAngle;
@synthesize endAngle;
@synthesize pt2;
@synthesize color;
@synthesize size;
@synthesize arcWidth;
@synthesize arcHeight;
@synthesize imageRect;
@end

@implementation CCMWClipData
@synthesize clipAdditionalData;
@synthesize clipAdditionalDataIndex;
@synthesize imageIndex;
@synthesize clipFrameIndex;
@synthesize clipPos;
@synthesize type;

-(void)dealloc
{
    [clipAdditionalData release];
    clipAdditionalData = nil;
	[super dealloc];
}

@end

//
@implementation CCMWFrameData
@synthesize clipDataList;
@synthesize numOfImageClip;
@synthesize frameGlobalIndex;
@synthesize delay;
@synthesize xinc;
@synthesize yinc;
-(id)init
{
    [super init];
    clipDataList = [[NSMutableArray alloc] init];
    return self;
}
-(void)dealloc
{
    [clipDataList release];
    clipDataList = nil;
	[super dealloc];
}

@end

//
@implementation CCMWAnimationData
@synthesize frameDataList;
@synthesize animeFileName;
@synthesize animeIndex;
-(id)init
{
    [super init];
    frameDataList = [[NSMutableArray alloc] init];
    return self;
}
-(void)dealloc
{
    [frameDataList release];
    frameDataList = nil;
    [animeFileName release];
    animeFileName = nil;
	[super dealloc];
}
@end

@implementation CCMWAnimationFileData
@synthesize fileName;

-(void)dealloc
{
    [fileName release];
	if(animationTable)free(animationTable);
	if(frameTable)free(frameTable);
	if(framePoolTable)free(framePoolTable);
	if(imageClipPool)free(imageClipPool);
	if(ellipseClipPool)free(ellipseClipPool);
	if(lineClipPool)free(lineClipPool);
	if(rectangleClipPool)free(rectangleClipPool);
	if(roundedRectangleClipPool)free(roundedRectangleClipPool);
	if(positionerRectangleClipPool)free(positionerRectangleClipPool);
	if(frameTableIndex)free(frameTableIndex);
	if(imageIndex)free(imageIndex);

	animationTable 	= NULL;
	frameTable 		= NULL;
	framePoolTable 	= NULL;
	imageClipPool 	= NULL;
	ellipseClipPool = NULL;
	lineClipPool 	= NULL;
	rectangleClipPool = NULL;
	roundedRectangleClipPool = NULL;
	positionerRectangleClipPool = NULL;
	frameTableIndex = NULL;
	imageIndex = NULL;	
    fileName = nil;
	
	[super dealloc];
}

@end

//CCMWFrameDataPool
#define SHOULD_DEBUG_CCMWFRAME 0

static CCMWFrameDataPool* sharedDataPool = nil;
@interface CCMWFrameDataPool(Private)
- (NSData*) loadDataFromFile:(NSString *)fileName;
@end

@implementation CCMWFrameDataPool
@synthesize animationFileDataList;

+ (CCMWFrameDataPool*) sharedDataPool
{
	@synchronized(sharedDataPool){
		if(sharedDataPool == nil){
			sharedDataPool = [[CCMWFrameDataPool alloc] init];
		}
	}
	return sharedDataPool;
}

+ (void) releaseSharedDataPool
{
	@synchronized(sharedDataPool){
			[sharedDataPool release];
			sharedDataPool = nil;
	}
}
-(id)init
{
    [super init];
    
    animationFileDataList = [[NSMutableArray alloc] init];
    return self;
}
-(void) dealloc
{
    [animationFileDataList release];
    animationFileDataList = nil;
	[super dealloc];
}

-(void) releaseAllAnimationFileData
{
    [animationFileDataList removeAllObjects];
}

-(CCMWAnimationFileData*) loadFrameData:(NSString *)fileName
{
    CCMWAnimationFileData* returnAnimeData = [self getAnimationFileDataWithName:fileName];
    if(returnAnimeData != nil){
        return returnAnimeData;
    }
    
    returnAnimeData = [[CCMWAnimationFileData alloc] init];
    returnAnimeData.fileName = fileName;
    [animationFileDataList addObject:returnAnimeData];
    [returnAnimeData release];
    
	NSData* data = [self loadDataFromFile:fileName];
    Byte* dataBytes = (Byte*)[data bytes];
    
    short* animationTable = NULL;
	short* frameTable = NULL;
	short* framePoolTable = NULL;
	short* imageClipPool = NULL;
	int*   ellipseClipPool = NULL;
	int*   lineClipPool = NULL;
	int*   rectangleClipPool = NULL;
	int*   roundedRectangleClipPool = NULL;
	short* positionerRectangleClipPool = NULL;
	
	short* frameTableIndex;
	short* imageIndex;
    //may change in other version of motion welder
	int startByteIndex = 7;
	int curByteIndex = startByteIndex;
    
    //read animation table
	int numOfAnimation = dataBytes[curByteIndex];
	curByteIndex ++;
    animationTable = (short*)malloc(sizeof(short)*(numOfAnimation<<1));
    for(int i = 0; i < numOfAnimation; i++){
        animationTable[2*i] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
        curByteIndex += 2;
        animationTable[2*i+1] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
        curByteIndex += 2;
    }
    
    //read frame table
    int numOfFrame =  CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex += 2;
    frameTable = (short*)malloc(sizeof(short)*numOfFrame*4);
    for(int i = 0; i < numOfFrame; i++){
		frameTable[4*i] =  CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		frameTable[4*i+1] =  dataBytes[curByteIndex];
		curByteIndex ++;	
		frameTable[4*i+2] =  CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		frameTable[4*i+3] =  CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
        
        if(SHOULD_DEBUG_CCMWFRAME){
            NSLog(@"Frame Index:%i\tdelay:%i\tincx:%d\tincy:%i\n",frameTable[4*i],frameTable[4*i+1],frameTable[4*i+2],frameTable[4*i+3]);
        }
    }
    
    //read frame pool table
	int length = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
	//	int totalNumberOfClips = length>>2;
	framePoolTable = (short*)malloc(sizeof(short)*length);
	int noOfFrameInPool =   CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
	short index = 0;
    frameTableIndex = (short*)malloc(sizeof(short)*(noOfFrameInPool<<1));
	
	if(SHOULD_DEBUG_CCMWFRAME){
		NSLog(@"Num of frame in pool: %i \n", noOfFrameInPool);
	}	
	for(int i=0;i<noOfFrameInPool;i++){
		frameTableIndex[2*i] = index; 
		short noOfClips = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		if(SHOULD_DEBUG_CCMWFRAME){
			NSLog(@"Start Clip index: %i \n", frameTableIndex[2*i]);
			NSLog(@"Num of clip: %i \n", noOfClips);
		}
		for(int j=0;j<noOfClips;j++){
			framePoolTable[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex])); // index
			curByteIndex +=2;	
			framePoolTable[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex])); // xpos
			curByteIndex +=2;	
			framePoolTable[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex])); // ypos
			curByteIndex +=2;	
			framePoolTable[index++] = dataBytes[curByteIndex]; // flag ,  flag%2 ==0  means it is a image clip, only support 32 image
			curByteIndex ++;	
			if(SHOULD_DEBUG_CCMWFRAME){
				NSLog(@"Index: %i xpos: %i ypos:%i flag:%i\n", framePoolTable[index-4],framePoolTable[index-3],framePoolTable[index-2],framePoolTable[index-1]);
			}
		}
		frameTableIndex[2*i+1] = (short)(index-1);
		
		if(SHOULD_DEBUG_CCMWFRAME){
			NSLog(@"End Clip index: %i \n", frameTableIndex[2*i+1]);
		}
	}
    
    /** Clip Pool */
	// image
	int noOfImagesClips = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
	int noOfImages = dataBytes[curByteIndex];
	curByteIndex++;
	

    imageClipPool = (short*)malloc(sizeof(short)*(noOfImagesClips<<2));
	index=0;
    imageIndex = (short*)malloc(sizeof(short)*noOfImages);
	short noOfClipsRead = 0;
	for(int i=0;i<noOfImages;i++){
		imageIndex[i] = noOfClipsRead;
		int noOfClipsInThisImage = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		if(SHOULD_DEBUG_CCMWFRAME){
			NSLog(@"noOfClipsInThisImage: %i \n",noOfClipsInThisImage);
		}
		for(int j=0;j<noOfClipsInThisImage;j++){
			imageClipPool[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
			curByteIndex +=2;	
			imageClipPool[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
			curByteIndex +=2;	
			imageClipPool[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
			curByteIndex +=2;	
			imageClipPool[index++] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
			curByteIndex +=2;	
			
			if(SHOULD_DEBUG_CCMWFRAME){
				NSLog(@"x: %i y:%i w:%i h:%i \n",imageClipPool[index-4],imageClipPool[index-3],imageClipPool[index-2],imageClipPool[index-1]);
			}
		}
		noOfClipsRead +=noOfClipsInThisImage;		
	}
    
    // ellipse
	int noOfEllipseClip = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
    ellipseClipPool = (int*)malloc(sizeof(int)*noOfEllipseClip*5);
	for(int i=0;i<noOfEllipseClip;i++){
		ellipseClipPool[5*i] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		ellipseClipPool[5*i+1] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		ellipseClipPool[5*i+2] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		ellipseClipPool[5*i+3] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		ellipseClipPool[5*i+4] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
	}
    
    // Line
	int noOfLineClip = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
    lineClipPool = (int*)malloc(sizeof(int)*noOfLineClip*3);
	for(int i=0;i<noOfLineClip;i++){
		lineClipPool[3*i] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		lineClipPool[3*i+1] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		lineClipPool[3*i+2] = CFSwapInt32BigToHost(*(unsigned int*)(&dataBytes[curByteIndex]));
		curByteIndex +=4;	
	}
    
    // Rectangle
	int noOfRectangleClip =CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
    rectangleClipPool = (int*)malloc(sizeof(int)*noOfRectangleClip*3);
	for(int i=0;i<noOfRectangleClip;i++){
		rectangleClipPool[3*i] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		rectangleClipPool[3*i+1] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		rectangleClipPool[3*i+2] = CFSwapInt32BigToHost(*(unsigned int*)(&dataBytes[curByteIndex]));
		curByteIndex +=4;	
	}
    
    // rounded Rect
	int noOfRoundedRectangleClip = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
    roundedRectangleClipPool = (int*)malloc(sizeof(int)*noOfRoundedRectangleClip*5);
	for(int i=0;i<noOfRoundedRectangleClip;i++){
		roundedRectangleClipPool[5*i]   = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		roundedRectangleClipPool[5*i+1] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		roundedRectangleClipPool[5*i+2] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		roundedRectangleClipPool[5*i+3] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		roundedRectangleClipPool[5*i+4] = CFSwapInt32BigToHost(*(unsigned int*)(&dataBytes[curByteIndex]));
		curByteIndex +=4;	
	}
    
	// rounded Rect
	int noOfPositionerRectangleClip = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
	curByteIndex +=2;	
	positionerRectangleClipPool = (short*)malloc(sizeof(short)*(noOfPositionerRectangleClip<<1));
	for(int i=0;i<noOfPositionerRectangleClip;i++){
		positionerRectangleClipPool[2*i] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
		positionerRectangleClipPool[2*i+1] = CFSwapInt16BigToHost(*(unsigned short*)(&dataBytes[curByteIndex]));
		curByteIndex +=2;	
	}
	
	returnAnimeData->numOfImage     = noOfImages;
	returnAnimeData->animationTable = animationTable;
	returnAnimeData->frameTable     = frameTable;
	returnAnimeData->framePoolTable = framePoolTable;
	returnAnimeData->imageClipPool  = imageClipPool;
	returnAnimeData->ellipseClipPool = ellipseClipPool;
	returnAnimeData->lineClipPool    = lineClipPool;
	returnAnimeData->rectangleClipPool = rectangleClipPool;
	returnAnimeData->roundedRectangleClipPool = roundedRectangleClipPool;
	returnAnimeData->positionerRectangleClipPool = positionerRectangleClipPool;
	returnAnimeData->frameTableIndex    = frameTableIndex;
	returnAnimeData->imageIndex         = imageIndex;
	
	return returnAnimeData;
}

-(CCMWAnimationFileData*) getAnimationFileDataWithName:(NSString *)fileName
{
    for (unsigned int i = 0; i < [animationFileDataList count]; i++) {
        CCMWAnimationFileData* data = [animationFileDataList objectAtIndex:i];
        if([data.fileName isEqualToString:fileName]){
            return data;
        }
    }
    return nil;
}

- (NSData *)loadDataFromFile:(NSString *)fileName {
	
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
	NSData *myData = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
    return myData;
}

-(CCMWAnimationData*)getAnimationData:(int)animeIndex withAnimationFileData:(CCMWAnimationFileData *)animationFileData
{
    CCMWAnimationData* returnAnimationData = [[[CCMWAnimationData alloc] init] autorelease];
    returnAnimationData.animeIndex = animeIndex;
	returnAnimationData.animeFileName = animationFileData.fileName;
	
	unsigned short startFrame = animationFileData->animationTable[animeIndex*2];
	unsigned short endFrame = animationFileData->animationTable[animeIndex*2+1];
	unsigned short numberOfFrame = endFrame - startFrame + 1;
	
	for(unsigned short i = 0; i < numberOfFrame; i++){
		CCMWFrameData* tempFrameData = [[CCMWFrameData alloc] init];
		int frameGlobalIndex = startFrame + i;
		tempFrameData.frameGlobalIndex = frameGlobalIndex;
		tempFrameData.delay = animationFileData->frameTable[frameGlobalIndex*O_FRAMEDATA_NUM + 1];
		tempFrameData.xinc = animationFileData->frameTable[frameGlobalIndex*O_FRAMEDATA_NUM + 2];
		tempFrameData.yinc = animationFileData->frameTable[frameGlobalIndex*O_FRAMEDATA_NUM + 3];
		
		int frameInFrameTableIndex = animationFileData->frameTable[frameGlobalIndex*O_FRAMEDATA_NUM];
		unsigned short startFramePoolIndex = animationFileData->frameTableIndex[frameInFrameTableIndex*2];
		unsigned short endFramePoolIndex = animationFileData->frameTableIndex[frameInFrameTableIndex*2+1];
		
		
		unsigned short noOfClip = (endFramePoolIndex - startFramePoolIndex + 1) / O_CLIPDATA_NUM;
		
		//tempFrameData->clipDataList
		int numOfImageClip = 0;
		for(unsigned short j = 0;j<noOfClip;j++){
			CCMWClipData* tempClipData = [[CCMWClipData alloc] init];
			unsigned int startClipDataIndex = startFramePoolIndex+j*O_CLIPDATA_NUM;
			unsigned short clipAdditionalDataIndex = animationFileData->framePoolTable[startClipDataIndex];
			tempClipData.clipAdditionalDataIndex = clipAdditionalDataIndex;
			
			//in motion welder coordinate system, upper y axis is negative
			// we need to reverse it
			tempClipData.clipPos = CGPointMake(animationFileData->framePoolTable[startClipDataIndex + 1],
											   animationFileData->framePoolTable[startClipDataIndex + 2]);
			tempClipData.type = (ClipType)animationFileData->framePoolTable[startClipDataIndex + 3];
			tempClipData.clipFrameIndex = i;
			tempClipData.imageIndex = -1;
			
			CCMWClipAdditionalData* tempAdditionalData = [[CCMWClipAdditionalData alloc] init];
			if(tempClipData.type%2 == 0){
				tempClipData.imageIndex = tempClipData.type/8;
				numOfImageClip++;
				tempAdditionalData.imageRect = CGRectMake(animationFileData->imageClipPool[clipAdditionalDataIndex*4],
														   animationFileData->imageClipPool[clipAdditionalDataIndex*4+1], 
														   animationFileData->imageClipPool[clipAdditionalDataIndex*4+2], 
														   animationFileData->imageClipPool[clipAdditionalDataIndex*4+3]);
			}
			else if(tempClipData.type % ClipType_CollisionRect == 0){
				tempAdditionalData.size = CGSizeMake(animationFileData->positionerRectangleClipPool[clipAdditionalDataIndex*2],
													  animationFileData->positionerRectangleClipPool[clipAdditionalDataIndex*2+1]);
			}
			else if(tempClipData.type % ClipType_Line == 0){
				tempAdditionalData.pt2 = CGPointMake(animationFileData->lineClipPool[clipAdditionalDataIndex*2],
													  animationFileData->lineClipPool[clipAdditionalDataIndex*2+1]);
				tempAdditionalData.color = animationFileData->lineClipPool[clipAdditionalDataIndex*2 + 2];
			}
			else if(tempClipData.type % ClipType_Rect == 0){
				tempAdditionalData.size = CGSizeMake(animationFileData->rectangleClipPool[clipAdditionalDataIndex*2],
													  animationFileData->rectangleClipPool[clipAdditionalDataIndex*2+1]);
				tempAdditionalData.color = animationFileData->rectangleClipPool[clipAdditionalDataIndex*2 + 2];
				
			}
			else if(tempClipData.type % ClipType_RoundRect == 0){
				tempAdditionalData.size = CGSizeMake(animationFileData->roundedRectangleClipPool[clipAdditionalDataIndex*2],
													  animationFileData->roundedRectangleClipPool[clipAdditionalDataIndex*2+1]);
				tempAdditionalData.arcWidth = animationFileData->roundedRectangleClipPool[clipAdditionalDataIndex*2+2];
				tempAdditionalData.arcHeight = animationFileData->roundedRectangleClipPool[clipAdditionalDataIndex*2+3];
				tempAdditionalData.color = animationFileData->roundedRectangleClipPool[clipAdditionalDataIndex*2 + 4];
				
			}
			else{
				tempAdditionalData.size = CGSizeMake(animationFileData->ellipseClipPool[clipAdditionalDataIndex*2],
													  animationFileData->ellipseClipPool[clipAdditionalDataIndex*2+1]);
				tempAdditionalData.startAngle = animationFileData->ellipseClipPool[clipAdditionalDataIndex*2 + 2];
				tempAdditionalData.endAngle = animationFileData->ellipseClipPool[clipAdditionalDataIndex*2 + 3];
				tempAdditionalData.color = animationFileData->ellipseClipPool[clipAdditionalDataIndex*2 + 4];
			}
			
			//in motion welder coordinate system, upper y axis is negative
			// we need to reverse it
			//if it is a image clip
			if(tempClipData.type % 2 == 0){
				float y = - tempClipData.clipPos.y - tempAdditionalData.imageRect.size.height;
				tempClipData.clipPos = CGPointMake(animationFileData->framePoolTable[startClipDataIndex + 1],
													y);
			}
			else{
				float y = - tempClipData.clipPos.y - tempAdditionalData.size.height;
				tempClipData.clipPos = CGPointMake(animationFileData->framePoolTable[startClipDataIndex + 1],
													y);
				
			}
			
			
			tempClipData.clipAdditionalData = tempAdditionalData;
			[tempAdditionalData release];
			[tempFrameData.clipDataList addObject:tempClipData];
			[tempClipData release];
		}
		
		tempFrameData.numOfImageClip = numOfImageClip;
		[returnAnimationData.frameDataList addObject:tempFrameData];
		[tempFrameData release];
	}
	
	return returnAnimationData;	
}

- (CCMWAnimationData*) getAnimationData:(int) animeIndex withFileName:(NSString*) fileName{
	CCMWAnimationFileData* matchAnimationFileData = nil;
	
	for(unsigned int i = 0; i < [animationFileDataList count]; i++){
		CCMWAnimationFileData* tempAnimationFileData = [animationFileDataList objectAtIndex:i];
		if([tempAnimationFileData.fileName isEqualToString:fileName]){
			matchAnimationFileData = tempAnimationFileData;
			break;
		}		
	}
	
	if(matchAnimationFileData == nil){
		return nil;
	}
	return [self getAnimationData:animeIndex withAnimationFileData:matchAnimationFileData];
}
@end
//
//  CCMWSprite.h
//
//  Created by Jack Ng on 24/05/2010.
//  Copyright 2010 Jack Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCMWFrameDataPool.h"
#import "CCNode.h"

/**
 * CCMWSprite  is a sprite constructed using .anu exported from Motion Welder
 *http://www.motionwelder.com/
 * It contain following Characteristic
 * - it is an animated sprite constructed with array of CCSprite
 * - all sprites are added to CCSpriteBatchNode
 * 
 * - contain several SpriteSheet depends on the number of image name passed
 * - can set a external SpriteSheet for certain index, means it is possible add all CCSprite to external SpriteSheet for better performance
 */
@class CCSprite;
//@class CCSpriteSheet;
@class CCSpriteBatchNode;

@class CCMWSprite;

@protocol CCMWSpriteEventHandler
- (void)didMWAnimationFrameChanged:(int) animationIndex_ sender:(CCMWSprite*) sprite_;
- (void)didMWAnimationEnded:(int) animationIndex_ sender:(CCMWSprite*) sprite_;
@end

@interface CCMWSprite : CCNode {
	NSMutableArray* spriteList; 		//CCSprite*
	NSMutableArray* imageIndexOfSprite; //int*
	
	NSMutableArray* spriteSheetList;	//CCSpriteBatchNode*
	NSMutableArray* isSpriteSheetExternal;//bool
	
	//frameData[frameIndex][frameDataIndex]
	CCMWAnimationFileData* animationFileData;
	CCMWAnimationData* animationData;

	int curAnimationIndex;
	int curFrame;
	int numOfFrame;
	
    //int playTimes;
    
	float frameDuration;
	float curDuration;

	BOOL isReverse;
	BOOL shouldLoop;
	BOOL isAnimationEnded;
    BOOL mirror;
	
	float minFrameInterval;
	
	NSMutableArray* collisionRect; //CGRect
	
    BOOL stopAnimation;
	id<CCMWSpriteEventHandler> delegate;
}
@property (nonatomic,retain)NSMutableArray* spriteList;;
@property (nonatomic,retain)NSMutableArray* imageIndexOfSprite;
@property (nonatomic,retain)NSMutableArray* spriteSheetList;
@property (nonatomic,retain)NSMutableArray* isSpriteSheetExternal;
@property (nonatomic,retain)CCMWAnimationFileData* animationFileData;
@property (nonatomic,retain)CCMWAnimationData* animationData;
@property (nonatomic)int curAnimationIndex;
@property (nonatomic)int curFrame;
//@property (readwrite) int playTimes;
@property (nonatomic,readwrite) BOOL mirror;
@property (nonatomic,assign) int numOfFrame;
@property (nonatomic)BOOL isReverse;
@property (nonatomic)BOOL shouldLoop;
@property (nonatomic)BOOL isAnimationEnded;
@property (nonatomic,readonly)NSMutableArray* collisionRect;
@property (nonatomic,assign)id<CCMWSpriteEventHandler> delegate;
@property (nonatomic)float minFrameInterval;

- (id) initWithMWFile:(NSString*) fileName withImageName:(NSString*) imageName withAnimationIndex:(int) index;
- (id) initWithMWFile:(NSString*) fileName withImageList:(NSArray*) imageList withAnimationIndex:(int) index;

- (void) initSpriteFromAnimationData;
- (void) tick:(ccTime) timeStep_;
- (void) playAnimation:(int) index;
- (void) playAnimation:(int) index times:(int)times;
- (void) setFrameIndex:(int) index;

//for better performance, set a external SpriteSheet for image index 
//if external SpriteSheet is used, all sprite add to sprite sheet will need to transform according to this object
- (void) setExternalSpriteSheet:(CCSpriteBatchNode*) spriteSheet forImageIndex:(unsigned int) index;
- (void) setExternalSpriteSheet:(CCSpriteBatchNode*) spriteSheet forImageIndex:(unsigned int) index withZOrderForSprite:(int) z;
- (void) startAnimation;
- (void) stopAnimation;
@end

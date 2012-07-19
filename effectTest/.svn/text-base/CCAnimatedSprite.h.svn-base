//
//  ccAnimatedSprite.h
//  
//
//  Created by Jack Ng on 01/04/2010.
//  Copyright 2010 Jack Ng. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "CCSprite.h"


@class CCAnimatedSprite;

@interface CCAnimationFrame : NSObject{
	NSString* frameName;
	ccTime time;
	bool flipX;
	bool flipY;
}
@property(nonatomic,retain)NSString* frameName;
@property(nonatomic)ccTime time;
@property(nonatomic)bool flipX;
@property(nonatomic)bool flipY;

@end


@protocol CCAnimatedSpriteEventHandler
- (void)didAnimationFrameChanged:(NSString*) animationName_ sender:(CCAnimatedSprite*) sprite;
- (void)didAnimationEnded:(NSString*) animationName_ sender:(CCAnimatedSprite*) sprite;
@end

@interface CCAnimatedSprite : CCSprite {
	//contain animation frame data read from plist
	//get CCAnimationFrame array for certain animation using animationName as the key
	NSMutableDictionary* animationsFrameDict;
	
	NSArray* curAnimationFrameList;
	NSString* curAnimationName;
	int curFrame;
	int numOfFrame;
	
	float curDuration;
	float frameDuration;
	
	bool isReverse;
	bool shouldLoop;
	bool isAnimationEnded;
	
	id<CCAnimatedSpriteEventHandler> delegate;
}
@property (nonatomic,retain)NSString* curAnimationName;
@property (nonatomic,setter = setCurAnimationFrame:)int curFrame;
@property (nonatomic,readonly)int numOfFrame;
@property (nonatomic)bool isReverse;
@property (nonatomic)bool shouldLoop;
@property (nonatomic,readonly)bool isAnimationEnded;
@property (nonatomic,assign)id<CCAnimatedSpriteEventHandler> delegate;

- (id) initWithAnimationFile:(NSString*) aniamtionFileName_;

- (void) tick:(ccTime) timeStep_;

- (void) playAnimation:(NSString*) animationName_;
- (void) playAnimation:(NSString*) animationName_ shouldReverse:(bool) shouldReverse_;
- (void) setCurAnimationFrame:(int) curFrame_;
@end

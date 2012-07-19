//
//  CCKnockSprite.m
//  effectTest
//
//  Created by Nicholas Tau on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCKnockSprite.h"


typedef enum 
{
    kCCKnockSpriteHalo,
    kCCKnockSpriteStar

}kCCKnockSprite;

@implementation CCKnockSprite

-(id)initKnockSprite
{
    if ([self init])
    {
        CCSprite * star  = [CCSprite spriteWithFile:@"Knockout_Star01.png"];
        CCSprite * halo  = [CCSprite spriteWithFile:@"Knockout_Halo01.png"];
        
        [self addChild:halo z:0 tag:kCCKnockSpriteHalo];
        [self addChild:star z:1 tag:kCCKnockSpriteStar];
        isAnimating  = FALSE;
        
        star.position =ccp(4,-5);
        star.opacity  = 0;
        halo.opacity  = 0;
    }
    return self;
}

-(void)showAnimation
{
    if(isAnimating) return;
    
    CCSprite * star  = (CCSprite*)[self getChildByTag:kCCKnockSpriteStar];
    CCSprite * halo  = (CCSprite*)[self getChildByTag:kCCKnockSpriteHalo];
    
    star.opacity = 255;
    halo.opacity = 255;
    
    CCMoveBy * up   = [CCMoveBy actionWithDuration:0.5 position:ccp(0,2)];
    CCMoveBy * down = [CCMoveBy actionWithDuration:0.5 position:ccp(0,-2)];
    
    CCRepeatForever * foreverHalo = [CCRepeatForever actionWithAction:[CCSequence actions:up,down, nil]];
    [halo runAction:foreverHalo];
    
    
    CCRotateBy * rotate   = [CCRotateBy actionWithDuration:0.5 angle:360];
    CCScaleBy  * zoomOut  = [CCScaleBy actionWithDuration:0.5 scale:0.7];
    
    CCJumpBy   * jumpBy0   = [CCJumpBy actionWithDuration:0.5 position:ccp(8, 5) height:10 jumps:1];
    CCJumpBy   * jumpBy1   = [CCJumpBy actionWithDuration:0.5 position:ccp(-8, 6) height:5 jumps:1];
    CCJumpBy   * jumpBy2   = [CCJumpBy actionWithDuration:0.5 position:ccp(-8, -6) height:5 jumps:1];
    CCJumpBy   * jumpBy3   = [CCJumpBy actionWithDuration:0.5 position:ccp(8, -5) height:10 jumps:1];
    
    
    //CCMoveBy * right = [CCMoveBy actionWithDuration:0.5 position:ccp(1,1)];
    
    CCSpawn   * spawnZoomOutRight      = [CCSpawn actions:zoomOut, nil];
    CCSpawn   * spawnZoomInRight       = [CCSpawn actions:[zoomOut reverse], nil];
    
    CCSpawn    * spawn0    = [CCSpawn actions:jumpBy0,rotate,zoomOut, nil];
    CCSpawn    * spawn1    = [CCSpawn actions:jumpBy1,[rotate reverse], nil];
    CCSpawn    * spawn2    = [CCSpawn actions:jumpBy2,[rotate reverse],nil];
    CCSpawn    * spawn3    = [CCSpawn actions:jumpBy3,rotate,[zoomOut reverse], nil];
    
    //CCSequence * seqence0  = [CCSequence actions:zoomOut,zoomIn, nil];
    
    CCMoveBy * lastMove0       = [CCMoveBy   actionWithDuration:0.5 position:ccp(-9,-1)];
    CCMoveBy * lastMove1       = [CCMoveBy   actionWithDuration:0.5 position:ccp(9,1)];
    
    CCRepeatForever * foreverStar = [CCRepeatForever actionWithAction:[CCSequence actions:
                                                                       spawn0,spawnZoomOutRight,
                                                                       spawn1,lastMove0,
                                                                       spawn2,spawnZoomInRight ,
                                                                       spawn3,lastMove1,nil]];
    
    
    [star runAction:foreverStar];
    isAnimating = TRUE;
}

+(id)ccKnockSprite
{
    return [[[self alloc] initKnockSprite] autorelease];
}

@end

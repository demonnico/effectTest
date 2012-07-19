//
//  CCStarSprite.m
//  effectTest
//
//  Created by Nicholas Tau on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCStarSprite.h"


typedef enum 
{
    kCCStarSprite01,
    kCCStarSprite02
}kCCStarSprite;


@interface CCStarSprite (PrivateMethod) 
-(void)changeStarPos;
@end

@implementation CCStarSprite


-(id)initStarSprite
{
    if ([self init])
    {
        CCSprite * star0 = [CCSprite spriteWithFile:@"CrystalSparkle_01.png"];
        CCSprite * star1 = [CCSprite spriteWithFile:@"CrystalSparkle_02.png"];
        
        star0.position = ccp(CCRANDOM_0_1()*10, CCRANDOM_0_1()*10);
        star1.position = ccp(CCRANDOM_0_1()*10, CCRANDOM_0_1()*10);
        
        [self addChild:star0 z:1 tag:kCCStarSprite01];
        [self addChild:star1 z:1 tag:kCCStarSprite02];
        
        star0.opacity  = 0;
        star1.opacity  = 0;
        
        isAnimating = FALSE;
        
    }
    return self;
}
+(id)ccStarSprite
{
    return [[[self alloc] initStarSprite] autorelease];
}

-(void)showAnimation
{
    
    if(isAnimating) return;     
    
    CCSprite * star0 = (CCSprite*)[self getChildByTag:kCCStarSprite01];
    CCSprite * star1 = (CCSprite*)[self getChildByTag:kCCStarSprite02];
    
    CCFadeIn   * fadeIn  = [CCFadeIn  actionWithDuration:CCRANDOM_0_1()*5];
    CCFadeOut  * fadeOut = [CCFadeOut  actionWithDuration:CCRANDOM_0_1()*5];
    CCCallFunc * func    = [CCCallFunc actionWithTarget:self selector:@selector(changeStarPos)];
    
    id reverseFadeInOut  = [[CCSequence actions:fadeIn,fadeOut,func, nil] reverse];
    
    [star0 runAction:[CCRepeatForever actionWithAction:reverseFadeInOut]];
    [star1 runAction:[CCRepeatForever actionWithAction:reverseFadeInOut]];
    
    isAnimating = YES;
}

-(void)changeStarPos
{
    CCSprite * star0 = (CCSprite*)[self getChildByTag:kCCStarSprite01];
    CCSprite * star1 = (CCSprite*)[self getChildByTag:kCCStarSprite02];
    
    star0.position = ccp(CCRANDOM_0_1()*10, CCRANDOM_0_1()*10);
    star1.position = ccp(CCRANDOM_0_1()*10, CCRANDOM_0_1()*10);
    
    star0.opacity = 255;
    star1.opacity = 255;
}

@end

//
//  CCActionPointSprite.m
//  effectTest
//
//  Created by Nicholas Tau on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCActionPointSprite.h"
#import "CCSpriteHelper.h"


@interface CCActionPointSprite(PrivateMethod)
-(BOOL)checkTouchPoint:(UITouch*)touch;
-(void)showNextPointAnimation;
-(void)changeIndexAfterShowNext;
@end

typedef enum 
{
    kCCActionPointSpriteBG=0,
    kCCActionPointSpritePoint0,
    kCCActionPointSpritePoint1,
    kCCActionPointSpritePoint2,
    kCCActionPointSpritePoint3,
    kCCActionPointSpritePoint4
}kCCActionPointSprite ;

@implementation CCActionPointSprite

-(id)initActionPointSprite
{
    if ([self init])
    {
        CCSprite * back =[CCSprite spriteWithFile:@"ActionPoints_MetalBG.png"];
        [self addChild:back z:0 tag:kCCActionPointSpriteBG];
        
        pointIndex = 0;
        pointNums  = 5;
        for (int i =0; i<5; i++)
        {
            CCSprite * gem =[CCSprite spriteWithFile:@"ActionPoints_Gem.png"];
            gem.anchorPoint= CGPointMake(0, 0);
            [self addChild:gem z:0 tag:kCCActionPointSpriteBG+i+1];
            gem.rotation = -18+72*i;
            gem.opacity  = 0;
        }
    }
    return self;
}

-(BOOL)checkTouchPoint:(UITouch*)touch
{
    CCSprite * bg = (CCSprite*)[self getChildByTag:kCCActionPointSpriteBG];
    return [bg rectContainTouchPoint:touch];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
{   
    if(![self checkTouchPoint:touch]) return NO;
    self.scale = 1.3;
    [self showResetAnimation];
    return YES;
}
// touch updates:
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
{
    self.scale = 1;
}
- (void) onEnter  
{  
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];  
    [super onEnter];  
}  
- (void) onExit  
{  
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];  
    [super onExit];  
} 

+(id)ccActionPointSprite
{
    return [[[self alloc] initActionPointSprite] autorelease];
}
-(void)showResetAnimation
{
    /*for (int i =0; i<5; i++)
    {
        CCSprite * gem =[CCSprite spriteWithFile:@"ActionPoints_Gem.png"];
        gem.opacity  = 0;
    }*/
    isReset = TRUE;
    [self showNextPointAnimation];
}

-(void)showNextPointAnimation
{
    if (pointIndex<pointNums) 
    {
        CCSprite * gem = (CCSprite*)[self getChildByTag:kCCActionPointSpriteBG+pointIndex+1];
        gem.opacity = 255;
        gem.scale   = 1.3;
        CCScaleTo * scaleTo   = [CCScaleTo actionWithDuration:0.2 scale:1];
        CCCallFunc * callBack= [CCCallFunc actionWithTarget:self selector:@selector(changeIndexAfterShowNext)];  
        CCSequence * sequence = [CCSequence actions:scaleTo,callBack, nil];
        [gem runAction:sequence];
    }
}

-(void)changeIndexAfterShowNext
{
    if (isReset&&pointIndex<=pointNums) {
        pointIndex++;
        [self showNextPointAnimation];
    }else{
        isReset = FALSE;
    }
    
}

-(void)showReduceAnimation
{
    if (pointIndex<=0) return;
    CCSprite * gem = (CCSprite*)[self getChildByTag:kCCActionPointSpriteBG-pointIndex+6];
    CCScaleTo * scaleTo   = [CCScaleTo actionWithDuration:0.2 scale:1.3];
    CCFadeOut * fadeOut   = [CCFadeOut actionWithDuration:0.2];
    
    CCSequence * sequence = [CCSequence actions:scaleTo,fadeOut, nil];
    [gem runAction:sequence];
    pointIndex--;
}

@end

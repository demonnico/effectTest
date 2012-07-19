//
//  CCValueSprite.m
//  effectTest
//
//  Created by Nicholas Tau on 3/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCValueSprite.h"

@implementation CCValueSprite


-(id)initWithValueType:(kCCValueSpriteType)type
{
    if((self=[super init])) 
    {
        
        [[CCTextureCache sharedTextureCache] addImage:@"texture.png"];
        
        CCSpriteFrameCache * frameCache = [ CCSpriteFrameCache sharedSpriteFrameCache ];
        [frameCache addSpriteFramesWithFile:@"texture.plist" ];
        

        CCSpriteFrame   * bgTexture    = [frameCache spriteFrameByName:@"Health-Background.png"];
        CCSpriteFrame   * yellowTexture= [frameCache spriteFrameByName:@"Health-EffectBar.png"];
        CCSpriteFrame   * greenTexture = [frameCache spriteFrameByName:@"Health-MainBar.png"];
        CCSpriteFrame   * redTexture   = [frameCache spriteFrameByName:@"Health-LowWarning.png"];
        
        CCSprite * bg              = [CCSprite spriteWithSpriteFrame:bgTexture];
        CCSprite * yellow          = [CCSprite spriteWithSpriteFrame:yellowTexture];
        CCSprite * green           = [CCSprite spriteWithSpriteFrame:greenTexture];
        CCSprite * red             = [CCSprite spriteWithSpriteFrame:redTexture];
        
        
        
        switch (type) 
        {
            case kCCValueTypeRL:
                yellow.anchorPoint = CGPointMake(0, 0.5);
                green.anchorPoint  = CGPointMake(0, 0.5);
                
                
                yellow.position = ccp(yellow.position.x-[yellow boundingBox].size.width/2, yellow.position.y);
                green.position = ccp(green.position.x-[green boundingBox].size.width/2, green.position.y);
                break;
            case kCCValueTypeLR:
                yellow.anchorPoint = CGPointMake(1, 0.5);
                green.anchorPoint  = CGPointMake(1, 0.5);
                
                
                yellow.position = ccp(yellow.position.x+[yellow boundingBox].size.width/2, yellow.position.y);
                green.position = ccp(green.position.x+[green boundingBox].size.width/2, green.position.y);
                break;
        }
        
        /*red.anchorPoint = CGPointMake(0, 0.5);
        red.scaleX = -0.5;*/
        [self addChild:bg     z:0 tag:kCCValueBG];
        [self addChild:red    z:0 tag:kCCValueRED];
        [self addChild:yellow z:0 tag:kCCValueYELLOW];
        [self addChild:green  z:0 tag:kCCValueGREEN];
        
    
        red.opacity = 0;
    }
    return self;
}

-(void)setValue:(float)hp
{
    CCSprite * green    = (CCSprite*)[self getChildByTag:kCCValueGREEN];
    if (hp==green.scaleX||green.scaleX<=0)  return;
    
    green.scaleX = hp;
    if (hp<=30&&green.scaleX>30) 
    {
        CCSprite * red    = (CCSprite*)[self getChildByTag:kCCValueRED];
        red.opacity       = 1;
        CCFadeOut * fadeOut = [CCFadeOut actionWithDuration:1];
        CCSequence * sequence=[CCSequence actions:fadeOut,[fadeOut reverse], nil];
        [red runAction:[CCRepeatForever actionWithAction:sequence]];
    }
    CCSprite  * yellow  = (CCSprite*)[self getChildByTag:kCCValueYELLOW];
    CCFadeOut  * fadeOut = [CCFadeOut actionWithDuration:0.7];
    CCCallFunc * func   = [CCCallFunc actionWithTarget:self selector:@selector(hideYellow)];
    [yellow runAction:[CCSequence actions:fadeOut,func,nil]];
    
}

-(void)hideYellow
{
    CCSprite * green    = (CCSprite*)[self getChildByTag:kCCValueGREEN];
    CCSprite  * yellow  = (CCSprite*)[self getChildByTag:kCCValueYELLOW];
    yellow.scaleX = green.scaleX;
    yellow.opacity= 255;
}

+(id)initWithType:(kCCValueSpriteType)type
{
    return [[[self alloc] initWithValueType:type] autorelease];
}

@end

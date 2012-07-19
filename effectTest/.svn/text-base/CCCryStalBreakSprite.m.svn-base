//
//  CCCryStalBreakSprite.m
//  effectTest
//
//  Created by Nicholas Tau on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCCryStalBreakSprite.h"



@implementation CCCryStalBreakSprite


-(id)initCryStalBreakSprite
{
    if ([self init])
    {
        for (int i =0; i<10; i++)
        {
            CCSprite * sprite = [CCSprite spriteWithFile:@"Crystal_BlueShard.png"];
            sprite.opacity = 0;
            [self addChild:sprite z:0 tag:kCCCryStalBreakSprite00+i];
        }
    }
    return self;
}

-(void)showAnimation:(kCCCryStalBreakDirect)direct
{
    for (int i=0; i<10; i++)
    {
        CCSprite * sprite   = (CCSprite*)[self getChildByTag:kCCCryStalBreakSprite00+i];
        sprite.position = ccp(0, 0 );
        sprite.rotation = 0;
        CCJumpTo * jumpTo   = [CCJumpTo actionWithDuration:0.3 
                                                  position:ccp((5+(CCRANDOM_0_1()+0.3)*10*i)*direct, (5-i)*CCRANDOM_0_1()*10) 
                                                    height:i*CCRANDOM_0_1()*3 
                                                     jumps:1];
        CCRotateTo * rotate = [CCRotateTo actionWithDuration:0.3 angle:5+CCRANDOM_0_1()*i*20];
        
        CCMoveBy * moveBy   = [CCMoveBy actionWithDuration:0.05 position:ccp(2*direct, -2)];
        id moveByBack = [moveBy reverse];
        CCFadeOut * fadeOut = [CCFadeOut actionWithDuration:0.2];
        
        
        CCSpawn *spawn = [CCSpawn actions:jumpTo,rotate, nil];
        CCSequence * sequence = [CCSequence actions:spawn,moveBy,moveByBack,fadeOut, nil];
        sprite.opacity = 255;
        [sprite runAction:sequence];
    }
}
+(id)ccCryStalBreakSprite
{
    return [[[self alloc] initCryStalBreakSprite] autorelease];
}

@end

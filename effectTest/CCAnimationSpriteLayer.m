//
//  CCAnimationSpriteLayer.m
//  effectTest
//
//  Created by Nicholas Tau on 4/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCAnimationSpriteLayer.h"

@interface CCAnimationSpriteLayer (privateMethod)

-(void)initMenuItem;


@end

@implementation CCAnimationSpriteLayer


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CCAnimationSpriteLayer *layer = [CCAnimationSpriteLayer node];

	// add layer as a child to scene
	[scene addChild: layer];
    [layer initMenuItem];
	// return the scene
	return scene;
}


-(void)showSprite
{
    CCGameSprite * sprite = [CCGameSprite spriteWithType:GameSprite0];
    sprite.position = ccp(100, 0);
    [self addChild:sprite z:0 tag:10086];
    [sprite doAnimationByType:MWSpriteNormal];
}

-(void)showAttack
{
    CCGameSprite * sprite = (CCGameSprite*)[self getChildByTag:10086];
    sprite.isMirror = YES;
    sprite.delegate = self;
    [sprite doAnimationByType:MWSpriteNormalAttack];
}

-(void)showMove
{
    CCGameSprite * sprite = (CCGameSprite*)[self getChildByTag:10086];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:NSStringFromCGPoint(ccp(100, 100)),
                              NSStringFromCGPoint(ccp(325, 100)),
                              NSStringFromCGPoint(ccp(325, 200)),nil];
    [sprite moveByPath:array];
}

-(void)showMagicAttacked
{
    CCGameSprite * sprite = (CCGameSprite*)[self getChildByTag:10086];
    [sprite doAnimationByType:MWSpriteMagicAttacked];
}

-(void)initMenuItem
{
    CCLabelTTF *label_0 = [CCLabelTTF labelWithString:@"showSprite" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_1 = [CCLabelTTF labelWithString:@"showAttack" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_2 = [CCLabelTTF labelWithString:@"showMove" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_3 = [CCLabelTTF labelWithString:@"showMagicAttacked" fontName:@"Marker Felt" fontSize:14];
    
    CCMenuItemLabel * menuItem0 = [CCMenuItemLabel itemWithLabel:label_0 target:self selector:@selector(showSprite)];
    CCMenuItemLabel * menuItem1 = [CCMenuItemLabel itemWithLabel:label_1 target:self selector:@selector(showAttack)];
    CCMenuItemLabel * menuItem2 = [CCMenuItemLabel itemWithLabel:label_2 target:self selector:@selector(showMove)];
    CCMenuItemLabel * menuItem3 = [CCMenuItemLabel itemWithLabel:label_3 target:self selector:@selector(showMagicAttacked)];
    
    menuItem1.position = ccp(menuItem1.position.x,menuItem1.position.y-20);
    menuItem2.position = ccp(menuItem2.position.x,menuItem2.position.y-40);
    menuItem3.position = ccp(menuItem3.position.x,menuItem3.position.y-60);
    
    CCMenu * menu = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,menuItem3, nil];
    menu.position = ccp(60, 300);
    [self addChild:menu];
    
}

-(void)didAfterAnimation:(id)sender Type:(NSString* )type
{
    NSLog(@"CCMWSpriteType:%@",type);
}

-(void)didAfterMoveByPath:(id)sender
{
    CCGameSprite * sprite = (CCGameSprite*)sender;
    NSLog(@"%@",NSStringFromCGPoint(sprite.position));
}

@end

//
//  MyCocos2DClass.h
//  effectTest
//
//  Created by Nicholas Tau on 4/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCMWSprite.h"


@protocol CCGameSpriteDelegate <NSObject>

-(void)didAfterMoveByPath:(id)sender;
-(void)didAfterAnimation:(id)sender Type:(NSString* )type;
@end


//Sprite 类型，1-9种
typedef enum 
{
    GameSprite0=0,
    GameSprite1,
    GameSprite2,
    GameSprite3,
    GameSprite4,
    GameSprite5,
    GameSprite6,
    GameSprite7,
    GameSprite8
}CCGameSpriteType;


//每种Sprite类型分别对应的几种类型动画
typedef enum 
{
    MWSpriteNormal=0,
    MWSpriteMove,
    MWSpriteNormalAttack,
    MWSpriteMagicAttack,
    MWSpriteNormalAttacked,
    MWSpriteMagicAttacked
}CCMWSpriteType;

@interface CCGameSprite : CCSprite <CCMWSpriteEventHandler,CCTargetedTouchDelegate>
{
    CGPoint * coordinate;
    CCGameSpriteType spriteType;
    CGRect  touchRect;
    id<CCGameSpriteDelegate> delegate;
    BOOL  isMirror;

}

@property (nonatomic) CCGameSpriteType spriteType;
@property (nonatomic) CGRect  touchRect;
@property (nonatomic,assign) id<CCGameSpriteDelegate> delegate;
@property (nonatomic,assign) BOOL isMirror;

+(CCGameSprite*)spriteWithType:(CCGameSpriteType)type;
-(void)moveByPath:(NSMutableArray*)paths;
-(void)doAnimationByType:(CCMWSpriteType)type;
-(void)stopAnimationByType:(CCMWSpriteType)type;
-(void)showHP:(CGFloat)hp;
-(void)showHeroDetail;
@end

//
//  MyCocos2DClass.m
//  effectTest
//
//  Created by Nicholas Tau on 4/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCGameSprite.h"


@interface CCGameSprite (privateMethod) 


-(void)initAnimationByType:(CCMWSpriteType)type;

-(void)stopAnimationByType:(CCMWSpriteType)type;

-(BOOL) rectContainTouchPoint:(UITouch*)touch;

@end

@implementation CCGameSprite

@synthesize spriteType;
@synthesize touchRect;
@synthesize isMirror;
@synthesize delegate;

+(CCGameSprite*)spriteWithType:(CCGameSpriteType)type;
{
    CCGameSprite * sprite =  [[CCGameSprite alloc] init];
    sprite.spriteType = type;
    sprite.touchRect  = CGRectMake(0, 0, 100, 100);
    for (int animationType =MWSpriteNormal; animationType<6; animationType++) 
    {
        [sprite initAnimationByType:(CCMWSpriteType)animationType];
    }
    
    
    return [sprite autorelease];
}

-(void)setIsMirror:(BOOL)mirror
{
    for (CCMWSprite * sprite in [self children])
    {
        if(sprite&&[sprite isMemberOfClass:[CCMWSprite class]])
        {
            sprite.mirror = mirror;
        }
    }
}

-(void)moveByPath:(NSMutableArray*)paths
{
    [self doAnimationByType:MWSpriteMove];
    NSMutableArray * actionArray = [NSMutableArray arrayWithCapacity:[paths count]];
    
    for ( NSString * pos in paths) 
    {
        CGPoint point = CGPointFromString(pos);
        CCMoveTo * move     = [CCMoveTo actionWithDuration:1 position:point];
        [actionArray addObject:move];
    }
    
    CCCallFunc * function =[CCCallFunc actionWithTarget:self selector:@selector(didAfterMove)]; 
    [actionArray addObject:function];
    CCSequence * seq = [CCSequence actionsWithArray:actionArray];
    [self runAction:seq];
}


-(void)doAnimationByType:(CCMWSpriteType)type
{
    
    CCMWSprite * normal = (CCMWSprite*)[self getChildByTag:MWSpriteNormal];
    [normal stopAnimation];
    normal.visible = NO;
    
    CCMWSprite * spriteAnimation = (CCMWSprite*)[self getChildByTag:type];
    spriteAnimation.visible       = YES;
    [spriteAnimation startAnimation];
}

-(void)didAfterMove
{
    
    CCMWSprite * move = (CCMWSprite*)[self getChildByTag:MWSpriteMove];
    move.visible  = NO;
    [move stopAnimation];
    
    CCMWSprite * normal = (CCMWSprite*)[self getChildByTag:MWSpriteNormal];
    normal.visible = YES;
    if (delegate&&[delegate conformsToProtocol:@protocol(CCGameSpriteDelegate)]) 
    {
        if([delegate respondsToSelector:@selector(didAfterMoveByPath:)])
        [delegate performSelector:@selector(didAfterMoveByPath:) withObject:self];
    }
}

-(void)initAnimationByType:(CCMWSpriteType)type
{
    NSArray    * imageList;
    NSString   * fileName;
    
    switch (type) {
        case  MWSpriteNormal:
        {
            imageList = [NSArray arrayWithObjects:@"dongzuo.png", nil];
            fileName  = @"test2.anu";
            break;
        }
        case  MWSpriteMove:
        {
            imageList = [NSArray arrayWithObjects:@"dongzuo.png", nil];
            fileName  = @"test2.anu";
            break;
        }
        case  MWSpriteNormalAttack:
        {
            imageList = [NSArray arrayWithObjects:@"dongzuo.png", nil];
            fileName  = @"test3.anu";
            break;
        }
        case  MWSpriteMagicAttack:
        {
            imageList = [NSArray arrayWithObjects:@"dongzuo.png", nil];
            fileName  = @"test4.anu";
            break;
        }
        case  MWSpriteNormalAttacked:
        {
            imageList = [NSArray arrayWithObjects:@"dongzuo.png", nil];
            fileName  = @"test4.anu";
            break;
        }
        case  MWSpriteMagicAttacked:
        {
            imageList = [NSArray arrayWithObjects:@"texiao.png", nil];
            fileName  = @"test1.anu";
            break;
        } 
    }
    
    CCMWSprite * sprite = [[CCMWSprite alloc] initWithMWFile:fileName   withImageList:imageList withAnimationIndex:0];
    sprite.minFrameInterval = 0.1;
    sprite.delegate  = self;
    sprite.position  = ccp(0, 0);
    sprite.visible   = NO;
    [self addChild:sprite z:0 tag:type];
    [sprite release];
}

- (void)didMWAnimationFrameChanged:(int) animationIndex_ sender:(CCMWSprite*) sprite_
{

}
- (void)didMWAnimationEnded:(int) animationIndex_ sender:(CCMWSprite*) sprite_
{
    
    int tag = sprite_.tag;
    
    CCMWSprite * currentAnimation =   (CCMWSprite*)[self getChildByTag:tag];
    switch (tag)
    {
        case  MWSpriteNormal:
        {
            
            break;
        }
        case  MWSpriteMove:
        {
            break;
        }
        case  MWSpriteNormalAttack:
        {
            [currentAnimation stopAnimation];
            currentAnimation.visible = NO;
            break;
        }
        case  MWSpriteMagicAttack:
        {
            break;
        }
        case  MWSpriteNormalAttacked:
        {
            break;
        }
        case  MWSpriteMagicAttacked:
        {
            [currentAnimation stopAnimation];
            currentAnimation.visible = NO;
            break;
        }   
    }
    CCMWSprite * spriteNormal =   (CCMWSprite*)[self getChildByTag:MWSpriteNormal];
    if(!spriteNormal.visible)
    {
        spriteNormal.visible = YES;
        [spriteNormal startAnimation];
    }
    
    
    if (tag!=MWSpriteNormal&&
        tag!=MWSpriteMove)
    {
        if (delegate&&[delegate conformsToProtocol:@protocol(CCGameSpriteDelegate)]) 
        {
            if([delegate respondsToSelector:@selector(didAfterAnimation:Type:)])
                [delegate performSelector:@selector(didAfterAnimation:Type:) withObject:self withObject:[NSString stringWithFormat:@"%d",tag]];
        }
    }
}

-(void)stopAnimationByType:(CCMWSpriteType)type;
{
    CCMWSprite * sprite =   (CCMWSprite*)[self getChildByTag:type];
    [sprite stopAnimation];
    sprite.visible = NO;
}   

-(void)showHP:(CGFloat)hp
{

}

-(void)showHeroDetail
{
    switch (spriteType) 
    {
        case GameSprite0:
            
            break;
        case GameSprite1:
            
            break; 
        default:
            break;
    }
}
/*
- (void)onEnter{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
    [super onEnter];
}

- (void)onExit{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
} 

*/

-(BOOL) rectContainTouchPoint:(UITouch*)touch
{
    CGPoint  point  = [self convertTouchToNodeSpaceAR:touch];
    
    
    CGRect   rect   = self.touchRect;
    rect.origin.x   = -rect.size.width/2;
    rect.origin.y   = -rect.size.height/2;
    BOOL isTouch = CGRectContainsPoint(rect,point);
    
    return  isTouch;
}
/*
-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
    BOOL isTouch = [self rectContainTouchPoint:touch];
    if(isTouch)
    {
        self.scale = 1.3;
        return YES;
    }
	return FALSE;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{   
    
    BOOL isTouch = [self rectContainTouchPoint:touch];
    
    if (isTouch)
    {
        CGPoint point = [touch locationInView:[touch view]];
        point = [[CCDirector sharedDirector] convertToGL:point];
        self.position  =  point;
        self.rotation  = 45;
    }
    
}

-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
	//[self resetRibbon];
    self.scale     = 1;
    self.rotation  = 0;
    
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector] convertToGL:point];
    NSLog(NSStringFromCGPoint(point));
    
    NSLog(NSStringFromCGRect(self.textureRect));
}
*/
-(void)dealloc
{

}

@end

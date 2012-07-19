//
//  MyTileMap.m
//  effectTest
//
//  Created by Nicholas Tau on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTileMap.h"
#import "CCTMXLayer.h"

@implementation MyTileMap

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MyTileMap *layer = [MyTileMap node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
    {
        [[CCTextureCache sharedTextureCache] addImage:@"tmw_desert_spacing.pngg"];
        
		CCTMXTiledMap * tileMap = [CCTMXTiledMap  tiledMapWithTMXFile:@"test.tmx"];
        
        CCTMXLayer *  layer =[tileMap layerNamed:@"firstLayer"];
        
        CCSprite * sprite0 = [layer tileAt:ccp(5, 5)];
        CCSprite * sprite1 = [layer tileAt:ccp(6, 5)];
        CCSprite * sprite2 = [layer tileAt:ccp(4, 5)];
        CCSprite * sprite3 = [layer tileAt:ccp(5, 6)];
        CCSprite * sprite4 = [layer tileAt:ccp(5, 4)];
        
       
        [NSThread detachNewThreadSelector:@selector(showSpriteAnimation:) toTarget:self withObject:sprite0];
        [NSThread detachNewThreadSelector:@selector(showSpriteAnimation:) toTarget:self withObject:sprite1];
        [NSThread detachNewThreadSelector:@selector(showSpriteAnimation:) toTarget:self withObject:sprite2];
        [NSThread detachNewThreadSelector:@selector(showSpriteAnimation:) toTarget:self withObject:sprite3];
        [NSThread detachNewThreadSelector:@selector(showSpriteAnimation:) toTarget:self withObject:sprite4];
        
        
        
        [self addChild:tileMap];
		
	}
	return self;
}

-(void)showSpriteAnimation:(CCSprite*)sprite
{
    CCTintTo * tint = [CCTintTo actionWithDuration:1 red:100 green:255 blue:255];
    CCTintTo * back = [CCTintTo actionWithDuration:1 red:255 green:255 blue:255];
    
    CCSequence * sequnce = [CCSequence actions:tint,back, nil];
    [sprite runAction:[CCRepeatForever actionWithAction:sequnce]];
}

-(void)colorAnimation
{

}

@end

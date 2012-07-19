//
//  HelloWorldLayer.m
//  effectTest
//
//  Created by Nicholas Tau on 3/19/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "CCValueSprite.h"
#import "CCKnockSprite.h"
#import "CCStarSprite.h"
#import "CCCryStalBreakSprite.h"
#import "CCSpriteHelper.h"
#import "CCActionPointSprite.h"
#import "MyTileMap.h"
#import "CCHexLayer.h"

@interface CCAnimation (customMethod) 

-(void) addFrameWithFilename:(NSString*)filename postion:(CGPoint)pos;
-(void) setPosition:(CGPoint)pos;
    
@end


@implementation CCAnimation(customMethod)

-(void) addFrameWithFilename:(NSString*)filename postion:(CGPoint)pos
{
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    CGRect rect = CGRectZero;
    rect.size   = texture.contentSize;
    rect.origin = pos;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rect:rect];
    [frames_ addObject:frame];
}

-(void) setPosition:(CGPoint)pos
{
    for (CCSpriteFrame * frame in frames_)
    {
        frame.rect = CGRectMake(pos.x, pos.y, frame.rect.size.width, frame.rect.size.height);
    }
    
}

@end



@interface HelloWorldLayer (private) 
-(void)showAnimation:(id)sender data:(NSArray*)data;
-(void)showAnimation:(id)sender postions:(NSArray *)data;
@end

typedef enum 
{
    effectArrow ,
    effectThunder0,
    effectThunder1,
    effectStar,
    effectKnockOutSprite,
    effectValue,
    effectCrystal,
    effecSpriteMove,
    effecActionPoint

}effectEnum;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
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
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label_0 = [CCLabelTTF labelWithString:@"showArrow" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_1 = [CCLabelTTF labelWithString:@"showThunder" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_2 = [CCLabelTTF labelWithString:@"showStars" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_3 = [CCLabelTTF labelWithString:@"showKnock" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_4 = [CCLabelTTF labelWithString:@"showValue" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_5 = [CCLabelTTF labelWithString:@"showCryStal" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_6 = [CCLabelTTF labelWithString:@"showActionPoint" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_7 = [CCLabelTTF labelWithString:@"showMyTileMap" fontName:@"Marker Felt" fontSize:14];
        
        CCLabelTTF *label_8 = [CCLabelTTF labelWithString:@"showHexMap" fontName:@"Marker Felt" fontSize:14];
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
        
        CCMenuItemLabel * menuItem0 = [CCMenuItemLabel itemWithLabel:label_0 target:self selector:@selector(showArrowAnimation)];
        CCMenuItemLabel * menuItem1 = [CCMenuItemLabel itemWithLabel:label_1 target:self selector:@selector(showThunderAnimation)]; 
        CCMenuItemLabel * menuItem2 = [CCMenuItemLabel itemWithLabel:label_2 target:self selector:@selector(showStars)]; 
        CCMenuItemLabel * menuItem3 = [CCMenuItemLabel itemWithLabel:label_3 target:self selector:@selector(showKnock)]; 
        CCMenuItemLabel * menuItem4 = [CCMenuItemLabel itemWithLabel:label_4 target:self selector:@selector(showValue)]; 
        CCMenuItemLabel * menuItem5 = [CCMenuItemLabel itemWithLabel:label_5 target:self selector:@selector(showCrystal)];
        CCMenuItemLabel * menuItem6 = [CCMenuItemLabel itemWithLabel:label_6 target:self selector:@selector(showReduceAnimation)];
        CCMenuItemLabel * menuItem7 = [CCMenuItemLabel itemWithLabel:label_7 target:self selector:@selector(showMyMap)];
        CCMenuItemLabel * menuItem8 = [CCMenuItemLabel itemWithLabel:label_8 target:self selector:@selector(showHexMap)];
        
        menuItem1.position = ccp(menuItem1.position.x,menuItem1.position.y+20);
        menuItem2.position = ccp(menuItem2.position.x,menuItem2.position.y+40);
        menuItem3.position = ccp(menuItem3.position.x,menuItem3.position.y+60);
        menuItem4.position = ccp(menuItem4.position.x,menuItem4.position.y+80);
        menuItem5.position = ccp(menuItem5.position.x,menuItem5.position.y+100);
        menuItem6.position = ccp(menuItem6.position.x,menuItem6.position.y+120);
        menuItem7.position = ccp(menuItem7.position.x,menuItem7.position.y+140);
        menuItem8.position = ccp(menuItem8.position.x,menuItem8.position.y-20);
        
        CCMenu * menu = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,menuItem3,menuItem4,menuItem5,menuItem6,menuItem7,menuItem8, nil];
		// position the label on the center of the screen
		//label.position =  ccp( size.width /2 , size.height/2 );
		menu.position  =  ccp( size.width /2 , size.height/2 );
		// add the label as a child to this Layer
		[self addChild: menu];
        
        
         //add arrow
        CCSprite * arrow = [CCSprite spriteWithFile:@"ArrowProjectile.png"];
        
        arrow.position   = ccp(10,10);
        arrow.rotation   = -45;
        [self addChild:arrow z:1 tag:effectArrow];
        
        //add thunder
        CCSprite * thunder = [CCSprite spriteWithFile:@"Projectile_Lightning.png"];
        thunder.position = ccp(100,200); 
        [self addChild:thunder z:-1 tag:effectThunder0];
       
        CCValueSprite * timer = [CCValueSprite initWithType:kCCValueTypeLR];
        [self addChild:timer z:1 tag:effectValue];
        timer.position =ccp(300, 215);
        
        CCKnockSprite * knock = [CCKnockSprite ccKnockSprite];
        knock.position = ccp(300, 200);
        [self addChild:knock z:0 tag:effectKnockOutSprite];
        
        CCStarSprite * star = [CCStarSprite ccStarSprite];
        star.position = ccp(400, 150);
        [self addChild:star z:0  tag:effectStar];
        
        CCCryStalBreakSprite * crystal = [CCCryStalBreakSprite ccCryStalBreakSprite];
        crystal.position = ccp(400, 250);
        [self addChild:crystal z:0  tag:effectCrystal];
        
        CCSprite *sprite = [CCSprite spriteWithFile:@"sprite.png"];
        sprite.position  = ccp(200, 200);
        [self addChild:sprite z:2 tag:effecSpriteMove];
        
        self.isTouchEnabled = YES;
        
        CCActionPointSprite * actionPoint = [CCActionPointSprite ccActionPointSprite];
        [self addChild:actionPoint z:0 tag:effecActionPoint];
        actionPoint.position = ccp(20, 300);
        
        
	}
	return self;
}

-(void)showHexMap
{
    CCScene * map = [CCHexLayer scene];
    [[CCDirector sharedDirector] pushScene:map];
}

-(void)showMyMap
{
    CCScene * map = [MyTileMap scene];
    [[CCDirector sharedDirector] pushScene:map];
}

-(void)showReduceAnimation
{
    CCActionPointSprite * actionPoint = (CCActionPointSprite*)[self getChildByTag:effecActionPoint];
    [actionPoint showReduceAnimation];
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
    CCSprite *sprite = (CCSprite*)[self getChildByTag:effecSpriteMove];
    BOOL isTouch = [sprite rectContainTouchPoint:touch];
    if(isTouch)
    {
        NSLog(@"itTouched");
        sprite.scale = 1.3;
    }
	//[self addRibbonPoint:[MultiLayerScene locationFromTouch:touch]];
	
	// Always swallow touches.
	return YES;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{   
    
    CCSprite *sprite = (CCSprite*)[self getChildByTag:effecSpriteMove];
    BOOL isTouch = [sprite rectContainTouchPoint:touch];
    
    if (isTouch)
    {
        CCSprite *sprite = (CCSprite*)[self getChildByTag:effecSpriteMove];
        CGPoint point = [touch locationInView:[touch view]];
        point = [[CCDirector sharedDirector] convertToGL:point];
        sprite.position  =  point;
        sprite.rotation  = 45;
    }
    
}

-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
	//[self resetRibbon];
    CCSprite *sprite = (CCSprite*)[self getChildByTag:effecSpriteMove];
    sprite.scale     = 1;
    sprite.rotation  = 0;
}

-(void)showCrystal
{
    CCCryStalBreakSprite * crystal = (CCCryStalBreakSprite*)[self getChildByTag:effectCrystal];
    [crystal showAnimation:kCCCryStalBreakDirectR];
}

-(void)showValue
{
    CCValueSprite * timer = (CCValueSprite*)[self getChildByTag:effectValue];
    [timer setValue:0.5];
}

-(void)showKnock
{   
    CCKnockSprite * knock = (CCKnockSprite*)[self getChildByTag:effectKnockOutSprite];
    [knock showAnimation];
}



-(void)showStars
{
    CCStarSprite * sprite = (CCStarSprite*)[self getChildByTag:effectStar];
    [sprite showAnimation];
    
}
-(void)showArrowAnimation
{
    CCSprite * arrow = (CCSprite*)[self getChildByTag:effectArrow];
    
    [arrow stopAllActions];
    
    CCJumpTo * jump  = [CCJumpTo actionWithDuration:0.5 position:ccp(arrow.position.x+100, arrow.position.y) height:50 jumps:1];
    CCRotateTo * rotate = [CCRotateTo actionWithDuration:0.5 angle:45];
    
    CCSpawn * spawn  = [CCSpawn actions:jump,rotate, nil];
    
    CCCallFunc  * function = [CCCallFunc actionWithTarget:self selector:@selector(endArrowAnimation)];
    CCSequence * sequnce = [CCSequence actions:spawn,function, nil];
    
    [arrow runAction:sequnce];

}

-(void)endArrowAnimation
{
    CCSprite * arrow = (CCSprite*)[self getChildByTag:effectArrow];
    arrow.rotation = -45;
        
    CGSize size = [[CCDirector sharedDirector] winSize];
    if (arrow.position.x>=size.width) {
        arrow.position=ccp(10,arrow.position.y);
    }
}



-(void)showThunderAnimation                                                                                                                                                            
{
   
    /*CCTexture2D * texture0  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_Lightning.png"];
    CCTexture2D * texture1  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_Lightning2.png"];
    
    CCTexture2D * texture2  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_LightningBlam.png"];
    CCTexture2D * texture3  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_LightningBlam2.png"];
    
    CGSize size0 = texture0.contentSize;
    CGRect rect0 = CGRectMake(0, 0, size0.width, size0.height);
    
    CCSpriteFrame * frame0 = [CCSpriteFrame frameWithTexture:texture0 rect:rect0];
    CCSpriteFrame * frame1 = [CCSpriteFrame frameWithTexture:texture1 rect:rect0];
    
    CGSize size1 = texture2.contentSize;
    CGRect rect1 = CGRectMake(0, 0, size1.width, size1.height);
    
    CCSpriteFrame * frame2 = [CCSpriteFrame frameWithTexture:texture2 rect:rect1];
    CCSpriteFrame * frame3 = [CCSpriteFrame frameWithTexture:texture3 rect:rect1];
    
    NSArray * array0 = [NSArray arrayWithObjects:frame0,frame1, nil];
    NSArray * array1 = [NSArray arrayWithObjects:frame2,frame3, nil];

    CCAnimation * animation0 = [CCAnimation animationWithFrames:array0 delay:0.08];
    
    CCAnimate   * animate0   = [CCAnimate actionWithAnimation:animation0];
    
    CCAnimation * animation1 = [CCAnimation animationWithFrames:array1 delay:0.08];
    [animation1 setPosition:CGPointMake(size0.width/2, 0)];
    CCAnimate   * animate1   = [CCAnimate actionWithAnimation:animation1];
    
    CCSprite * thunder = (CCSprite*)[self getChildByTag:effectThunder];
    
    //CCSpeed *speed =[CCSpeed actionWithAction:animate1 speed:1.0f]; 
    CCSequence * sequnce = [CCSequence actions:animate0,animate1, nil];
    [thunder runAction:sequnce];*/
    
    
    
    /*NSMutableArray * params0 = [NSMutableArray arrayWithObjects:@"Projectile_Lightning.png",@"Projectile_Lightning2.png", nil];
    NSMutableArray * params1 = [NSMutableArray arrayWithObjects:@"Projectile_LightningBlam.png",@"Projectile_LightningBlam2.png", nil];
    

    NSArray * temp0 = [NSArray arrayWithObjects:@"30",@"20",@"-15", nil];
    [params0 addObject:temp0];
    
    NSArray * temp1 = [NSArray arrayWithObjects:@"50",@"20",@"0", nil];
    [params1 addObject:temp1];
    
    CCCallFuncND  * function0 = [CCCallFuncND actionWithTarget:self selector:@selector(showAnimation:data:) data:params0];
    CCCallFuncND  * function1 = [CCCallFuncND actionWithTarget:self selector:@selector(showAnimation:data:) data:params1];
    
    CCCallFunc * test = [CCCallFunc actionWithTarget:self selector:@selector(test)];
    CCSequence * sequence = [CCSequence actions:function0,test, nil];
    
    //[self runAction:sequence];
    [self showAnimation:self data:params0];
    [self showAnimation:self data:params1];*/
    
    NSString * postion = NSStringFromCGPoint(CGPointMake(50, 50));
    NSString * postion1 = NSStringFromCGPoint(CGPointMake(100, 100));
    NSString * postion2 = NSStringFromCGPoint(CGPointMake(50, 50));

    NSArray *array = [NSArray arrayWithObjects:postion,postion1,postion2,nil];
    [self showAnimation:self postions:array];
    
    
    
}

-(void)test
{
    
}
/*
-(void)showAnimation:(id)sender data:(NSArray*)data
{
    
    NSArray * params = [data objectAtIndex:[data count]-1];
    float x       = [[params objectAtIndex:0] floatValue];
    float y       = [[params objectAtIndex:1] floatValue];
    float rotate  = [[params objectAtIndex:2] floatValue];
    
    NSMutableArray * frameArray = [NSMutableArray arrayWithCapacity:[data count]];
    for (id  path in data) 
    {
        if (![path isKindOfClass:[NSString class]]) break;
        CCTexture2D * texture  = [[CCTextureCache sharedTextureCache] addImage:path];
        CGSize size = texture.contentSize;
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        CCSpriteFrame * frame = [CCSpriteFrame frameWithTexture:texture rect:rect];
        [frameArray addObject:frame];
    }
    
    CCAnimation * animation = [CCAnimation animationWithFrames:frameArray delay:0.08];
    CCAnimate   * animate   = [CCAnimate actionWithAnimation:animation];
    CCSprite * sprite = [CCSprite spriteWithFile:[data objectAtIndex:0]];
    sprite.position = ccp(x,y);
    sprite.rotation = rotate;
    [self addChild:sprite];
    CCCallFuncND *function = [CCCallFuncND actionWithTarget:self selector:@selector(removeThunder:) data:sprite];
    
    CCSequence * sequence = [CCSequence actions:animate,function, nil];
    [sprite runAction:sequence];
}
*/
-(void)showAnimation:(id)sender postions:(NSArray *)data
{   
    
    CCSprite * thunder = (CCSprite*)[self getChildByTag:effectThunder0];
    if(!thunder)  
    {
        thunder = [CCSprite spriteWithFile:@"Projectile_Lightning.png"];
        thunder.tag =0;
        thunder.position = CGPointFromString([data objectAtIndex:thunder.tag]);
    }
   // if (thunder.tag>[data count]) return;
    CGPoint  origin     = CGPointFromString([data objectAtIndex:thunder.tag]);
    CGPoint  firstPoint = CGPointFromString([data objectAtIndex:thunder.tag+1]);
    
    float length_x  = abs(origin.x-firstPoint.x);
    float length_y  = abs(origin.y-firstPoint.y);
    
    double rotate   = atan(length_x/length_y);
    
    
    if (thunder.tag%2==0)
    {
        thunder.position = origin;
    }else{
        thunder.position = ccp(origin.x+50,origin.y);
    }
    
    thunder.rotation = rotate*360;
    
     CCTexture2D * texture0  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_Lightning.png"];
     CCTexture2D * texture1  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_Lightning2.png"];
     
     CCTexture2D * texture2  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_LightningBlam.png"];
     CCTexture2D * texture3  = [[CCTextureCache sharedTextureCache] addImage:@"Projectile_LightningBlam2.png"];
     
     CGSize size0 = texture0.contentSize;
     CGRect rect0 = CGRectMake(0, 0, size0.width, size0.height);
     
     CCSpriteFrame * frame0 = [CCSpriteFrame frameWithTexture:texture0 rect:rect0];
     CCSpriteFrame * frame1 = [CCSpriteFrame frameWithTexture:texture1 rect:rect0];
     
     CGSize size1 = texture2.contentSize;
     CGRect rect1 = CGRectMake(0, 0, size1.width, size1.height);
     
     CCSpriteFrame * frame2 = [CCSpriteFrame frameWithTexture:texture2 rect:rect1];
     CCSpriteFrame * frame3 = [CCSpriteFrame frameWithTexture:texture3 rect:rect1];
     
     NSArray * array0 = [NSArray arrayWithObjects:frame0,frame1, nil];
     NSArray * array1 = [NSArray arrayWithObjects:frame2,frame3, nil];
     
     CCAnimation * animation0 = [CCAnimation animationWithFrames:array0 delay:0.08];
     
     CCAnimate   * animate0   = [CCAnimate actionWithAnimation:animation0];
     
     CCAnimation * animation1 = [CCAnimation animationWithFrames:array1 delay:0.08];
     [animation1 setPosition:CGPointMake(size0.width/2, 0)];
     CCAnimate   * animate1   = [CCAnimate actionWithAnimation:animation1];
    
     CCCallFuncN *function = [CCCallFuncN actionWithTarget:self selector:@selector(removeThunder:) ];
     CCSequence * sequence  = [CCSequence actions:animate0,function, nil];
     thunder.tag+=2;
     [thunder runAction:sequence];
}
/*
-(void)endAnimation:(id)sender
{
    CCSprite * sp = (CCSprite*)sender;
    if (sp.tag%2==0)
    {
        [sp setDisplayFrameWithAnimationName:@"Projectile_LightningBlam.png" index:0];
        [sp setDisplayFrameWithAnimationName:@"Projectile_LightningBlam2.png" index:1];
    }else{
        [sp setDisplayFrameWithAnimationName:@"Projectile_Lightning" index:0];
        [sp setDisplayFrameWithAnimationName:@"Projectile_Lightning2.png" index:1];
    }
}
*/
-(void)removeThunder:(CCSprite*)sprite
{
    if([sprite isKindOfClass:[CCSprite class]])[sprite removeFromParentAndCleanup:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

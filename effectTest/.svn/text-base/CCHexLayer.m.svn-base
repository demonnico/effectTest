//
//  CCHexLayer.m
//  effectTest
//
//  Created by Nicholas Tau on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCHexLayer.h"
#import "cocos2d.h"

#define SQRT_3 1.73205081

@implementation HexCoord

@synthesize row;
@synthesize col;

-(CGPoint)getXYCoord
{

    float s =  HEX_HEIGHT/2;
    
    float h = HEX_HEIGHT/4;
    float r = s*SQRT_3/2;
    
    float dis = row%2==0?0:r;
    
    float  x = col*(HEX_WIDTH-1)+dis;
    float  y = row*(s+h-1);
    
    x+= HEX_WIDTH*0.5;
    y+= HEX_HEIGHT*0.5;
    
    return  CGPointMake(x, y);
}

+(HexCoord*)hexCoordWithRow:(NSUInteger)row Col:(NSUInteger)col
{
    HexCoord * hexCoord = [[HexCoord alloc] init];
    hexCoord.row = row;
    hexCoord.col = col;
    
    return [hexCoord autorelease];
}

@end


typedef enum 
{
    CCHexLayerBG=0,
    CCAttackerLayer,
    CCDefenderLayer,
    CCStuffLayer
}CCHexLayers;

typedef enum 
{
    CCAttackerArmy=0,
    CCAttackerAirforce,
}CCAttackerType;

typedef enum 
{
    CCHexLayerAttacker=1000,
    CCHexLayerDefender0,
    CCHexLayerDefender1,
    CCHexLayerDefender2,
    CCHexLayerDefender3
}CCHexLayerSprite;

typedef enum 
{
    CCHexLayerStuff0=3000,
    CCHexLayerStuffSprite,
    CCHexLayerStuffEnd=3002
}CCHexLayerStuff;

@interface CCHexLayer (privateMethod) 

#pragma mark----通过行数和列数设置hexMap中的值
-(void)setMapValueByRow:(NSUInteger)row Col:(NSUInteger)col Value:(NSString*)value;
#pragma mark----通过行数和列数得到hexMap中对应的值
-(NSString*)getMapValueByRow:(NSUInteger)row Col:(NSUInteger)col;
#pragma mark----重置当前行列数的value至默认初始值
-(void)resetMapValueByRow:(NSUInteger)row Col:(NSUInteger)col;

#pragma mark----通过初始化六边形地图
-(void)initMapWithHexArray;


#pragma mark----通过水平扫描（middle->up->down)对攻击方可移动范围内对地图进行扫描(无法排除障碍物)**直接得到对应地图sprite**---
-(NSArray*)scanHexMapByRange:(NSUInteger)range;

#pragma mark----通过环绕递归对攻击方可移动范围内对地图进行扫描(对障碍物进行了排除)**直接得到对应地图sprite**---
-(NSArray*)scanHexMapRoundByRange:(NSUInteger)range;

#pragma mark---环绕递归算法的一个子方法，可得到所需扫描范围最外一圈的地图元素行列数**直接得到对应地图sprite**---
-(NSMutableArray*)roundHexMapByHexArray:(NSArray*)hexArray roundArray:(NSArray*)array;
#pragma mark---得到地图Sprite的行列数--
-(NSString*)getRowColBySprite:(CCSprite*)sprite;

#pragma mark---通过行列数得到当前地图sprite--
-(CCSprite*)getHexSpriteByRow:(NSUInteger)row Col:(NSUInteger)col;


#pragma mark---对移动范围的边界进行扫描+1，检查是否有可攻击的对象在其中--
-(void)checkEnemyByRange:(NSUInteger)range attakcerType:(CCAttackerType)type;    
@end


@implementation CCHexLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CCHexLayer *layer = [CCHexLayer node];
	
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
        CCLayerColor * color = [CCLayerColor layerWithColor:ccc4 (255, 0, 0,255)];
        [self addChild:color];
       
        
        hexMap    = [[NSMutableArray alloc] initWithCapacity:HEX_ROW];
        attackers = [[NSMutableArray alloc] init];
        defenders = [[NSMutableArray alloc] init];
        stuffs    = [[NSMutableArray alloc] init];
        
        
        [self initMapWithHexArray];
		        
        [self performSelector:@selector(initMenuItem)];
	}
	return self;
}

-(void)initMapWithHexArray
{   
    NSUInteger index = 0;

    for (int row=0;row<HEX_ROW; row++) 
    {
        NSMutableArray * cols  = [NSMutableArray arrayWithCapacity:HEX_COL];
        for (int col=0; col<HEX_COL; col++)
        {   
  
            CCSprite * sprite = [CCSprite spriteWithFile:@"hex.png"];
            
            HexCoord * coord  = [HexCoord hexCoordWithRow:row Col:col];;
            
            sprite.position = [coord getXYCoord];
            [self addChild:sprite z:CCHexLayerBG tag:index];
            [cols addObject:[NSString stringWithFormat:@"%d",index]];
            NSLog(@"row:%d col:%d  index = %d",row,col,index);
            index++;
        }
        [hexMap addObject:cols];
    }
    
}

-(NSString*)getMapValueByRow:(NSUInteger)row Col:(NSUInteger)col
{
    return [[hexMap objectAtIndex:row] objectAtIndex:col];
}

-(void) setMapValueByRow:(NSUInteger)row Col:(NSUInteger)col Value:(NSString*)value
{
    NSMutableArray * colArray =  [hexMap objectAtIndex:row];
    [colArray replaceObjectAtIndex:col withObject:value];
}

-(void)resetMapValueByRow:(NSUInteger)row Col:(NSUInteger)col 
{
    NSUInteger tag    = row*HEX_COL+col;
    [self setMapValueByRow:row Col:col Value:[NSString stringWithFormat:@"%d",tag]];
}

-(CCSprite*)getHexSpriteByRow:(NSUInteger)row Col:(NSUInteger)col
{
    
    if(row<HEX_ROW&&col<HEX_COL)
    {
        NSUInteger tag    = row*HEX_COL+col;
        CCNode    * child = [self getChildByTag:tag];
        if ([child isMemberOfClass:[CCSprite class]]) 
        {
            return (CCSprite*)child;
        }
    }
    return  nil;
    
}

-(void)dealloc
{
    [hexMap release];
    [attackers release];
    [defenders release];
    [stuffs release];
    [super dealloc];
}

#pragma mark----呈现我方单位
-(void)showAttacker
{
    
    CCSprite * attacker = (CCSprite*)[self getChildByTag:CCHexLayerAttacker];
    if(!attacker)
    {
        CCSprite * hexSprite  =  [self getHexSpriteByRow:ATTACKER_ROW Col:ATTACKER_COL];
        attacker = [CCSprite spriteWithFile:@"attacker.png"];
        attacker.position   = hexSprite.position;
        [self setMapValueByRow:ATTACKER_ROW Col:ATTACKER_COL Value:[NSString stringWithFormat:@"%d",CCHexLayerAttacker]];
        [self addChild:attacker z:1 tag:CCHexLayerAttacker];
        [attackers addObject:attacker];
    }
}

#pragma mark----呈现敌方单位
-(void)showDefender
{
    CCSprite * defender = (CCSprite*)[self getChildByTag:CCHexLayerDefender0];
    if(!defender)
    {   
        for (int i=0; i<3; i++) 
        {
            int row = DEFENDER_ROW+i;
            int col = DEFENDER_COL+i;
            CCSprite * defender_avatar  =  [self getHexSpriteByRow:row Col:col];
            defender = [CCSprite spriteWithFile:@"defender.png"];
            defender.position   = defender_avatar.position;
            NSUInteger  tag = CCHexLayerDefender0+i;
            [self setMapValueByRow:row Col:col Value:[NSString stringWithFormat:@"%d",tag]];
            [self addChild:defender z:1 tag:tag];
            
            [defenders addObject:defender];
        }

    }
    
}

#pragma mark----呈现我方单位可行动范围
-(void)showMoveRange
{
    //NSArray * ranges = [self scanHexMapByRange:ATTACK_RANGE];
    NSArray * ranges = [self scanHexMapRoundByRange:ATTACK_RANGE];
    
    for (CCSprite * range in ranges)
    {
        [range setColor:ccc3(0,255, 0)];
    }
    
   [self checkEnemyByRange:ATTACK_RANGE attakcerType:CCAttackerArmy];
    
}

-(NSArray*)scanHexMapRoundByRange:(NSUInteger)range
{
    int moveRange =range;
    
    NSMutableArray * ranges        = [NSMutableArray array];
    NSMutableArray * outLinerArray = [NSMutableArray array];
    
    
    int currentRow = ATTACKER_ROW;
    int currentCol = ATTACKER_COL;
    CCSprite * attacker = [self getHexSpriteByRow:currentRow Col:currentCol];
    [ranges addObject:attacker];
    [outLinerArray addObject:attacker];
    for (int index =0; index<moveRange; index++)
    {   
        outLinerArray =[self roundHexMapByHexArray:ranges roundArray:outLinerArray];
        
        for (int i =0;i<[outLinerArray count];i++)
        {
            if([stuffs containsObject:[outLinerArray objectAtIndex:i]])
            {
                [outLinerArray removeObjectAtIndex:i];
            }
        }
        for (CCSprite * sprite in outLinerArray)
        {
            [ranges addObject:sprite];
        }
    }

    return ranges;
}

-(NSMutableArray*)roundHexMapByHexArray:(NSArray*)hexArray roundArray:(NSArray*)array;
{
    NSMutableArray * newArray = [NSMutableArray array];
    for (CCSprite * sprite in array)
    {
        NSString * coorInfo = [self getRowColBySprite:sprite];
        NSArray  * array = [coorInfo componentsSeparatedByString:@","];
        int row = [[array objectAtIndex:0] intValue];
        int col = [[array objectAtIndex:1] intValue];
        
        
        if (row%2)
        {
            int left   = col-1;
            int right  = col+1;
            int up     = row+1;
            int down   = row-1;
            
            BOOL  leftCondition  = left>=0;
            BOOL  rightCondition = right<HEX_COL;
            BOOL  upCondition    = up<HEX_ROW;
            BOOL  downCondition  = down>=0;
            
            if (rightCondition&&upCondition)
            {
                CCSprite * sprite = [self getHexSpriteByRow:up Col:right];//hex_array[up][right];
                if(sprite)[newArray addObject:sprite];
            }
            if (upCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:up Col:col];
                if(sprite)[newArray addObject:sprite];
            }
            if (leftCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:row Col:left];
                if(sprite)[newArray addObject:sprite];
            }
            if (rightCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:row Col:right];
                if(sprite)[newArray addObject:sprite];
            }
            if (downCondition&&rightCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:down Col:right];
                if(sprite)[newArray addObject:sprite];
            }
            if (downCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:down Col:col];
                if(sprite)[newArray addObject:sprite];
            }
            
        }else{
            int left   = col-1;
            int right  = col+1;
            int up     = row+1;
            int down   = row-1;
            
            BOOL  leftCondition  = left>=0;
            BOOL  rightCondition = right<HEX_COL;
            BOOL  upCondition    = up<HEX_ROW;
            BOOL  downCondition  = down>=0;
            
            if (leftCondition&&upCondition)
            {
                CCSprite * sprite = [self getHexSpriteByRow:up Col:left];
                if(sprite) [newArray addObject:sprite];
            }
            if (upCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:up Col:col];
                if(sprite) [newArray addObject:sprite];
            }
            if (leftCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:row Col:left];
                if(sprite) [newArray addObject:sprite];
            }
            if (rightCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:row Col:right];
                if(sprite) [newArray addObject:sprite];
            }
            if (downCondition&&leftCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:down Col:left];
                if(sprite) [newArray addObject:sprite];
            }
            if (downCondition) {
                CCSprite * sprite = [self getHexSpriteByRow:down Col:col];
                if(sprite) [newArray addObject:sprite];
            }
        }
    }
    
    NSArray *copy = [newArray copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([newArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [newArray removeObjectAtIndex:index];
        }
        index--;
    }
    [copy release];
    for (int i=0; i<[newArray count]; i++)
    {
        CCSprite * sprite = [newArray objectAtIndex:i];
        if([hexArray containsObject:sprite]||
           [stuffs containsObject:sprite])
        {
            [newArray removeObject:sprite];
        }
    }
    
    
    return newArray;
}

-(NSString*)getRowColBySprite:(CCSprite*)sprite;
{
    for (int i =0; i<HEX_ROW; i++) 
    {
        for(int j=0;j<HEX_COL;j++)
        {
            if (sprite==[self getHexSpriteByRow:i Col:j])
            {
                return  [NSString stringWithFormat:@"%d,%d",i,j];
            }
        }
    }
    return nil;
}

-(NSArray*)scanHexMapByRange:(NSUInteger)range
{
    int moveRange =range;
    
    NSMutableArray * ranges = [NSMutableArray array];
    
    int rangeColBegin= ATTACKER_COL-moveRange;
    int rangeColMax  = ATTACKER_COL+moveRange;
    
    int upRangeRowBegin  = ATTACKER_ROW+1;
    int upRangeRowMax    = upRangeRowBegin +moveRange;
    
    int downRangeRowBegin= ATTACKER_ROW-1;
    int downRangeRowMax  = downRangeRowBegin-moveRange;
    
    for (int col =rangeColBegin; col<=rangeColMax; col++) 
    {
        if (col<0||col>HEX_COL) continue;
        CCSprite * value =[self getHexSpriteByRow:ATTACKER_ROW Col:col];
        if(value)[ranges addObject:value];
    }
    
    for (int uprow =upRangeRowBegin;uprow<upRangeRowMax; uprow++)
    {
        if(uprow>=HEX_ROW)break;
        if (uprow%2==0)
        {
            rangeColBegin++;
            rangeColMax++;
        }
        rangeColMax--;
        for (int col =rangeColBegin; col<=rangeColMax; col++) 
        {
            if (col<0||col>HEX_COL) continue;
            CCSprite * value =[self getHexSpriteByRow:uprow Col:col];
            if(value)  [ranges addObject:value];

        }
    }
    
    
    rangeColBegin= ATTACKER_COL-moveRange;
    rangeColMax  = ATTACKER_COL+moveRange;
    for (int downrow =downRangeRowBegin ;downrow>downRangeRowMax; downrow--)
    {
        if(downrow<0)break;
        if (downrow%2==0)
        {
            rangeColBegin++;
            rangeColMax++;
        }
        rangeColMax--;
        for (int col =rangeColBegin; col<=rangeColMax; col++) 
        {
            if (col<0||col>HEX_COL) continue;
            CCSprite * value =[self getHexSpriteByRow:downrow Col:col];
            if(value)[ranges addObject:value];
        }
    }
    return ranges;
}


/*
 *算法有待改进，并且动画应在独立线程中执行
 */
-(void)checkEnemyByRange:(NSUInteger)range attakcerType:(CCAttackerType)type;
{
    NSArray * ranges = [self scanHexMapByRange:range+1];
    
    switch (type) 
    {
        case CCAttackerAirforce:
            ranges = [self scanHexMapByRange:range+1];
            break;
        case  CCAttackerArmy :
            ranges = [self scanHexMapRoundByRange:range+1];
            break;
    }
    
    int i =0;
    for (CCSprite * range in ranges)
    {
        NSLog(@"index:%d x:%f,y:%f",i,range.position.x,range.position.y);
        i++;
        for (CCSprite * defender in  defenders)
        {
            if (defender.position.x==range.position.x&&
                defender.position.y==range.position.y) 
            {
                CCTintTo * tint = [CCTintTo actionWithDuration:0.5 red:0 green:255 blue:0];
                CCTintTo * back = [CCTintTo actionWithDuration:0.5 red:255 green:0 blue:0];
                CCSequence * sequence = [CCSequence actions:tint,back, nil];
                [range runAction:[CCRepeatForever actionWithAction:sequence]];
            }
        }
    }
}

-(void)showTarget
{
    CCSprite * target   =  [self getHexSpriteByRow:TARGET_ROW Col:TARGET_COL];
    CCTintTo * tint     = [CCTintTo actionWithDuration:0.5 red:255 green:0 blue:0];
    CCTintTo * back     = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
    CCSequence * sequence = [CCSequence actions:tint,back, nil];
    [target runAction:[CCRepeatForever actionWithAction:sequence]];
}

-(void)showStuff
{
    NSString * point0 = NSStringFromCGPoint(ccp(4, 5));
    NSString * point1 = NSStringFromCGPoint(ccp(3, 4));
    NSString * point2 = NSStringFromCGPoint(ccp(5, 4));
    
    NSArray * array = [NSArray arrayWithObjects:point0,point1,point2, nil];
    for (NSString * str in  array)
    {
        CGPoint point = CGPointFromString(str);
        CCSprite * stuff  =  [self getHexSpriteByRow:point.x Col:point.y];
        [stuff setColor:ccc3(0,0, 0)];
        [self setMapValueByRow:point.x Col:point.y  Value:[NSString stringWithFormat:@"%d",CCHexLayerStuff0]];
        [stuffs addObject:stuff];
    }
}

-(void)showMoveToTarget
{
    
    NSString * stuff0 = [NSString stringWithFormat:@"%d",CCHexLayerStuff0];
    NSString * stuff1 = [NSString stringWithFormat:@"%d",CCHexLayerStuffSprite];
    
    NSMutableArray * stuffArray = [NSMutableArray arrayWithObjects:stuff0,stuff1, nil];
    
    for (int i =0; i<3; i++)
    {
        [stuffArray addObject:[NSString stringWithFormat:@"%d",CCHexLayerDefender0+i]];
    }
    PathFinder * finder =  [PathFinder  pathFinderWithMap:hexMap Hit:stuffArray];
    NSArray* nodes =  [finder searchPathWithStart:ccp(ATTACKER_ROW, ATTACKER_COL) End:ccp(TARGET_ROW,TARGET_COL)];
    for (Node * node in nodes)
    {
        NSLog(@"node(row:%f col:%f)",node.pos.x,node.pos.y);
    }
    
    
    NSMutableArray * mutableArray = [NSMutableArray arrayWithArray:nodes];
    
    [self performSelector:@selector(moveToTarget:) withObject:mutableArray];
}

-(void)moveToTarget:(NSMutableArray*)array
{
    
    Node * currentNode = [array objectAtIndex:0];
    
    [array removeObject:currentNode];
    
    NSMutableArray * actionArray = [NSMutableArray array];
    
    for ( Node * node in array) 
    {
        NSUInteger currentRow      = currentNode.pos.x;
        NSUInteger currentCol      = currentNode.pos.y;
        
        NSUInteger row      = node.pos.x;
        NSUInteger col      = node.pos.y;
        
        [self resetMapValueByRow:currentRow Col:currentCol];
        CCSprite * target   = [self getHexSpriteByRow:row Col:col];
        CCMoveTo * move     = [CCMoveTo actionWithDuration:0.3 position:target.position];
        [self setMapValueByRow:row Col:col Value:[NSString stringWithFormat:@"%d",CCHexLayerAttacker]];
        currentNode = node;
        [actionArray addObject:move];
    }
    CCSequence * seq = [CCSequence actionsWithArray:actionArray];
    CCSprite * attacker = (CCSprite*)[self getChildByTag:CCHexLayerAttacker];
    [attacker runAction:seq];
}

-(void)initMenuItem
{
    CCLabelTTF *label_0 = [CCLabelTTF labelWithString:@"showAttacker" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_1 = [CCLabelTTF labelWithString:@"showDefender" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_2 = [CCLabelTTF labelWithString:@"showMoveRange" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_3 = [CCLabelTTF labelWithString:@"showTarget" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_4 = [CCLabelTTF labelWithString:@"showStuff" fontName:@"Marker Felt" fontSize:14];
    CCLabelTTF *label_5 = [CCLabelTTF labelWithString:@"showMoveToTarget" fontName:@"Marker Felt" fontSize:14];
    
    CCMenuItemLabel * menuItem0 = [CCMenuItemLabel itemWithLabel:label_0 target:self selector:@selector(showAttacker)];
    CCMenuItemLabel * menuItem1 = [CCMenuItemLabel itemWithLabel:label_1 target:self selector:@selector(showDefender)];
    CCMenuItemLabel * menuItem2 = [CCMenuItemLabel itemWithLabel:label_2 target:self selector:@selector(showMoveRange)]; 
    CCMenuItemLabel * menuItem3 = [CCMenuItemLabel itemWithLabel:label_3 target:self selector:@selector(showTarget)]; 
    CCMenuItemLabel * menuItem4 = [CCMenuItemLabel itemWithLabel:label_4 target:self selector:@selector(showStuff)]; 
    CCMenuItemLabel * menuItem5 = [CCMenuItemLabel itemWithLabel:label_5 target:self selector:@selector(showMoveToTarget)]; 
    
    menuItem1.position = ccp(menuItem1.position.x,menuItem1.position.y-20);
    menuItem2.position = ccp(menuItem2.position.x,menuItem2.position.y-40);
    menuItem3.position = ccp(menuItem3.position.x,menuItem3.position.y-60);
    menuItem4.position = ccp(menuItem4.position.x,menuItem4.position.y-80);
    menuItem5.position = ccp(menuItem5.position.x,menuItem5.position.y-100);
    
    CCMenu * menu = [CCMenu menuWithItems:menuItem0,menuItem1,menuItem2,menuItem3,menuItem4,menuItem5, nil];
    menu.position = ccp(60, 300);
    [self addChild:menu];
    
}

@end

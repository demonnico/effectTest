//
//  PathFinder.m
//  effectTest
//
//  Created by Nicholas Tau on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PathFinder.h"

@implementation Node

@synthesize pos;
@synthesize gValue;
@synthesize hValue;
@synthesize parent;


+(Node*)nodeWithPos:(CGPoint)point
{
    Node * node = [[Node alloc] init];
    node.pos    = point;
    return [node autorelease];
}

-(int)getHValue:(Node*)node
{
    int x1 = pos.x; 
    int y1 = pos.y;
    int x2 = node.pos.x; 
    int y2 = node.pos.y;
    
    int m  = abs(x2-x1);
    int n  =  abs(y2-y1)/2;
    
    int d;
    if(m<=n) d = abs(y2-y1);
    else
    {
        if(x2>x1)
        {
            if(y1%2==0) d = abs(x2-x1) + (int)ceil(abs(y2-y1)/2.0);
            else d = abs(x2-x1) + (int)floor(abs(y2-y1)/2.0);
        }
        else 
        {
            if(y1%2==0) d = abs(x2-x1) + (int)floor(abs(y2-y1)/2.0);
            else d = abs(x2-x1) + (int)ceil(abs(y2-y1)/2.0);    
        }
        
    }
    
    return d;
}

-(BOOL)equals:(Node*)node
{
    if (pos.x == node.pos.x && pos.y == node.pos.y) return true;
    else return false; 
}

-(int)compareValueTo:(Node*)node
{
    int a1 = gValue + hValue; 
    int a2 = node.gValue + node.hValue; 
    if (a1 < a2) return -1;
    else if (a1 == a2) return 0;
    else return 1;
}

-(NSMutableArray*)getNeighbors
{
    NSMutableArray * neighbors = [NSMutableArray array]; 
    
    int x = pos.x; 
    int y = pos.y; 
    
    if(x > 0) [neighbors addObject:[Node nodeWithPos:CGPointMake(x-1, y)]];
    if(x < 13)[neighbors addObject:[Node nodeWithPos:CGPointMake(x+1, y)]];
    
    if(y%2==1)
    {
        if(y < 9)           [neighbors addObject:[Node nodeWithPos:CGPointMake(x, y+1)]];
        if(x <13 && y < 9) [neighbors addObject:[Node nodeWithPos:CGPointMake(x+1, y+1)]];
        if(y > 0)           [neighbors addObject:[Node nodeWithPos:CGPointMake(x, y-1)]];
        if(x <13 && y > 0) [neighbors addObject:[Node nodeWithPos:CGPointMake(x+1, y-1)]];
    }
    else 
    {
        if(x > 0 && y < 9) [neighbors addObject:[Node nodeWithPos:CGPointMake(x-1, y+1)]];
        if(y<9)          [neighbors addObject:[Node nodeWithPos:CGPointMake(x, y+1)]];
        if(x > 0 && y > 0)  [neighbors addObject:[Node nodeWithPos:CGPointMake(x-1, y-1)]];
        if(y > 0)           [neighbors addObject:[Node nodeWithPos:CGPointMake(x, y-1)]];
    }
    
    return neighbors; 
}

-(void)dealloc
{
    [parent release];
    [super dealloc];
}
@end


@interface NSMutableArray (AddCompareHelper)

-(void)add:(Node*)node;
@end

@implementation NSMutableArray(AddCompareHelper)

-(void)add:(Node *)node
{
    for (int i = 0; i < [self count]; i++)
    { 
        Node * n = (Node*) [self objectAtIndex:i];
        if ([node compareValueTo:n]<= 0)
        { 
            [self insertObject:node atIndex:i]; 
            return; 
        } 
    } 
    
    [self addObject:node];
}

-(BOOL)hadNode:(Node*)node
{
    for (int i = 0; i < [self count]; i++)
    { 
        Node * n = (Node*) [self objectAtIndex:i];
        if([node equals:n]) return true;
    } 
    return false;
}   

@end


@interface PathFinder (PrivateMethod)

-(NSArray*)makePath:(Node*)node;
-(BOOL)isHit:(CGPoint)point;
-(NSArray*)changeCoord:(NSArray*)src;
-(PathFinder*)map:(NSArray*)mapArray Hit:(NSArray*)hit;
@end

@implementation PathFinder

+(PathFinder*)pathFinderWithMap:(NSArray*)mapArray Hit:(NSArray*)hit
{
    return    [[[PathFinder alloc] map:mapArray Hit:hit] autorelease];
}

-(PathFinder*)map:(NSArray*)mapArray Hit:(NSArray*)hit
{
    if (self=[super init])
    {
        for (int i=0;i<HEX_ROW;i++)
        {
            for (int j=0;j<HEX_COL;j++)
            {
                NSArray * cols = [mapArray objectAtIndex:i];
                map[i][j] = [cols objectAtIndex:j];
            }
        }
    }
    hitArray = [hit retain];
    openList =[[NSMutableArray alloc] init];
    closeList=[[NSMutableArray alloc] init];
    
    return self;
}

-(void)dealloc
{
    [hitArray release];
    [openList release];
    [closeList release];
    [super dealloc];
}

-(NSArray*)searchPathWithStart:(CGPoint)start End:(CGPoint)end
{
    Node * startNode = [Node nodeWithPos:CGPointMake(start.y, start.x)];
    Node * objectNode= [Node nodeWithPos:CGPointMake(end.y, end.x)];

    startNode.gValue = 0;
    startNode.hValue = [startNode getHValue:objectNode];
    startNode.parent = nil;
    
    [openList add:startNode];
    while ([openList count])
    {
        Node * firstNode = (Node*)[openList objectAtIndex:0];
        [openList removeObjectAtIndex:0];
        if([firstNode equals:objectNode])
        {
            return [self makePath:firstNode];
        }else{
            [closeList add:firstNode];
            NSMutableArray * neighbors = [firstNode getNeighbors];
            for(Node * neighborNode in neighbors)
            {
                BOOL isOpen   = [openList hadNode:neighborNode];
                BOOL isClosed = [closeList hadNode:neighborNode];
                BOOL isHit    = [self isHit:neighborNode.pos];
              
                if(!isOpen&&!isClosed&&!isHit)
                {
                    neighborNode.gValue = firstNode.gValue +10;
                    neighborNode.hValue = [neighborNode getHValue:objectNode];
                    neighborNode.parent = firstNode;
                    [openList add:neighborNode];
                }
            }
        }
    }
    [openList removeAllObjects];
    [closeList removeAllObjects];
    
    return nil;
}

-(NSArray*)makePath:(Node*)node
{
    NSMutableArray * path = [NSMutableArray array];
    while (node.parent)
    {
        [path insertObject:node atIndex:0];
        node = node.parent;
    }
    [path insertObject:node atIndex:0];
    return [self changeCoord:path];
}

-(NSArray*)changeCoord:(NSArray*)src
{
    if(src)
    {
        NSMutableArray * changed = [NSMutableArray arrayWithCapacity:[src count]];
        for (Node * node in  src) 
        {
            int x = node.pos.x;
            int y = node.pos.y;
            node.pos = CGPointMake(y, x);
            [changed add:node];
        }
        return changed;
    }
    return nil;
}

-(BOOL)isHit:(CGPoint)point
{
    for (NSString * hit in hitArray)
    {
       int x = (int)point.x;
       int y = (int)point.y;
       //if(point.x<HEX_ROW&&point.y<HEX_COL&&map[x][y].tag==[hit intValue])
       if([map[y][x] intValue]==[hit intValue])
       {
           return YES;
       }
    }
    return NO;
}

@end

//
//  PathFinder.h
//  effectTest
//
//  Created by Nicholas Tau on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapConfig.h"

@interface Node : NSObject 
{
    CGPoint pos;
    int gValue;
    int hValue;
    Node * parent;
    
}

@property (nonatomic) CGPoint pos;
@property (nonatomic) int gValue;
@property (nonatomic) int hValue;
@property (nonatomic,retain) Node * parent;


+(Node*)nodeWithPos:(CGPoint)point;
-(int)getHValue:(Node*)node;
-(BOOL)equals:(Node*)node;
-(int)compareValueTo:(Node*)node;
-(NSMutableArray*)getNeighbors;

@end

@interface PathFinder : NSObject
{
    NSMutableArray * openList;
    NSMutableArray * closeList;
    
    
    NSString *  map[HEX_ROW][HEX_COL];
    NSArray  * hitArray;
}

+(PathFinder*)pathFinderWithMap:(NSArray*)mapArray Hit:(NSArray*)hit;
-(NSArray*)searchPathWithStart:(CGPoint)start End:(CGPoint)end;

@end

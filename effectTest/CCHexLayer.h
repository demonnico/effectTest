//
//  CCHexLayer.h
//  effectTest
//
//  Created by Nicholas Tau on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PathFinder.h"
#import "MapConfig.h"

@interface HexCoord : NSObject 
{
    NSUInteger row;
    NSUInteger col;
}
+(HexCoord*)hexCoordWithRow:(NSUInteger)row Col:(NSUInteger)col;
-(CGPoint)getXYCoord;

@property (nonatomic)  NSUInteger row;
@property (nonatomic)  NSUInteger col;

@end

@interface CCHexLayer : CCLayer 
{
    
    //NSString * hex_array [HEX_ROW][HEX_COL];
    NSMutableArray * hexMap;
    
    NSMutableArray * attackers;
    NSMutableArray * defenders;
    NSMutableArray * stuffs;
    
}
+(CCScene *) scene;
@end

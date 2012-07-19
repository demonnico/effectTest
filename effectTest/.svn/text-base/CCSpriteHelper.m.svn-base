//
//  CCAnimationHelper.m
//  SpriteBatches
//
//  Created by Steffen Itterheim on 06.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "CCSpriteHelper.h"

@implementation CCSprite (Helper)

-(BOOL) rectContainTouchPoint:(UITouch*)touch
{
    CGPoint  point  = [self convertTouchToNodeSpaceAR:touch];
    
//    CGRect   rect   = self.textureRect;
//    float  widthDis = rect.size.width/2;
//    float  heightDis= rect.size.height/2;
//    point.x = point.x +widthDis;
//    point.y = point.y +heightDis;
//    BOOL isTouch = CGRectContainsPoint(rect,point);
    
    CGRect   rect   = self.textureRect;
    rect.origin.x   = -rect.size.width/2;
    rect.origin.y   = -rect.size.height/2;
    BOOL isTouch = CGRectContainsPoint(rect,point);
    
    return  isTouch;
}
@end

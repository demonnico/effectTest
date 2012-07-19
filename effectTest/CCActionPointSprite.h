//
//  CCActionPointSprite.h
//  effectTest
//
//  Created by Nicholas Tau on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCActionPointSprite : CCSprite<CCTargetedTouchDelegate> 
{
    NSUInteger pointIndex;
    NSUInteger pointNums;
    BOOL       isReset;
}

-(id)initActionPointSprite;
+(id)ccActionPointSprite;
-(void)showResetAnimation;
-(void)showReduceAnimation;

@end

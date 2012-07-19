//
//  CCKnockSprite.h
//  effectTest
//
//  Created by Nicholas Tau on 3/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCKnockSprite : CCSprite 
{
    BOOL isAnimating;
}

-(id)initKnockSprite;
-(void)showAnimation;
+(id)ccKnockSprite;

@end

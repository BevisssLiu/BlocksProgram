//
//  RetainCycleTest.h
//  BlocksProgram
//
//  Created by bevis on 22/01/2018.
//  Copyright © 2018 bevis. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface RetainCycleTest : NSObject
- (void)addSingleDirectionReference;
- (void)addTwoDirectionReference;

- (void)doNothing;
@end

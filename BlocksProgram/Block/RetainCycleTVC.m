//
//  RetainCycleTVC.m
//  BlocksProgram
//
//  Created by bevis on 22/01/2018.
//  Copyright © 2018 bevis. All rights reserved.
//

#import "RetainCycleTVC.h"
#import "RetainCycleTest.h"
/**
 There's a great explanation about "Retain Cycle" as a recommendation :
 https://stackoverflow.com/questions/20030873/always-pass-weak-reference-of-self-into-block-in-arc
 */

@interface RetainCycleTVC ()

@end

@implementation RetainCycleTVC

- (void)singleDirectionReference{
    RetainCycleTest * test = [[RetainCycleTest alloc] init];
    [test addSingleDirectionReference];
    NSLog(@"ltblocks allocated ============ %@",test);
    [test doNothing];
}
- (void)twoDirectionReference{
    RetainCycleTest * test = [[RetainCycleTest alloc] init];
    [test addTwoDirectionReference];
    NSLog(@"ltblocks allocated ============ %@",test);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"twoDirectionReference_1" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"twoDirectionReference_2" object:nil];
    [test doNothing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0: [self singleDirectionReference]; break;
        case 1: [self twoDirectionReference]; break;
        default:
            break;
    }
    
}

@end

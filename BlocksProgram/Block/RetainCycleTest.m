//
//  RetainCycleTest.m
//  BlocksProgram
//
//  Created by bevis on 22/01/2018.
//  Copyright © 2018 bevis. All rights reserved.
//

#define kPrintFunctionLog NSLog(@"%@---%s",NSStringFromClass([self class]),__FUNCTION__)
#import "RetainCycleTest.h"
@interface RetainCycleTest()

@property (nonatomic, strong) NSString          * stringOne;
@property (nonatomic, strong) NSObject          * referingEachOtherObserver;
@end


@implementation RetainCycleTest



- (void)addSingleDirectionReference{
    
    /* singleDirectionReference, using "self" is ok .
     The block retains self, but self doesn't retain the block. If one or the other is released, no cycle is created and everything gets deallocated as it should.
     **/
    
    NSArray * myArray = @[];
    [myArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self doSomethingWithObj: nil];
        NSLog(@"[NSArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {}");
    }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.stringOne = @"addOperationWithBlock";
        [self doSomethingWithObj:nil];
        NSLog(@"[[NSOperationQueue mainQueue] addOperationWithBlock:^{}");
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * internalVar = @"internalVar";
        self.stringOne = internalVar;
        NSLog(@"dispatch_async with %@",_stringOne);
        NSLog(@"dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{}");
    });
    
    
}
- (void)addTwoDirectionReference{
    
    
    __weak __typeof__(self) weakSelf = self;
    
    /**
     if self has a strong reference to a block, and the block also has a strong reference to self, then "retain cycle will happen",
     and the way to resolve this problem is to use "weakSelf" as above.
     */
    
    // example 1:
    [[NSNotificationCenter defaultCenter] addObserverForName:@"twoDirectionReference_1"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      
                                                      NSLog(@"receive post twoDirectionReference_1");
                                                      NSString * internalVar = @"internalVar";
                                                      
//                                                      weakSelf.stringOne = internalVar;
                                                      
                                                      { // wrong
                                                          _stringOne = internalVar;
                                                          NSLog(@"retain cycle happening because that ivar was involved in block");
                                                      }
                                                       
                                                  }];
    
    // example 2:
    self.referingEachOtherObserver = [[NSNotificationCenter defaultCenter]
                                      addObserverForName:@"twoDirectionReference_2"
                                      object:nil
                                      queue:nil
                                      usingBlock:^(NSNotification * _Nonnull note) {
                                          
                                          NSLog(@"receive post twoDirectionReference_2");
                                          
//                                          [weakSelf doSomethingWithObj:nil];
                                          
                                          { //wrong
                                              [self doSomethingWithObj:nil];
                                              NSLog(@"retain cycle happening because that self was involved in block");
                                          }
                                          
                                      }];
    
    
}

- (instancetype)init{
    if (self=[super init]) {
//        kPrintFunctionLog;
        _stringOne = @" string  One";
    }
    return self;
}
- (void)doSomethingWithObj:(NSObject *)obj{}
- (void)doNothing{}

- (void)dealloc{
#warning  -  this method should be called if there is no 'retain cycle'
    kPrintFunctionLog;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


//
//  ViewModel.h
//  MVVMTest
//
//  Created by Tamás Zahola on 15/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Model;

@interface ViewModel : NSObject

@property (nonatomic, assign, readonly) NSInteger operand1;
@property (nonatomic, assign, readonly) NSInteger operand2;
@property (nonatomic, assign, readonly) NSInteger sum;

@property (nonatomic, assign, readonly) BOOL running;

- (instancetype)initWithModel:(Model*)model;

- (void)startWithCompletion:(void(^)())completionBlock;
- (void)stopWithCompletion:(void(^)())completionBlock;

@end

//
//  ViewModel.m
//  MVVMTest
//
//  Created by Tamás Zahola on 15/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import "ViewModel.h"

#import "Model.h"

@interface ViewModel ()

@property (nonatomic, strong) Model* model;

@property (nonatomic, assign, readwrite) NSInteger operand1;
@property (nonatomic, assign, readwrite) NSInteger operand2;
@property (nonatomic, assign, readwrite) NSInteger sum;

@property (nonatomic, assign, readwrite) BOOL running;

@property (nonatomic, strong) id notificationToken;

@end

@implementation ViewModel

- (instancetype)initWithModel:(Model *)model {
    self = [super init];
    if (self) {
        _model = model;
        
        _running = NO;
        
        __weak ViewModel* weakSelf = self;
        _notificationToken = [[NSNotificationCenter defaultCenter]
            addObserverForName:ModelDidChangeNotification
            object:_model
            queue:nil
            usingBlock:^(NSNotification *note) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.operand1 = model.operand1;
                    weakSelf.operand2 = model.operand2;
                    weakSelf.sum = model.sum;
                    
                    NSAssert(weakSelf.operand1 + weakSelf.operand2 == weakSelf.sum, @"Inconsistent state!");
                });
            }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.notificationToken];
}

- (void)startWithCompletion:(void (^)())completionBlock {
    NSAssert([NSThread isMainThread], @"Use the main thread!");
    
    [self.model performBlock:^{
        [self.model start];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.running = YES;
            if (completionBlock) {
                completionBlock();
            }
        });
    }];
}

- (void)stopWithCompletion:(void (^)())completionBlock {
    NSAssert([NSThread isMainThread], @"Use the main thread!");
    
    [self.model performBlock:^{
        [self.model stop];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.running = NO;
            if (completionBlock) {
                completionBlock();
            }
        });
    }];
}

@end

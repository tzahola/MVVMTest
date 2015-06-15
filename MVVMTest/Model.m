//
//  Model.m
//  MVVMTest
//
//  Created by Tamás Zahola on 13/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import "Model.h"

#define AssertQueue() NSAssert(dispatch_get_current_queue() == self.queue, @"Use performBlock: !")

NSInteger const kMinValue = 0;
NSInteger const kMaxValue = 100;

NSString* const ModelDidChangeNotification = @"ModelDidChangeNotification";

@interface Model ()

@property (nonatomic, strong) dispatch_queue_t queue;

@property (atomic, assign, readwrite) NSInteger operand1;
@property (atomic, assign, readwrite) NSInteger operand2;
@property (atomic, assign, readwrite) NSInteger sum;

@property (atomic, assign, readwrite) BOOL running;

@end

@implementation Model

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    }
    return self;
}

- (void)performBlock:(void (^)())block {
    dispatch_async(self.queue, block);
}

- (void)start {
    AssertQueue();
    self.running = YES;
    [self doWork];
}

- (void)stop {
    AssertQueue();
    self.running = NO;
}

- (void)doWork {
    if (self.running) {
        self.operand1 = [self randFrom:kMinValue to:kMaxValue];
        self.operand2 = [self randFrom:kMinValue to:kMaxValue];
        self.sum = self.operand1 + self.operand2;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ModelDidChangeNotification object:self];
        
        usleep(100);
        
        dispatch_async(self.queue, ^{
            [self doWork];
        });
    }
}

- (NSInteger)randFrom:(NSInteger)min to:(NSInteger)max {
    return (NSInteger)floor(rand() / ((double)RAND_MAX) * (max - min)) + min;
}

@end

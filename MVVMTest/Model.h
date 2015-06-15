//
//  Model.h
//  MVVMTest
//
//  Created by Tamás Zahola on 13/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const ModelDidChangeNotification;

@interface Model : NSObject

@property (atomic, assign, readonly) NSInteger operand1;
@property (atomic, assign, readonly) NSInteger operand2;
@property (atomic, assign, readonly) NSInteger sum;

@property (atomic, assign, readonly) BOOL running;

- (void)performBlock:(void(^)())block;

- (void)start;
- (void)stop;

@end

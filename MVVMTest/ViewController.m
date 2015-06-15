//
//  ViewController.m
//  MVVMTest
//
//  Created by Tamás Zahola on 13/06/15.
//  Copyright (c) 2015 Tamás Zahola. All rights reserved.
//

#import "ViewController.h"

#import "ViewModel.h"

static void* ViewControllerKVOContext = &ViewControllerKVOContext;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *operand1Label;
@property (nonatomic, weak) IBOutlet UILabel *operand2Label;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;

@property (nonatomic, strong) UIBarButtonItem *startBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(start:)];
    self.stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(stop:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel addObserver:self forKeyPath:@"operand1" options:NSKeyValueObservingOptionInitial context:ViewControllerKVOContext];
    [self.viewModel addObserver:self forKeyPath:@"operand2" options:NSKeyValueObservingOptionInitial context:ViewControllerKVOContext];
    [self.viewModel addObserver:self forKeyPath:@"sum" options:NSKeyValueObservingOptionInitial context:ViewControllerKVOContext];
    [self.viewModel addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionInitial context:ViewControllerKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSAssert([NSThread isMainThread], @"Use the main thread!");
    
    if (context == ViewControllerKVOContext) {
        if ([keyPath isEqualToString:@"operand1"]) {
            self.operand1Label.text = [NSString stringWithFormat:@"%d", (int)self.viewModel.operand1];
        } else if ([keyPath isEqualToString:@"operand2"]) {
            self.operand2Label.text = [NSString stringWithFormat:@"%d", (int)self.viewModel.operand2];
        } else if ([keyPath isEqualToString:@"sum"]) {
            self.resultLabel.text = [NSString stringWithFormat:@"%d", (int)self.viewModel.sum];
        } else if ([keyPath isEqualToString:@"running"]) {
            self.navigationItem.rightBarButtonItem = self.viewModel.running ? self.stopBarButtonItem : self.startBarButtonItem;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)start:(id)sender {
    [self.viewModel startWithCompletion:^{}];
}

- (void)stop:(id)sender {
    [self.viewModel stopWithCompletion:^{}];
}

@end

//
//  BaseNavigationViewController.m
//  Express
//
//  Created by rango on 14-7-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.interactivePopGestureRecognizer.enabled  = YES;
    self.interactivePopGestureRecognizer.delegate = self;

    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
   
    return self.viewControllers.count == 1 ? YES : NO;
    
    
}

@end

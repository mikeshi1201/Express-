//
//  BaseViewController.h
//  Express
//
//  Created by rango on 14-8-17.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Express.h"
#import "TRAsyncURLConnection.h"
#import "QueryResultModel.h"
@class MBProgressHUD;

enum {
    
    statusBarLabelTag = 0
};


@interface BaseViewController : UIViewController

@property  (nonatomic)NetworkStatus netStatus;

#pragma mark - IndicatorView
- (void)showHUD;
- (void)hideHUD;
- (void)showHUDCompelte:(NSString *)title;
- (void)showHUDNetWorkStatus:(BOOL)show;
- (void)showAlertTitle:(NSString *)title;

#pragma mark  - compareDate
- (NSString *)compareDate:(NSDate *)date;
- (NSDate *)formatterString:(NSString *)string;



@end

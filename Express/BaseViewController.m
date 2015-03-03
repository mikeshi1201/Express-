//
//  BaseViewController.m
//  Express
//
//  Created by rango on 14-8-17.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewExt.h"
#import "MBProgressHUD.h"

#define AlertImageView_X 100
#define AlertImageView_Hight 40
#define AlertImageView_Widht 120
#define AlertLabel_Hight 40
#define AlertLabel_Widht 120
#define StausBarWindow_Label_Hight 20
#define ToIndex 10

@interface BaseViewController ()
{
    
    UIImageView * _loadView;
    UIImageView * _alertImageView;
    
}

@property (strong, nonatomic) MBProgressHUD * progressHUD;

@property (nonatomic) Reachability *internetReachability;



- (void)changeNetworkStatus:(NSNotification*)notification;
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (self.navigationController.viewControllers.count >1) {
        
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_navbar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backItem;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    self.netStatus = self.internetReachability.currentReachabilityStatus;
    [self.internetReachability startNotifier];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)changeNetworkStatus:(NSNotification*)notification{
    
    Reachability *reach = [notification object];
    
    [self updateInterfaceWithReachability:reach];

}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    NetworkStatus netStatus =  reachability.currentReachabilityStatus;
    
    self.netStatus =netStatus;
    
    switch (netStatus) {
            
        case kNotReachable:
           
            [self showHUDNetWorkStatus:NO];
            
            break;
            
        case kReachableViaWiFi : case kReachableViaWWAN:
            
            [self showHUDNetWorkStatus:YES];

            break;
    }
    
    
}

#pragma mark - backAction
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - IndicatorView
- (void)showHUD {
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.progressHUD.labelText =NSLocalizedString(@"Loading...", @"加载中...");
    
}
- (void)hideHUD {
    
    [self.progressHUD hide:YES];
    
}
- (void)showHUDCompelte:(NSString *)title {
    
    if (self.progressHUD) {
        
        self.progressHUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-checkmark"]];
        
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        
        self.progressHUD.labelText = title;
        
        [self.progressHUD hide:YES afterDelay:1];
        

    }
    
}
- (void)showHUDNetWorkStatus:(BOOL)show {
    
    
    self.progressHUD = [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    
    if (show) {
        
        self.progressHUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_airport"]];
        self.progressHUD.labelText  = NSLocalizedString(@"Network Ok", @"网络已连接");
        
        
    } else {
        
        self.progressHUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_airport_no"]];
        self.progressHUD.labelText  = NSLocalizedString(@"Network error", @"网络未连接");
        
    }
    
    [self.progressHUD hide:YES afterDelay:3];
    
}
- (void)showAlertTitle:(NSString *)title {
    
    if (_alertImageView == nil) {
        
        _alertImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(AlertImageView_X, SCREEN_HEIGHT/2-50, AlertImageView_Widht, AlertImageView_Hight)];
        _alertImageView.layer.cornerRadius = 5.0f;
        _alertImageView.layer.borderWidth  = 0.5f;
        _alertImageView.layer.borderColor  = [UIColor whiteColor].CGColor;
        _alertImageView.backgroundColor    = [UIColor blackColor];
        
        UILabel * alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,AlertLabel_Widht, AlertLabel_Hight)];
        alertLabel.font  = [UIFont systemFontOfSize:15];
        alertLabel.textAlignment   = NSTextAlignmentCenter;
        alertLabel.textColor       = [UIColor whiteColor];
        alertLabel.backgroundColor = [UIColor clearColor];
        alertLabel.text =  title;
        alertLabel.numberOfLines = 0;
        
        [_alertImageView addSubview:alertLabel];
        
        if (![_alertImageView superview]) {
            
            [self.view addSubview:_alertImageView];
            
            [UIView animateWithDuration:2.0f animations:^{
                
                _alertImageView.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                
                [_alertImageView removeFromSuperview];
                _alertImageView = nil;
            }];
            
                     
        }
        
    }
}

#pragma mark -
#pragma mark - compareDate
-(NSString *)compareDate:(NSDate *)date {
    
    //设置日历
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    //设置todayDate日期格式
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitEra |NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *todayDate = [currentCalendar dateFromComponents:components];
    

    //设置otherData日期格式
    components = [currentCalendar components:NSCalendarUnitEra |NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay  fromDate:date];

    
    NSDate *otherDate = [currentCalendar dateFromComponents:components];
    
    if ([todayDate isEqualToDate:otherDate] ) {
        
        return @"今天";
        
    }
    
    NSDate * yesterday = [todayDate dateByAddingTimeInterval:-86400];
    
    NSString *todayString     = [[todayDate description]substringToIndex:ToIndex];
    NSString *yesterdayString = [[yesterday description]substringToIndex:ToIndex];
    NSString *otherDateString = [[otherDate description]substringToIndex:ToIndex];
    
    if ([otherDateString isEqualToString:todayString]) {
        
        return @"今天";
        
    } else if ([otherDateString isEqualToString:yesterdayString] ){
        
        return @"昨天";
        
    } else {
        
        return   [self formatDate:otherDate];
        
    }
    
}

- (NSString *)formatDate:(NSDate*)date {
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc]init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString  *dateString = [formatter stringFromDate:date];
    
    NSString *subDateString = [dateString substringToIndex:ToIndex];
    
    return subDateString;
    
}

- (NSDate *)formatterString:(NSString *)string {

    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
    
}

- (void)dealloc {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];

    
}
@end

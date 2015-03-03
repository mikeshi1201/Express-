//
//  BaseTableViewController.m
//  Express
//
//  Created by rango on 14-9-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MBProgressHUD.h"
#import "SWTableViewCell.h"
#import "Express.h"

static NSString * const kCellIdentifier =@"cellID";
@interface BaseTableViewController ()

@property (strong, nonatomic) MBProgressHUD * progressHUD;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    self.netStatus = self.internetReachability.currentReachabilityStatus;
    [self.internetReachability startNotifier];
    
}

- (void)changeNetworkStatus:(NSNotification*)notification {
    
    
    Reachability *reach = [notification object];
    
    [self updateInterfaceWithReachability:reach];
}

- (void)updateInterfaceWithReachability:(Reachability*)reachability {
    
    NetworkStatus netStatus = reachability.currentReachabilityStatus;
    
    self.netStatus = netStatus;
    
}
- (void)showHUD{
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.progressHUD.labelText = NSLocalizedString(@"Checking...", @"正在检查...");
    
    
    
}
- (void)hideHUD {
    
    [self.progressHUD hide:YES];
    
}



- (void)configureCell:(UITableViewCell*)cell forExpress:(Express*)express{
    
    //SWTableViewCell class
    if ([cell isKindOfClass:[SWTableViewCell class]]) {
        
        UIImageView *expressImageView = (UIImageView*)[cell.contentView viewWithTag:CellImageTag];
        expressImageView.image = [UIImage imageNamed:express.imageName];
        
        UILabel *expressNameLabel = (UILabel*)[cell.contentView viewWithTag:CellLabelTag];
        
        expressNameLabel.text = express.expressName;
        
    } else {
        
        //UITableViewCell class
        UIImageView *expressImageView = (UIImageView*)[cell.contentView viewWithTag:CellImageTag];
        expressImageView.image = [UIImage imageNamed:express.imageName];
        
        UILabel *expressNameLabel = (UILabel*)[cell.contentView viewWithTag:CellLabelTag];
        
        expressNameLabel.text = express.expressName;
        
    }
   
    
}

-(void)dealloc {
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
}
@end

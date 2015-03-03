//
//  BaseTableViewController.h
//  Express
//
//  Created by rango on 14-9-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "Reachability.h"
@class Express;

enum {
    
   CellImageTag = 1,
   CellLabelTag
    
};

@interface BaseTableViewController : UITableViewController


@property (nonatomic) NetworkStatus  netStatus;
- (void)configureCell:(UITableViewCell*)cell forExpress:(Express*)express;
- (void)showHUD;
- (void)hideHUD;   
@end

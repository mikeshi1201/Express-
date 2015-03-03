//
//  MainTableViewController.h
//  Express
//
//  Created by rango on 14-7-21.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "BaseTableViewController.h"
@class ExpressListTableViewController;
enum {
    
    SWTableCellIndexTelTag = 0,
    SWTableCellIndexURlTag = 1
    
    
};
@protocol ExpressListViewDelgate <NSObject>

@optional

- (void)ExpressListView:(ExpressListTableViewController*)controller didSelectWithobject:(Express*)express;

- (void)ExpressListViewDidCanceld:(ExpressListTableViewController*)controller;

@end

@interface ExpressListTableViewController : BaseTableViewController<UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,SWTableViewCellDelegate>

@property (weak,nonatomic) id<ExpressListViewDelgate>delegate;

@property (nonatomic) BOOL isPresent;






@end

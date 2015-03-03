//
//  QueryResultViewController.h
//  Express
//
//  Created by rango on 14-8-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, UILableTag) {
    
    UILabelNoteTag =1,
    UILabelMailNoTag
    
};

@interface QueryResultViewController : BaseViewController

@property (strong,nonatomic) NSDictionary  *dictionary;
@property (nonatomic) NSInteger indexPath;
@end

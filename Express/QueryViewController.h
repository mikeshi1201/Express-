//
//  QueryViewController.h
//  Express
//
//  Created by rango on 14-7-22.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,ErrorCode) {
    
    Succeed = 0,
    MailNoExist = 1,
    FormatError = 6
    
};
typedef NS_ENUM(NSInteger,TextFieldTag) {
    
    ExpressNameTextFieldTag    = 1,
    ExpressNumberTextFieldTag  = 2,
    
    
};
@interface QueryViewController : BaseViewController
@property (strong,nonatomic) Express  *express;


@end

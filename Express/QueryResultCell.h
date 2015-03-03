//
//  QueryResultCell.h
//  Express
//
//  Created by rango on 14-8-21.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *expressContentLabel; //内容
@property (weak, nonatomic) IBOutlet UILabel *expressDateLabel;    //日期
@property (weak, nonatomic) IBOutlet UILabel *expressHourLabel;    //时间
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView; //图像


@end

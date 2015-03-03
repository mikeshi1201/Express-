//
//  ExpressCell.h
//  Express
//
//  Created by rango on 14-8-4.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QueryResultModel;

@interface ExpressHistoryCell : UITableViewCell{
    
    
}

@property (weak, nonatomic) IBOutlet UIImageView *expressImageView; //图像
@property (weak, nonatomic) IBOutlet UIImageView *compeleteImageView; //完成图像
@property (weak, nonatomic) IBOutlet UILabel *expressNameLabel;     //名称
@property (weak, nonatomic) IBOutlet UILabel *expressContextLabel;  //快递内容
@property (weak, nonatomic) IBOutlet UILabel *expressTimeLabel;     //时间
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;            //备注
@property (weak, nonatomic) IBOutlet UILabel *mailNoLabel;

@property (strong, nonatomic) QueryResultModel *model;

@end

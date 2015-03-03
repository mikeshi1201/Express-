//
//  SectionHeaderView.h
//  Express
//
//  Created by rango on 14-9-15.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewUp;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDown;
@end

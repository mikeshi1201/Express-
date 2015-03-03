//
//  ExpressCell.m
//  Express
//
//  Created by rango on 14-8-4.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "ExpressHistoryCell.h"
#import "QueryResultModel.h"
@implementation ExpressHistoryCell

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
   
    
    if (_model) {
        
        self.compeleteImageView.image = self.model.status == 3 ? [UIImage imageNamed:NSLocalizedString(@"Signed", nil)] :[UIImage imageNamed:NSLocalizedString(@"No Signed", nil)];
        
        self.expressNameLabel.text = _model.expTextName;
        self.mailNoLabel.text = _model.mailNo;
        self.expressTimeLabel.text =  _model.expressTime;
        self.expressImageView.image  = [UIImage imageNamed:_model.expSpellName];
        
        
        if ([self.model.note length] >0 ) {
            
            self.noteLabel.textColor = [UIColor blackColor];
            self.noteLabel.text = _model.note;
            
        } else {
            
            self.noteLabel.textColor = [UIColor grayColor];
            self.noteLabel.text = @"NO";
            
             
            
        }
        
    }
    
   
    
}



@end

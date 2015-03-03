//
//  QueryResultModel.m
//  Express
//
//  Created by rango on 14-7-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "QueryResultModel.h"

@implementation QueryResultModel

- (instancetype)initwithExpress:(NSDictionary*)dic{
    
    if (self == [super init]) {
        
        if (dic) {
            
            self.dictionary = dic;
            self.status = [[dic  objectForKey:@"status"]integerValue];
            self.time   = [[dic  objectForKey:@"update"]integerValue];
            self.mailNo = [dic   objectForKey:@"mailNo"];
            self.expTextName  = [dic objectForKey:@"expTextName"];
            self.expSpellName = [dic objectForKey:@"expSpellName"];
            self.tel = [dic objectForKey:@"tel"];
            self.note = [dic objectForKey:@"note"];
            
            NSArray * contextData = [dic objectForKey:@"data"];
            NSDictionary * dic_One  = [contextData objectAtIndex:0];
            
            self.context = [dic_One objectForKey:@"context"];
            self.expressTime = [dic_One objectForKey:@"time"];

            
        }
        
       
    }
    
    return self;
    
}
@end

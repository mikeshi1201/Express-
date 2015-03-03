//
//  Express.m
//  Express
//
//  Created by rango on 14-7-21.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "Express.h"

@implementation Express

-(instancetype)initWithExpressDic:(NSDictionary*)dic {
    
    if (self = [super init]) {
        
        self.expressName = [dic objectForKey:@"expressName"];
        self.phone = [dic objectForKey:@"phone"];
        self.imageName = [dic objectForKey:@"imageUrl"];
        self.expressWebUrl = [dic objectForKey:@"expressWebUrl"];
        self.pinyin  = [dic objectForKey:@"pinyin"];
        
    }
    
    return self;
    
}

+(NSString*)keyName {
    
    return @"expressName";

}
@end

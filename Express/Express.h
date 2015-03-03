//
//  Express.h
//  Express
//
//  Created by rango on 14-7-21.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Express : NSObject


@property (nonatomic, copy)NSString *expressName;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *expressWebUrl;
@property (nonatomic, copy)NSString *pinyin;
@property (nonatomic, copy)NSString *index;


-(instancetype)initWithExpressDic:(NSDictionary*)dic;

+(NSString*)keyName;

@end

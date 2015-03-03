//
//  QueryResultModel.h
//  Express
//
//  Created by rango on 14-7-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryResultModel : NSObject

@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger time;


@property (nonatomic, copy) NSString  *expTextName;
@property (nonatomic, copy) NSString  *expSpellName;
@property (nonatomic, copy) NSString  *expressTime;
@property (nonatomic, copy) NSString  *mailNo;
@property (nonatomic, copy) NSString  *context;
@property (nonatomic, copy) NSString  *tel;
@property (nonatomic, copy) NSString  *note;

@property (nonatomic, strong) NSDictionary  *dictionary;

- (instancetype)initwithExpress:(NSDictionary*)dic;

@end

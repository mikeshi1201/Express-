//
//  TRAsyncURLConnection.h
//  Express
//
//  Created by rango on 14-9-23.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)(NSMutableDictionary *dictionary);
typedef void(^ErrorBlock)(NSError *error);

@interface TRAsyncURLConnection : NSURLConnection<NSURLConnectionDataDelegate>
{
    
    
    NSMutableData *_data;
    CompleteBlock block_;
    ErrorBlock errBlock_;
    
    
}

+ (instancetype)request:(NSMutableDictionary *)params CompleteBlock:(CompleteBlock)completeBlock errorBlock:(ErrorBlock)errorBlock;

- (instancetype)initWithRequest:(NSMutableDictionary *)params CompleteBlock:(CompleteBlock)completeBlock ErrorBlock:(ErrorBlock)errorBlock;

@end

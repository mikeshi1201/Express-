//
//  TRAsyncURLConnection.m
//  Express
//
//  Created by rango on 14-9-23.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "TRAsyncURLConnection.h"
#define BaseURL  @"http://api.ickd.cn/?id=105649&secret=050e595f86abddb2c73066313da969ed&com=%@&nu=%@&encode=utf8&ord=desc"
@implementation TRAsyncURLConnection
+ (instancetype)request:(NSMutableDictionary *)params CompleteBlock:(CompleteBlock)completeBlock errorBlock:(ErrorBlock)errorBlock
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [[self alloc]initWithRequest:params CompleteBlock:completeBlock ErrorBlock:errorBlock];
    
}

- (instancetype)initWithRequest:(NSMutableDictionary *)params CompleteBlock:(CompleteBlock)completeBlock ErrorBlock:(ErrorBlock)errorBlock
{
    
    
    NSString *com = [params objectForKey:@"com"];
    NSString *nu  = [params objectForKey:@"nu"];
    
    NSString *urlString = [NSString stringWithFormat:BaseURL,com,nu];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (self = [super initWithRequest:request delegate:self startImmediately:NO]) {
        
       _data = [[NSMutableData alloc]init];
        block_ = [completeBlock copy];
        errBlock_ = [errorBlock copy];
        
        
        [self start];
        
    }
    return self;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:nil];
    
    block_(dic);

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    errBlock_(error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end

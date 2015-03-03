//
//  QRCodeReadViewController.h
//  Express
//
//  Created by rango on 14-9-2.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "QueryViewController.h"

@class QRCodeReadViewController;

@protocol QRCodeViewDelegate <NSObject>

@optional
- (void)QRCodeReadViewController:(QRCodeReadViewController*) readViewController QRCodeText:(NSString *)codeText;

- (void)QRCodeReadDismissViewController:(QRCodeReadViewController*)readViewController;

@end


@interface QRCodeReadViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) id<QRCodeViewDelegate>QRdelegate;

@end

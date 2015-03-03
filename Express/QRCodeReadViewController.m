//
//  QRCodeReadViewController.m
//  Express
//
//  Created by rango on 14-9-2.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "QRCodeReadViewController.h"


#define LAYER_X 60
#define LAYER_Y 250
#define LAYER_WIDTH 200
#define LAYER_HEIGHT 1


static SystemSoundID shake_sound_male_id = 0;

@interface QRCodeReadViewController ()

@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;

- (void)startReading;
- (void)stopReading;
- (void)loadBeepSound;
- (void)mainThread;

@end

@implementation QRCodeReadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadBeepSound];
    [self startReading];
    
}

- (void)startReading {
    
    NSError * error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return ;
    }
    
    
    if (!_captureSession) {
        
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
       

    }
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    captureMetadataOutput.metadataObjectTypes = [captureMetadataOutput availableMetadataObjectTypes];
    
    AVCaptureVideoPreviewLayer * layer = [[AVCaptureVideoPreviewLayer alloc]init];
    layer.frame = CGRectMake(LAYER_X,LAYER_Y,LAYER_WIDTH,LAYER_HEIGHT);
    layer.backgroundColor = [UIColor redColor].CGColor;

    if (!_videoPreviewLayer) {
        
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];

    }
    
    [_videoPreviewLayer addSublayer:layer];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
    

}

- (void)stopReading {
    
    [_captureSession stopRunning];
     _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
}

- (void)loadBeepSound
{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sound_scan_success" ofType:@"wav"];

    if (path) {
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &shake_sound_male_id);
    
        
    }
    
  
}

- (void)mainThread{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)dismiss:(id)sender {
    
    if ([_QRdelegate respondsToSelector:@selector(QRCodeReadDismissViewController:)]) {
        
        [_QRdelegate QRCodeReadDismissViewController:self];
        
    }
    
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    

    
    NSArray  *barCodeTypes = @[AVMetadataObjectTypeUPCECode,
                              AVMetadataObjectTypeCode39Code,
                              AVMetadataObjectTypeEAN13Code,
                              AVMetadataObjectTypeCode93Code,
                              AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code,
                              AVMetadataObjectTypeEAN8Code,
                              AVMetadataObjectTypeQRCode,
                              AVMetadataObjectTypeAztecCode,
                              AVMetadataObjectTypeCode39Mod43Code];
    
    
    AVMetadataMachineReadableCodeObject * metadateObj = metadataObjects[0];
    
    for (NSString * type in barCodeTypes) {
        
        if ([metadateObj.type isEqualToString:type]) {
            
            AudioServicesPlaySystemSound(shake_sound_male_id);
            
            
            if ([_QRdelegate respondsToSelector:@selector(QRCodeReadViewController:QRCodeText:)]) {
                
                [_QRdelegate QRCodeReadViewController:self QRCodeText:metadateObj.stringValue];
                
            
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:YES];
            
                
                [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:YES];
                
            }
            
      }
   }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

@end

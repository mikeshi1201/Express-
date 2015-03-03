//
//  MoreViewController.m
//  Express
//
//  Created by rango on 14-10-13.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "MoreViewController.h"
#import <MessageUI/MessageUI.h>
#import "JSON.h"
@interface MoreViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switch_music;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

-  (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.switch_music.on  = [[NSUserDefaults standardUserDefaults]boolForKey:kMusicState];
    
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switch_MusicOn:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:kMusicState];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KMusicMoreViewOpen  object:sender];
}

//版本检测
- (void)onCheckVersion {
    
        [super showHUD];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        
        NSString *urlString = @"http://itunes.apple.com/lookup?id=922880739";
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            NSString *results = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *dic = [results JSONValue];
            
            

            NSArray *infoArray = [dic objectForKey:@"results"];
            if ([infoArray count]) {
                
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                
                
                if ([lastVersion isEqualToString:currentVersion]) {
                    
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Update", @"更新") message:NSLocalizedString(@"Version", nil) preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"好") style:UIAlertActionStyleDefault handler:nil];
                    
                    [alertController addAction:confirm];
                    
                    [self presentViewController:alertController animated:YES completion:^{
                        
                        [super hideHUD];
                    }];
                    
                }  else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Update", nil) message:NSLocalizedString(@"Latest version", nil) preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        NSURL *url = [NSURL URLWithString:@"https://appsto.re/cn/JRGa3.i"];
                        
                        [[UIApplication sharedApplication] openURL:url];
                        
                        
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:confirmAction];
                    
                    [self presentViewController:alertController animated:YES completion:^{
                        [super hideHUD];

                    }];
                    
                   }
               }
            
            }];
        

    
}

- (void)sendEmailOfFeedBack{
    
    Class mailClass  = (NSClassFromString(@"MFMailComposeViewController"));
    
    
    if (mailClass !=nil) {
        
      MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        mailController.mailComposeDelegate  = self;
        
        //邮件标题
        NSString *emailtitle = @"反馈和建议";
        //收件人地址
        NSArray *toAddress = [NSArray arrayWithObject:@"renshaolei0725@163.com"];

        //收件
        [mailController setToRecipients:toAddress];
        //主题
        [mailController setSubject:emailtitle];
        
        
        [mailController setMessageBody:@"请输入您的建议:" isHTML:NO];
        
        
        [self presentViewController:mailController animated:YES completion:nil];
        
    }

}
#pragma mark - MFMailComposeViewController Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
  
    NSString  *resultString;
    
    switch (result) {
            
        case MFMailComposeResultCancelled:
            
            resultString = NSLocalizedString(@"Canceled", @"已经取消");
            break;
            
        case MFMailComposeResultSaved:
            
            resultString = NSLocalizedString(@"Saved", @"已保存");
            break;
            
        case MFMailComposeResultSent:
            
            resultString = NSLocalizedString(@"Success", @"已发送");
            break;
            
        case MFMailComposeResultFailed:
            
            resultString = NSLocalizedString(@"Send failed", @"发送失败");
            break;
            
    }
    


    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:resultString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }];
    
    
    
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (indexPath.section ==1 &&indexPath.row == 0) {
        
        //help
        
        UIViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        
        [self  presentViewController:pageController animated:NO completion:nil];
        
        
    }  else if (indexPath.section ==1 &&indexPath.row ==1) {
        
        //反馈
        
        if (self.netStatus == kNotReachable) {
            
            //网络未连接
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", nil) message:NSLocalizedString(@"Network error", @"网络未连接") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        } else if (self.netStatus == kReachableViaWiFi || self.netStatus == kReachableViaWWAN){
            
            [self sendEmailOfFeedBack];

        }
        
        
    } else if (indexPath.section ==2 &&indexPath.row ==0) {
        
        //版本
        
        if (self.netStatus == kNotReachable) {
            
            //网络wei连接
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", @"提示") message:NSLocalizedString(@"Network error", @"网络未连接")  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            

        } else if (self.netStatus == kReachableViaWiFi || self.netStatus == kReachableViaWWAN){
            
            [self onCheckVersion];
        }

    } else if (indexPath.section ==2 &&indexPath.row ==1) {
        
        //评价
        
        NSString *urlString = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=922880739&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];

    }
    
}

@end

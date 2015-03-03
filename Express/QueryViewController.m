//
//  QueryViewController.m
//  Express
//
//  Created by rango on 14-7-22.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "QueryViewController.h"
#import "QRCodeReadViewController.h"
#import "QueryResultViewController.h"
#import "ExpressListTableViewController.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#define MailNO @"mailNo"
#define Note @"note"
#define SegueWithIdentifier  @"NextResult"
static  SystemSoundID sound_success_id = 0;
static  SystemSoundID sound_fail_id = 0;

@interface QueryViewController ()<UITextFieldDelegate,ExpressListViewDelgate,QRCodeViewDelegate>
{
    
    NSInteger _index;
    BOOL isMusicOpen;
    
}

#pragma mark - propertys
@property (weak, nonatomic) IBOutlet UITextField *expressNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *expressNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (strong, nonatomic) NSMutableArray  *queryResultArr;

#pragma mark - methods
- (void)startSerach;
- (void)beginSearch;
- (void)mainThread ;

- (void)loadQuerySuccessSound;
- (void)loadQueryFailSound;

- (void)performSegueWithIdentifier;
- (void)loadResult:(NSMutableDictionary *)result;
@end

@implementation QueryViewController

//加载声音
- (void)loadQuerySuccessSound {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sound_query_success" ofType:@"wav"];
    if (path) {
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound_success_id);
        
    }

}

- (void)loadQueryFailSound {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sound_query_fail" ofType:@"wav"];
    if (path) {
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound_fail_id);
    }
    
}

//移除声音
- (void)removeQueryFailSound {
    
    AudioServicesDisposeSystemSoundID(sound_fail_id);
    
}
- (void)removeQuerySuccessSound {
    
    AudioServicesDisposeSystemSoundID(sound_success_id);

    
}
#pragma mark -  viewLife cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queryBtn.enabled = NO;
    self.expressNameTextField.text = self.express.expressName;
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nav_titeview"]];


     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openMusic:) name:KMusicMoreViewOpen object:nil];
        
    
   
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.expressNameTextField.text = self.express.expressName;
    
    BOOL isOpen = [[NSUserDefaults standardUserDefaults]boolForKey:kMusicState];
    
    if (isOpen) {
        [self loadQueryFailSound];
        [self loadQuerySuccessSound];
    }

}

- (void)openMusic:(NSNotification*)noti {

  
    UISwitch *musicSwitch = noti.object;
    
    if (musicSwitch.on) {
    
        //加载音效
        [self loadQueryFailSound];
        [self loadQuerySuccessSound];
       

    } else {
        //移除音效
        [self removeQueryFailSound];
        [self removeQuerySuccessSound];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}

#pragma mark - method
- (void)startSerach {
    
    if (self.netStatus == kNotReachable) {
    
        [super showHUDNetWorkStatus:NO];
        
        return;
    }
    
    
    [super showHUD];
    NSString * com = self.express.pinyin;
    NSString * nu  = self.expressNumberTextField.text;
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    
    [params setObject:com forKey:@"com"];
    [params setObject:nu  forKey:@"nu"];
    
    [TRAsyncURLConnection request:params CompleteBlock:^(NSMutableDictionary *dictionary) {
        
        
        [self loadResult:dictionary];
        
        
    } errorBlock:^(NSError *error) {
        
        [super hideHUD];
        
        NSLog(@"%@",error);
        
    }];
   
    
}
- (void)loadResult:(NSMutableDictionary *)result {
    
    if (!result) {
        
        [super hideHUD];
        NSString *resuestString = NSLocalizedString(@"Request timed out,", @"请求超时,稍后重试");
        [super performSelector:@selector(showAlertTitle:) withObject:resuestString afterDelay:0.5];
        
        return;
        
    }
    
    NSInteger  errCode  = [[result objectForKey:@"errCode"]integerValue];
    switch (errCode) {
            
        case Succeed:
            
        {
            
           AudioServicesPlaySystemSound(sound_success_id);
           
            //AudioServicesPlayAlertSound(sound_success_id); 震动 并播放声音
            [super showHUDCompelte:NSLocalizedString(@"Done", @"加载完成")];
    
            [super performSelector:@selector(hideHUD) withObject:nil afterDelay:0.3];
            self.queryResultArr =    [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:QUERY_RESULTS]];
            
            int atIndex = -1;
            
            NSMutableDictionary * currentDic = [NSMutableDictionary dictionaryWithDictionary:result];
            
            for (NSMutableDictionary * oldDic in self.queryResultArr) {
                
                atIndex++;
                NSString *mailNo = [oldDic objectForKey:MailNO];
                
                NSString * currentMailNo = [result objectForKey:MailNO];
                
                if ([mailNo isEqualToString:currentMailNo]) {
                    
                    NSString * note  = [oldDic objectForKey:Note];

                    if (note) {
                        //有备注 取出之前的备注 赋值给新的数据
                        [currentDic setObject:note forKey:Note];
                        
                        [self.queryResultArr replaceObjectAtIndex:atIndex withObject:currentDic];
                        _index = atIndex;
                        
                        [self performSelector:@selector(performSegueWithIdentifier) withObject:SegueWithIdentifier afterDelay:0.5];                            return;
                        
                        
                    } else {
                        
                        _index = atIndex;
                        
                        //没有备注
                        [self performSelector:@selector(performSegueWithIdentifier) withObject:SegueWithIdentifier afterDelay:0.3];
                    
                        return;
                        
                    }
                    
                } else {
                    
                    _index =self.queryResultArr.count;
                    
                }
                
            }
            
            
            [self.queryResultArr addObject:result];
            [[NSUserDefaults standardUserDefaults]setObject:self.queryResultArr forKey:QUERY_RESULTS];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
    
            [self performSelector:@selector(performSegueWithIdentifier) withObject:SegueWithIdentifier afterDelay:0.3];
           
            
            break;
        }
            
            
        case MailNoExist:
            
                
                AudioServicesPlaySystemSound(sound_fail_id);
        

            [super hideHUD];
            [super performSelector:@selector(showAlertTitle:) withObject:NSLocalizedString(@"No results", @"单号未收录") afterDelay:0.2];
            
            break;
            
        case FormatError:
            
                AudioServicesPlaySystemSound(sound_fail_id);
        

            [super hideHUD];
            [super performSelector:@selector(showAlertTitle:) withObject:NSLocalizedString(@"No results", @"请填写正确单号") afterDelay:0.2];
            
            break;
            
       default:
            
                
                AudioServicesPlaySystemSound(sound_fail_id);
    
            [super hideHUD];
            [super performSelector:@selector(showAlertTitle:) withObject:NSLocalizedString(@"No results", @"单号未收录") afterDelay:0.1];
            
            break;
            
    }
    
}
- (void)performSegueWithIdentifier {
    
    [self performSegueWithIdentifier:SegueWithIdentifier sender:self];
    
}

#pragma mark -
#pragma mark -  Button Action
- (IBAction)startSearch:(id)sender {
    
    [self startSerach];
    
}

- (IBAction)presentBeginSerch:(UIButton *)sender {
    
    
    [self beginSearch];
    
}


#pragma  mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (textField.tag == ExpressNameTextFieldTag) {
        
        [self beginSearch];
        
        return NO;
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    UITextField * expressNumberTextField =  (UITextField*)[self.view viewWithTag:ExpressNumberTextFieldTag];
    UITextField * expressNameTextField   =  (UITextField*)[self.view viewWithTag:ExpressNameTextFieldTag];
    
    if (expressNameTextField.text.length > 0 && expressNumberTextField.text.length > 5) {
        
       self.queryBtn.enabled = YES;
        
    } else {
    
       self.queryBtn.enabled = NO;
        
        if (expressNameTextField.text.length <=5) {
            
            [super showAlertTitle:NSLocalizedString(@"Number least", @"单号长度小于5")];
            
        }
    
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

    //可输入的字符
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    
   
    BOOL basic = [string isEqualToString:filtered];
    
    if (!basic) {
        
        [super showAlertTitle:NSLocalizedString(@"Number", @"仅限字母数字")];
        
    }
    
    return basic;
    
}
- (void)beginSearch {

    ExpressListTableViewController  *expressListViewController =  [[ExpressListTableViewController alloc]init];
    expressListViewController.tableView.tableHeaderView = nil;
    expressListViewController.isPresent = YES;
    expressListViewController.delegate  = self;
    
    UINavigationController  *navigationController  = [[UINavigationController alloc]initWithRootViewController:expressListViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark - MainTableView delegate
- (void)ExpressListView:(ExpressListTableViewController*)controller didSelectWithobject:(Express*)express {
    
    self.express  = express;

    if (self.expressNumberTextField.text.length > 0) {
        
       self.queryBtn.enabled = YES;
    }
    
}

- (void)ExpressListViewDidCanceld:(ExpressListTableViewController*)controller {
    
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - QRCodeView Delegate
- (void)QRCodeReadViewController:(QRCodeReadViewController*) readViewController QRCodeText:(NSString*)codeText {
    
    [self.expressNumberTextField performSelectorOnMainThread:@selector(setText:) withObject:codeText waitUntilDone:YES];
    
    if ([codeText length]>0 &&[self.expressNameTextField.text length] > 0) {
        
        [self performSelectorOnMainThread:@selector(mainThread) withObject:nil waitUntilDone:NO];
        
            }
    
}

- (void)QRCodeReadDismissViewController:(QRCodeReadViewController*)readViewController {
    
    [readViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)mainThread {
    
   self.queryBtn.enabled = YES;
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:SegueWithIdentifier]) {
        
        QueryResultViewController  *queryResultViewController = segue.destinationViewController;
        
        queryResultViewController.dictionary = [self.queryResultArr objectAtIndex:_index];
        queryResultViewController.indexPath = _index;
        queryResultViewController.hidesBottomBarWhenPushed = YES;
       
        
    } else if ([segue.identifier isEqualToString:@"QRcoder"]) {
        
        QRCodeReadViewController  *codeReadViewController = (QRCodeReadViewController*)[segue.destinationViewController topViewController];
        codeReadViewController.QRdelegate = self;
        
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KMusicMoreViewOpen object:self];
    
}
@end

//  QueryResultViewController.m
//  Express
//
//  Created by rango on 14-8-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "QueryResultViewController.h"
#import "QueryResultCell.h"
#import <MessageUI/MessageUI.h>
#import <AudioToolbox/AudioToolbox.h>
#define UILABEL_X 70
#define UILABEL_Y 30
#define UILABEL_WIDTH 240.0f
#define UILABEL_HEIGHT 15.0f
#define VIEW_HEIGHT 55.0f
#define VIEW_WIDTH  60.0f
#define VIEW_X 5.0f
#define VIEW_Y 6.0f

#define NSUserDefaultKey @"queryResult"
#define NoteKey @"note"
#define DataKey @"data"
static SystemSoundID sound_update_id = 0;
static SystemSoundID sound_no_update_id = 0;
@interface QueryResultViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    
    BOOL isMusicOpen;
}

#pragma mark - propertys
@property (weak, nonatomic) IBOutlet UIToolbar    *toolBar;
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (strong, nonatomic) UIRefreshControl    *refreshControl;
@property (strong, nonatomic) NSMutableArray      *dataScource;
@property (strong, nonatomic) QueryResultModel    *queryModel;
@property (strong, nonatomic) UILabel  *noteLabel;

@property (nonatomic) NSInteger status;

@end

@implementation QueryResultViewController

#pragma mark - 加载声音
//更新声音
- (void)loadFreshMessageSound {
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sound_fresh_withmessage" ofType:@"wav"];
    
    if (path) {
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound_update_id);
    }
    
}
//无更新声音
- (void)loadFreshNoMessageSound {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sound_fresh_nomessage" ofType:@"wav"];
    
    if (path) {
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound_no_update_id);
    }
    
    
}
//移除声音
- (void) removeFreshMessageSound {
    
    AudioServicesDisposeSystemSoundID(sound_update_id);
    
}
- (void)removeFreshNoMessageSound {
    
    AudioServicesDisposeSystemSoundID(sound_no_update_id);
    
}
#pragma mark - 初始化
//初始化ableViewHeaderView
- (void)initTableViewHeaderView
{
    
    self.queryModel = [[QueryResultModel alloc]initwithExpress:_dictionary];
    
    UIView * headerView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView * expressImageView   = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_X, VIEW_Y, VIEW_WIDTH, VIEW_HEIGHT-15)];
    expressImageView.contentMode = UIViewContentModeScaleAspectFit;
    expressImageView.image = [UIImage imageNamed:_queryModel.expSpellName];
    
    UILabel  * noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(UILABEL_X,UILABEL_Y -20, UILABEL_WIDTH, UILABEL_HEIGHT+5)];
    self.noteLabel = noteLabel;
    
    noteLabel.tag = UILabelNoteTag;
    
    UILabel  * mailNoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    mailNoLabel.tag = UILabelMailNoTag;
    
    if ([self.queryModel.note length]!= 0) {
        
        noteLabel.text = self.queryModel.note;
        noteLabel.font = [UIFont systemFontOfSize:15];
        mailNoLabel.frame = CGRectMake(UILABEL_X, UILABEL_Y, UILABEL_WIDTH,UILABEL_HEIGHT);
        mailNoLabel.textColor = [UIColor grayColor];
        mailNoLabel.font  = [UIFont systemFontOfSize:10];
        
        
    } else {
        
        mailNoLabel.frame = CGRectMake(UILABEL_X,UILABEL_Y-10, UILABEL_WIDTH, UILABEL_HEIGHT);
        
    }
    
     mailNoLabel.text = [self.queryModel.expTextName stringByAppendingFormat:@" %@",self.queryModel.mailNo];
    
      [headerView addSubview:expressImageView];
      [headerView addSubview:mailNoLabel];
      [headerView addSubview:noteLabel];
    self.tableView.tableHeaderView  = headerView;

    
}


- (void)refreshView:(UIRefreshControl *)refresh
{
    
    if (self.netStatus == kNotReachable) {
        
        [self.refreshControl endRefreshing];
        
        [self showAlertTitle:NSLocalizedString(@"Network error", nil)];
        
        return ;
    }
    
    if (refresh.refreshing) {
        
         NSMutableDictionary * params =[NSMutableDictionary dictionary];
        [params setObject:_queryModel.expSpellName forKey:@"com"];
        [params setObject:_queryModel.mailNo forKey:@"nu"];
        
        
        [TRAsyncURLConnection request:params CompleteBlock:^(NSMutableDictionary *dictionary) {
            
            [self loadResult:dictionary];
            
        } errorBlock:^(NSError *error) {
        
            
        }];
        
    }
}

- (void)loadResult:(NSMutableDictionary *)result {
    
    
        //取出已存在的数据
        NSMutableArray * oldArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:NSUserDefaultKey]];
        
        NSMutableDictionary  *oldDic =  [oldArray objectAtIndex:self.indexPath];
    
        NSString *note = [oldDic objectForKey:NoteKey];
        //已经备注
        if (note) {
            
            NSMutableDictionary  *resultDic = [result mutableCopy];
            
            [resultDic setObject:note forKey:NoteKey];
            [oldArray replaceObjectAtIndex:self.indexPath withObject:resultDic];
            [[NSUserDefaults standardUserDefaults]setObject:oldArray forKey:NSUserDefaultKey];
            
            //没有备注
        } else {
            
            [oldArray replaceObjectAtIndex:self.indexPath withObject:result];
            
            [[NSUserDefaults standardUserDefaults]setObject:oldArray forKey:NSUserDefaultKey];
            
        }
        
    
             [[NSUserDefaults standardUserDefaults]synchronize];
             
              self.dataScource = [result objectForKey:DataKey];
    
             unsigned  int oldCount =   (unsigned int)[[oldDic objectForKey:DataKey]count];
             unsigned  int CurrentCount =  (unsigned int)[[result objectForKey:DataKey]count];
             
             
             if (oldCount == CurrentCount) {
                 
                 AudioServicesPlaySystemSound(sound_no_update_id);
                 [super showAlertTitle:@"暂无更新"];
                 
                 
             } else if (CurrentCount >oldCount) {
                 
                 AudioServicesPlaySystemSound(sound_update_id);
                 [super showAlertTitle:[NSString stringWithFormat:@"%d条更新",CurrentCount -oldCount]];
                 
             }

    
        _status = [[result objectForKey:@"status"]integerValue];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
   
    
    
}

- (void)initStatus {
    
    _status  = [[ _dictionary objectForKey:@"status"]integerValue];
    
    if (_status == 1 || _status ==2 ) {
        
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.tintColor =   UICOLOR(44, 200, 255, 1);
        
        [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        
        self.refreshControl = refresh;
        [self.tableView addSubview:self.refreshControl];
        
    }

}

#pragma mark - 
#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openMusic:) name:KMusicMoreViewOpen object:nil];


    [self initStatus];
    [self initTableViewHeaderView];
     self.dataScource = [_dictionary objectForKey:DataKey];
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
    BOOL isOpen = [[NSUserDefaults standardUserDefaults]boolForKey:kMusicState];
    
    if (isOpen) {
        
        [self loadFreshMessageSound];
        [self loadFreshNoMessageSound];
    }

}

- (void)openMusic:(NSNotification*)noti {
    
    UISwitch *musicSwitch = noti.object;
    
    if (musicSwitch.on) {
        
        [self loadFreshMessageSound];
        [self loadFreshNoMessageSound];
        
    } else {
        
        [self removeFreshMessageSound];
        [self removeFreshNoMessageSound];
        
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - TableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataScource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"QueryResultCell";
    
    QueryResultCell * cell = (QueryResultCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
     cell.checkMarkImageView.image = [UIImage imageNamed:@"icon_result_onload"];


        if (indexPath.row == 0) {
            
            
            if (_status == 1 || _status == 2) {
                
                UIColor *color = UICOLOR(255.0, 99.0, 0.0, 1.0);
                cell.expressContentLabel.textColor  = color;
                cell.expressHourLabel.textColor = color;
                cell.expressDateLabel.textColor = color;
                cell.checkMarkImageView.image = [UIImage imageNamed:@"icon_result_onloading"];
                cell.expressContentLabel.font = [UIFont systemFontOfSize:16];
                
            } else if (_status ==3) {
                
                UIColor * color  = color = UICOLOR(44.0, 148.0, 255.0, 1.0);
                cell.expressContentLabel.textColor  = color;
                cell.expressHourLabel.textColor = color;
                cell.expressDateLabel.textColor = color;
                cell.checkMarkImageView.image = [UIImage imageNamed:@"icon_result_signed"];
                cell.expressContentLabel.font = [UIFont systemFontOfSize:16];
            }
            
        } else {
            
            cell.expressContentLabel.textColor  = [UIColor grayColor];
            cell.expressHourLabel.textColor = [UIColor grayColor];
            cell.expressDateLabel.textColor = [UIColor grayColor];
        }
        
        
        NSDictionary * dic  = [self.dataScource objectAtIndex:indexPath.row];
        
        NSString * context = [dic objectForKey:@"context"];
        NSString * time    = [dic objectForKey:@"time"];
        
        NSDate  *date = [self formatterString:time];
        
        NSString  * dateString = [self compareDate:date];
        NSString  * hourString = [time substringWithRange:NSMakeRange(10, 6)];
    
        cell.expressContentLabel.text = context;
        cell.expressDateLabel.text = dateString;
        cell.expressHourLabel.text = hourString;


    return cell;
}

#pragma mark - 
#pragma mark - UITabelView delegate
#define TEXT_SIZE_WIDTH  230
#define TEXT_SIZE_HEIGHT 1000
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    QueryResultCell * cell = (QueryResultCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UIFont *font =  indexPath.row == 0 ? [UIFont systemFontOfSize:16] :[UIFont systemFontOfSize:14];
    
    CGSize textSize = CGSizeMake(TEXT_SIZE_WIDTH,TEXT_SIZE_HEIGHT);
    NSDictionary * attributes = @{NSFontAttributeName: font};
    
    CGRect labelRect =[cell.expressContentLabel.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGRectGetHeight(labelRect)+30;
    

}

#pragma mark -
#pragma mark - Action Method

- (IBAction)editNoteAction:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Note", @"添加备注")
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirmAction   = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        UITextField *textField =alertController.textFields.firstObject;
        
        NSMutableArray * array = [[[NSUserDefaults standardUserDefaults]objectForKey:QUERY_RESULTS]mutableCopy];
        
        NSMutableDictionary * dic = [[array objectAtIndex:self.indexPath]mutableCopy];
        
        [dic setValue:textField.text forKey:NoteKey];
        
        [array replaceObjectAtIndex:self.indexPath withObject:dic];
        
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:QUERY_RESULTS];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        UILabel * noteLabel  = (UILabel*)[self.tableView.tableHeaderView viewWithTag:UILabelNoteTag];
        
        UILabel * mailNoLabel = (UILabel*)[self.tableView.tableHeaderView viewWithTag:UILabelMailNoTag];
        
        if ([textField.text length] > 0) {
            
            
            noteLabel.hidden = NO;
            noteLabel.text = textField.text;
            noteLabel.frame = CGRectMake(UILABEL_X, UILABEL_Y -20, UILABEL_WIDTH, UILABEL_HEIGHT+5);
            
            mailNoLabel.frame = CGRectMake(UILABEL_X, UILABEL_Y, UILABEL_WIDTH, UILABEL_HEIGHT);
            mailNoLabel.textColor = [UIColor grayColor];
            mailNoLabel.font  = [UIFont systemFontOfSize:10];
            
            
        } else {
            
            
            mailNoLabel.frame = CGRectMake(UILABEL_X,UILABEL_Y-10, UILABEL_WIDTH, UILABEL_HEIGHT);
            mailNoLabel.font  = [UIFont systemFontOfSize:18.0f];
            mailNoLabel.textColor = [UIColor blackColor];
            noteLabel.hidden = YES;
            
            
        }
        
        
        [super showAlertTitle:NSLocalizedString(@"Modified", @"修改备注成功")];
        
    }];
    
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        
        NSMutableArray * array = [[[NSUserDefaults standardUserDefaults]objectForKey:QUERY_RESULTS]mutableCopy];;
        
        NSDictionary * dic = [array objectAtIndex:self.indexPath];
        
        NSString *text = [dic objectForKey:NoteKey];
        
        textField.text = text;
        
        textField.clearButtonMode =UITextFieldViewModeWhileEditing;
        
        
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

- (IBAction)copyMailNo:(id)sender {
    
    [[UIPasteboard  generalPasteboard]setString:_queryModel.mailNo];
    
    [self showAlertTitle:NSLocalizedString(@"Copy", @"复制单号成功")];

}
//转发邮件 短信
- (IBAction)transpondMailNo:(id)sender {
   
            NSArray  * messageArray = [_dictionary objectForKey:DataKey];
            
            NSString * messageBody = [NSString stringWithFormat:@"%@",[messageArray objectAtIndex:0]];
            
            NSString * str = [messageBody stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
            
            NSString * str1 = [[@"\"" stringByAppendingString:str]stringByAppendingString:@"\""];
            NSData *tempData = [str1 dataUsingEncoding:NSUTF8StringEncoding];
            
            NSPropertyListFormat format;
            
            messageBody =  [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:&format error:nil];
            

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
              
          }];
            
            //email
            UIAlertAction *emailAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send Email", @"邮件发送") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
               
                
                Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
                
                if (mailClass != nil) {
                    
                    //快递标题
                    NSString * emailTitle = NSLocalizedString(@"Results", @"快递结果");
                    
                    //快递内容
                    MFMailComposeViewController * mailViewController = [[MFMailComposeViewController alloc]init];
                    
                    mailViewController.mailComposeDelegate = self;
                    [mailViewController setSubject:emailTitle];
                    [mailViewController setMessageBody:messageBody isHTML:NO];
                    [mailViewController setToRecipients:nil];
                    
                    [self presentViewController:mailViewController animated:YES completion:nil];
                }
               
                
            }];
            
            
            //message
            UIAlertAction *messageAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send Message", @"短信发送") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
               
                Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
                if (messageClass!= nil) {
                    
                    MFMessageComposeViewController * messageViewController = [[MFMessageComposeViewController alloc]init];
                    messageViewController.messageComposeDelegate = self;
                    
                    messageViewController.body  = [NSString stringWithFormat:@"%@",messageBody];
                    
                    [self presentViewController:messageViewController animated:YES completion:nil];
                    
                }

                
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:emailAction];
            [alertController addAction:messageAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
    
    
}

#pragma mark - MFMailComposeViewController  Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    
    NSString  *resultString;
    
    switch (result) {
            
        case MFMailComposeResultCancelled:
            
            resultString = NSLocalizedString(@"Canceled", @"已经取消");
            break;
            
        case MFMailComposeResultSaved:
            
            resultString = NSLocalizedString(@"Saved", @"已保存");
            break;

        case MFMailComposeResultSent:
            
          resultString = NSLocalizedString(@"Successed", @"已发送");
            break;

       case MFMailComposeResultFailed:
            
           resultString = NSLocalizedString(@"Send failed", @"发送失败");
            break;
            
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [super showAlertTitle:resultString];
        
        
    }];

    
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
 
    NSString  *resultString;
    switch (result) {
            
        case MessageComposeResultCancelled:
            
            resultString = NSLocalizedString(@"Canceled", @"已经取消");
            break;
            
        case MessageComposeResultSent:
            
            resultString = NSLocalizedString(@"Successed", @"已发送");
            break;
            
            
        case MessageComposeResultFailed:
            resultString = NSLocalizedString(@"Send failed", @"发送失败");
            break;
        
     }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [super showAlertTitle:resultString];
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KMusicMoreViewOpen object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    
}
@end

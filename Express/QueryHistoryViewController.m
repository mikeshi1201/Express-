//
//  QueryHistoryViewController.m
//  Express
//
//  Created by rango on 14-10-1.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "QueryHistoryViewController.h"
#import "QueryResultViewController.h"
#import "ExpressHistoryCell.h"
#import "UIViewExt.h"
#define DEFAULT_ROW_HEIGHT 80          
#define SegueIdentifier @"NextHistory"
#define TabBarSubView_Y 49
@interface QueryHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataScource;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelMarkButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *allMarkButton;
@property (strong, nonatomic) UIButton *deleteButton;


@end

@implementation QueryHistoryViewController

- (void)synchronizeData {
    
    [[NSUserDefaults standardUserDefaults]setObject:self.dataScource forKey:QUERY_RESULTS];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    self.tableView.rowHeight = DEFAULT_ROW_HEIGHT;
    
    UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableHeaderView"]];
    self.tableView.tableHeaderView = headerView;
    
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.dataScource =  [[[NSUserDefaults standardUserDefaults]objectForKey:QUERY_RESULTS]mutableCopy];
    
    [self.tableView reloadData];
    [self updateButtonsToMatchTableState];
    
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataScource.count > 0) {
        
        self.tableView.backgroundView = nil;
        return self.dataScource.count;
        
    } else {
        
        UIView  *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        
        UIImage *backgroundImage  = [UIImage imageNamed:@"icon_content_empt"];
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
        
        backgroundImageView.frame = CGRectMake((SCREEN_WIDTH-backgroundImage.size.width)/2, (SCREEN_HEIGHT - backgroundImage.size.height)/2,backgroundImage.size.width,backgroundImage.size.height);
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(backgroundImageView.left , backgroundImageView.bottom+10, backgroundImageView.width+20, 20)];
        messageLabel.text = @"您当前还没有快递单哦";
        messageLabel.font = [UIFont systemFontOfSize:13];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        
        
        [backgroundView addSubview:backgroundImageView];
        [backgroundView addSubview:messageLabel];
        
        self.tableView.backgroundView = backgroundView;
        
        
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ExpressHistoryCell";
    
    ExpressHistoryCell * cell = (ExpressHistoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSDictionary  *dic =   self.dataScource[indexPath.row];
    QueryResultModel *queryModel  = [[QueryResultModel alloc]initwithExpress:dic];

    cell.model = queryModel;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController *deleteAlertController  = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"Message", @"提示") message:NSLocalizedString(@"Delete One", @"您确定删除这个订单") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction  *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            
            [self updateButtonsToMatchTableState];
            
            self.tableView.allowsMultipleSelectionDuringEditing = YES;
            
            
        }];
        
        UIAlertAction *configAction  = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [self.dataScource removeObjectAtIndex:indexPath.row];
            [self synchronizeData];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.tableView setEditing:NO animated:YES];
            
            [self updateButtonsToMatchTableState];
        }];
        
        [deleteAlertController addAction:cancelAction];
        [deleteAlertController addAction:configAction];
        
        [self presentViewController:deleteAlertController animated:YES completion:nil];
        
        [tableView reloadData];
    }
    
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    

    
}
//表格结束编辑的时候
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.navigationItem.rightBarButtonItem = self.editButton;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //在编辑的时候
    if (!tableView.editing) {
        
        [self performSegueWithIdentifier:SegueIdentifier sender:indexPath];
        
     
    //不在编辑的时候
    }  else {
        
        //更新按钮状态
        [self updateDeleteButtonState];
        
    }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //更新按钮状态
    [self updateDeleteButtonState];
    
}

#pragma mark - CreateTabBarSubview 

- (void)createSubViewOfTabBarSubView {
    
    
    for (UIView *tabBarSubView in [self.tabBarController.view subviews]) {
        if ([tabBarSubView isKindOfClass:[UITabBar class]]) {
            
            [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = tabBarSubView.frame;
                frame.origin.y += TabBarSubView_Y;
                tabBarSubView.frame = frame;
                
            } completion:^(BOOL complete) {
                
                UIView *tabBarView = [[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT -46, SCREEN_WIDTH-20, 36)];
                tabBarView.layer.cornerRadius = 5.0;
                
                tabBarView.backgroundColor = [UIColor colorWithRed:44/255.0 green:200/255.0 blue:1 alpha:0.8];
                tabBarView.tag =tabBarSubViewTag;
                
                self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
                [self.deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
                [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                self.deleteButton.frame = CGRectMake(0, 2, tabBarView.frame.size.width, tabBarView.frame.size.height);
                
                [self.deleteButton addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
                [tabBarView addSubview:self.deleteButton];
                [self updateButtonsToMatchTableState];
                
                [self.view insertSubview:tabBarView aboveSubview:self.tableView];
                
                
                
            }];
        }

    }
}

- (void)removeSubViewOfTabBarView {
    
    
    for (UIView *tabBarSubView in [self.tabBarController.view subviews]) {
        if ([tabBarSubView isKindOfClass:[UITabBar class]]) {
            
            [UIView animateWithDuration:0.1 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                
                CGRect frame = tabBarSubView.frame;
                frame.origin.y -= TabBarSubView_Y;
                tabBarSubView.frame = frame;
                
            } completion:^(BOOL complete) {
                
                UIView *tabBarView = [self.view viewWithTag:tabBarSubViewTag];
                
                [tabBarView removeFromSuperview];
            }];
            
        }
    }

}
#pragma mark -Action method

- (IBAction)editAction:(id)sender {
    
    
    [self.tableView setEditing:YES animated:YES];
    [self createSubViewOfTabBarSubView];
    
   
}

- (IBAction)cancelAction:(id)sender {
    
    
    if (self.tableView. allowsMultipleSelectionDuringEditing == YES) {
        
        [self.tableView setEditing:NO animated:YES];
        [self updateButtonsToMatchTableState];
        [self removeSubViewOfTabBarView];
        
    } else {
        
        [self.tableView setEditing:NO animated:YES];
    }
    
    
}

- (void)deleteData {
    
    
    NSString *message =  [[self.tableView indexPathsForSelectedRows]count] == self.dataScource.count ? NSLocalizedString(@"Delete All", @"您确定删除所有订单"):NSLocalizedString(@"Delete One", @"您确定删除这个订单");
    
    NSString *cancelActionTitle  = NSLocalizedString(@"Cancel", @"取消");
    NSString *confirmActionTitle = NSLocalizedString(@"OK", @"确定");
    
    
    //alertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", @"提示")message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //cancel Action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self updateButtonsToMatchTableState];
        
    }];
    

    //confirm Action
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        
    
        BOOL deleteSpecificRows = selectedRows.count > 0;
        
        if (deleteSpecificRows) {
            
            
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            for (NSIndexPath *selectionIndex in selectedRows) {
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
            }
            
            [self.dataScource removeObjectsAtIndexes:indicesOfItemsToDelete];
            [self synchronizeData];
            
            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            [self updateButtonsToMatchTableState];
            
        } else {
            
            //delete All Data
            [self.dataScource removeAllObjects];
            //synchronize data
            [self synchronizeData];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        
        [self.tableView setEditing:NO animated:YES];
        
        [self updateButtonsToMatchTableState];
        [self removeSubViewOfTabBarView];
        
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    

    
}
- (IBAction)deleteAction:(id)sender {

    NSString *message =  [[self.tableView indexPathsForSelectedRows]count] ==1 ? NSLocalizedString(@"Delete One", @"您确定删除这个订单") : NSLocalizedString(@"Delete All", @"您确定删除所有订单");
    
    NSString *cancelActionTitle  = NSLocalizedString(@"Cancel", @"取消");
    NSString *confirmActionTitle = NSLocalizedString(@"OK", @"确定");
    
    //alertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", @"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    //cancel Action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelActionTitle style:UIAlertActionStyleCancel handler:nil];
    //confirm Action
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        
        
        
        BOOL deleteSpecificRows = selectedRows.count > 0;
        
        if (deleteSpecificRows) {
            
            
            NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
            
            for (NSIndexPath *selectionIndex in selectedRows) {
                
                [indicesOfItemsToDelete addIndex:selectionIndex.row];
            }
            
            [self.dataScource removeObjectsAtIndexes:indicesOfItemsToDelete];
            [self synchronizeData];
            
            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
            [self updateButtonsToMatchTableState];
            
        } else {
            
            //delete All Data
            [self.dataScource removeAllObjects];
            //synchronize data
            [self synchronizeData];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        [self.tableView setEditing:NO animated:YES];
        [self updateButtonsToMatchTableState];
        
    }];
    
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
- (IBAction)cancelMark:(id)sender {
    
    
  NSArray *selectedRows  = [self.tableView indexPathsForSelectedRows];
    
    for (int row = 0; row<selectedRows.count; row++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    [self updateDeleteButtonState];
    
}
- (IBAction)allMark:(id)sender {
    
    
    for (int  row = 0; row <self.dataScource.count; row++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

    self.navigationItem.leftBarButtonItem = self.cancelMarkButton;
    [self updateDeleteButtonState];

    
}

#pragma mark - update ButtonTitle
- (void)updateButtonsToMatchTableState {
    
    if (self.tableView.editing) {
        
        self.navigationItem.rightBarButtonItem = self.cancelButton;
        [self updateDeleteButtonState];
        self.navigationItem.leftBarButtonItem = self.allMarkButton;
        
    } else {
        
        self.editButton.enabled =  self.dataScource.count >0 ? YES : NO;
        self.navigationItem.rightBarButtonItem = self.editButton;
        self.navigationItem.leftBarButtonItem  = nil;
        
    }
}

- (void)updateDeleteButtonState {
    
    NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
    
    if ( selectRows.count>0) {

        self.deleteButton.enabled =YES;
       
        
        if (selectRows.count == self.dataScource.count ) {
            
            self.navigationItem.leftBarButtonItem = self.cancelMarkButton;
            
        } else {
            
            self.navigationItem.leftBarButtonItem = self.allMarkButton;
            
        }
        
        
    } else {
        
        self.navigationItem.leftBarButtonItem = self.allMarkButton;
        self.deleteButton.enabled =NO;
    }
    

    
}
#pragma mark -  Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.tableView  deselectRowAtIndexPath:sender animated:YES];
    
    if ([segue.identifier isEqualToString:SegueIdentifier]) {
        
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        NSDictionary *dic = [self.dataScource objectAtIndex:indexPath.row];
        
        QueryResultViewController  *queryResultController = segue.destinationViewController;
        
        queryResultController.dictionary  = dic;
        queryResultController.indexPath   = indexPath.row;
        queryResultController.hidesBottomBarWhenPushed = YES;
        
    }

}



@end

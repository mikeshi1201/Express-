//
//  MainTableViewController.m
//  Express
//
//  Created by rango on 14-7-21.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "ExpressListTableViewController.h"
#import "QueryViewController.h"
#import "SectionHeaderView.h"
#import "SearchResultsTableViewController.h"
static NSString*SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface ExpressListTableViewController ()


@property (strong, nonatomic) NSMutableArray        *indexArray;
@property (strong, nonatomic) NSMutableArray        *arrayDictKey;
@property (strong, nonatomic) NSMutableDictionary   *arrayDict;
@property (strong, nonatomic) NSArray *dataScoure;


@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultsTableViewController *resultsTableViewController;


- (Express *)isSearchCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ExpressListTableViewController


- (void)init_SearchData {
    
     NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"express" ofType:@"plist"];

     self.dataScoure = [NSArray arrayWithContentsOfFile:bundlePath];

    NSString *path = [[NSBundle mainBundle]pathForResource:@"indexArray" ofType:@"plist"];
    
    NSMutableArray  *indexArray    = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableArray  *arrayDictKey  =[[NSMutableArray alloc]initWithCapacity:self.dataScoure.count];
    NSMutableDictionary *arrayDict = [[NSMutableDictionary alloc]init];
    

    
    for (int i = 0; i<indexArray.count; i++) {
        
            NSMutableArray * array = [self sortArray:indexArray[i]];
            
            [arrayDict setObject:array forKey:[indexArray objectAtIndex:i]];
            
            [arrayDictKey addObject:[indexArray objectAtIndex:i]];

        
    }
    
    self.indexArray    =  indexArray;
    self.arrayDictKey  =  arrayDictKey;
    self.arrayDict     =  arrayDict;
 
    
}
- (NSMutableArray*)sortArray:(NSString*)fl{
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dic in self.dataScoure) {
        
        NSString *type = [dic objectForKey:@"index"];
        
        if ([fl isEqualToString:type]) {
            
            [array addObject:dic];
        }
    }
    
    return array;

}

- (void)initPresentButton {
    
    if  (_isPresent ==YES){
    
        self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Cancel", nil)
                          style:UIBarButtonItemStylePlain
                         target:self
                         action:@selector(cancelAction:)];

        self.title = NSLocalizedString(@"Carrier", @"选择快递公司");
        
    }

}
- (void)cancelAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(ExpressListViewDidCanceld:)]) {
        
        [_delegate ExpressListViewDidCanceld:self];
        
    }
    
}

- (Express *)isSearchCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array  = [self.arrayDict valueForKey:[self.arrayDictKey objectAtIndex:indexPath.section]];
    
    NSDictionary *dic = array[indexPath.row];

    Express *express = [[Express alloc]initWithExpressDic:dic];
    
    return express;
    
}

//初始化SearchController
- (void)initializationSearchController {
    
    _resultsTableViewController = [[SearchResultsTableViewController alloc]init];
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:self.resultsTableViewController];
    
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.resultsTableViewController.tableView.delegate = self;
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;

}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    self.tableView.sectionIndexColor = [UIColor  lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    UINib *sectionheaderNib  =[UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    
    [self.tableView registerNib:sectionheaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    [self initializationSearchController];
    
    [self init_SearchData];
    
    _isPresent = NO;

}

- (void)viewWillAppear:(BOOL)animated  {
    
    [super viewWillAppear:animated];
    
    [self initPresentButton];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
}


- (NSArray*)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K  contains[cd] %@",scope,searchText];
    
    NSArray *array = [self.dataScoure filteredArrayUsingPredicate:predicate];
    
    return array;
  
}

#pragma -mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    
    NSArray *resultsArray = [self filterContentForSearchText:searchText scope:[Express keyName]];
  
    

    SearchResultsTableViewController *tabelViewController = (SearchResultsTableViewController*)searchController.searchResultsController;
    
    tabelViewController.filteredExpresss =resultsArray;
    
    [tabelViewController.tableView reloadData];

}
#pragma mark - TableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayDictKey.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [self.arrayDict valueForKey:[self.arrayDictKey objectAtIndex:section]];
    
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *CellIdentifier = @"Cell";
    
     SWTableViewCell *cell = (SWTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        
        cell = [[SWTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor whiteColor]icon:[UIImage imageNamed:@"icon_phone"]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor whiteColor]icon:[UIImage imageNamed:@"icon_network"]];
        [cell setRightUtilityButtons: rightUtilityButtons WithButtonWidth:45.0f];

         cell.delegate = self;
        
        
        UIImageView *expressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 2, 40, 40)];
        expressImageView.contentMode = UIViewContentModeScaleAspectFit;
        expressImageView.clipsToBounds = YES;
        
        expressImageView.layer.cornerRadius = 19.5f;
        expressImageView.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
        expressImageView.tag = CellImageTag;
    
    
        
        UILabel *expressNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(expressImageView.right+20, 10, 180, 24)];
        expressNameLabel.font = [UIFont fontWithName:@"American Typewriter Regular" size:14];
        
        expressNameLabel.tag = CellLabelTag;
        
        [cell.contentView addSubview:expressImageView];
        
        [cell.contentView addSubview:expressNameLabel];
        
        
    }

    Express *express = [self isSearchCellForRowAtIndexPath:indexPath];
    [self configureCell:cell forExpress:express];

    return cell;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSInteger count = 0;
    if ([title isEqualToString:@"{search}"]) {
        [self.tableView setContentOffset:CGPointMake(0, -10)];
        return -1;
    }
    
    for (NSString * indexString in self.arrayDictKey)
    {
        if ([indexString isEqualToString:title]){
            return count;
        }
        count ++;
    }
    return 0;
}

#pragma mark - 
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        Express *selectExpress = (tableView == self.tableView ) ? [self isSearchCellForRowAtIndexPath:indexPath] : [[Express alloc]initWithExpressDic:[self.resultsTableViewController.filteredExpresss objectAtIndex:indexPath.row]];
    
    
        if ([_delegate respondsToSelector:@selector(ExpressListView:didSelectWithobject:)])
         {
            
            [_delegate   ExpressListView:self didSelectWithobject:selectExpress];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            QueryViewController * queryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"queryViewController"];
            queryViewController.express =selectExpress;
            
            [self.navigationController pushViewController:queryViewController animated:YES];
            
        }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeaderView *sectionHeadView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    
    if (tableView != self.tableView) {
        
        sectionHeadView.headerLabel.textColor = [UIColor redColor];
        sectionHeadView.headerLabel.text = NSLocalizedString(@"Result", @"搜索结果");
        
        
    }  else {
        
        
        NSString * string  = [self.arrayDictKey objectAtIndex:section];
        
        if ([string isEqualToString:@"{search}"]) {
            
            sectionHeadView.headerLabel.textColor = [UIColor redColor];
            
            sectionHeadView.headerLabel.text = NSLocalizedString(@"Favorites", @"★常用快递");
            

            
        } else {
            
            sectionHeadView.headerLabel.text  = [self.arrayDictKey objectAtIndex:section];
            sectionHeadView.headerLabel.textColor = [UIColor lightGrayColor];
            
        }
    
    }

    return sectionHeadView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}

#pragma mark - 
#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
        Express * express =  [self isSearchCellForRowAtIndexPath:indexPath];
    
       
    if (index == SWTableCellIndexTelTag) {
        
          [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",express.phone]]];
        
    } else if (index == SWTableCellIndexURlTag){
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:express.expressWebUrl]];
        
    }
    

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    
    return YES;
    
}
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    
    return YES;
    
}


@end

//
//  SearchResultsTableViewController.m
//  Express
//
//  Created by rango on 14-9-29.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//A

#import "SearchResultsTableViewController.h"
#import "Express.h"
@interface SearchResultsTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end
static NSString * kCellIdentifier = @"cell";
@implementation SearchResultsTableViewController

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredExpresss.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
    
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        
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
    
    NSDictionary *dic = self.filteredExpresss[indexPath.row];

    Express * express = [[Express alloc]initWithExpressDic:dic];
    
    [self configureCell:cell forExpress:express];

    return cell;
}



@end

//
//  PageViewController.m
//  Express
//
//  Created by rango on 14/10/20.
//  Copyright (c) 2014年 vsuntek. All rights reserved.
//

#import "PageViewController.h"
#define Button_X 100
#define Button_Y 380
#define Button_width 120
#define Button_height 30
@interface PageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *page1;
@property (nonatomic,strong) UIView *page2;
@property (nonatomic,strong) UIView *page3;
@property (nonatomic,strong) UIView *page4;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width *4, self.scrollView.frame.size.height);
    
     UIImageView *page1ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page1"]];
    self.page1 = page1ImageView;
    self.page1.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);
    

    
    UIImageView *page2ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page2"]];
    self.page2 = page2ImageView;
    self.page2.frame = CGRectMake(SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    UIImageView *page3ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page3"]];
    self.page3 = page3ImageView;
    self.page3.frame = CGRectMake(SCREEN_WIDTH*2, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    UIImageView *page4ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page4"]];
    page4ImageView.userInteractionEnabled = YES;
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    startButton.tintColor = [UIColor whiteColor];
    [startButton setBackgroundColor:[UIColor orangeColor]];
    
    startButton.frame = CGRectMake(Button_X,Button_Y,Button_width,Button_height);
    [page4ImageView addSubview:startButton];
    startButton.layer.cornerRadius = 5.0f;
    startButton.layer.borderWidth  = 1.0f;
    startButton.layer.borderColor  = [UIColor whiteColor].CGColor;

    
    [startButton addTarget:self action:@selector(startSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    self.page4 = page4ImageView;
    self.page4.frame = CGRectMake(SCREEN_WIDTH *3, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT);
 

    [self.scrollView addSubview:self.page1];
    [self.scrollView addSubview:self.page2];
    [self.scrollView addSubview:self.page3];
    [self.scrollView addSubview:self.page4];
    
    
    // Do any additional setup after loading the view.
}

- (void)startSearch:(UIButton*)button {
    
    UIViewController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"myTabBarController"];
    
    [self presentViewController:tabBarController animated:NO completion:nil];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = offset.x / SCREEN_WIDTH;
    
}
- (IBAction)changePage:(id)sender {
    
    NSInteger whichPage = self.pageControl.currentPage;
    self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*whichPage, 0.0f);
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

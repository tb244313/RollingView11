
//
//  MainViewController.m
//  RollingView
//
//  Created by apple on 17/2/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>

//声明一个属性
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, width, 420)];
    [self.scrollView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.scrollView];
    
    //设置滚动区域
    [self.scrollView setContentSize:CGSizeMake(width * 5, 0)];
    //设置分页
    [self.scrollView setPagingEnabled:YES];
    //隐藏水平滚动条
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    
    //设置内容视图
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, 420)];
        //图片素材名称改得有规律,通过循环体来进行图片的添加 ％d进行占位 索引 i传过来
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_0%zd",i]]];
        [self.scrollView addSubview:imageView];
    }
    
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)-20, width, 20)];
    [self.pageControl setNumberOfPages:5];
    [self.pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    [self.view addSubview:self.pageControl];
    
    [self initTimer];
}


//封装timer
-(void)initTimer
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
        //timer设置在哪个线程中
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }


}

//定时器来动态控制滚动视图
-(void)scrollImage
{

    NSInteger currentPage = self.pageControl.currentPage + 1;
    
    if (currentPage >= 5) {
        currentPage = 0;
    }
    
    //偏移量
    [self.scrollView setContentOffset:CGPointMake(currentPage * CGRectGetWidth(self.scrollView.frame),0) animated:YES];

}
//pageControl随着scrollView一起滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage:(NSInteger)(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame))];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    if(self.timer){
    
        //失效
        [self.timer invalidate];
        [self setTimer:nil];
    
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    [self initTimer];

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

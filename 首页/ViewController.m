//
//  ViewController.m
//  首页
//
//  Created by xxzx on 15/7/1.
//  Copyright (c) 2015年 hxyxt. All rights reserved.
//

#import "ViewController.h"



#define mainwidth   [UIScreen mainScreen].bounds.size.width
#define mainhight   [UIScreen mainScreen].bounds.size.height
// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

const int IWNewfeatureImageCount = 4;
const CGFloat gap = 5;

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *ts6;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *scrollView;//滑动广告页
@property (nonatomic, strong) UIPageControl *pageControl;

/***  定时器*/
@property (nonatomic, strong) NSTimer *timer;

@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    self.view.backgroundColor =[UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    
    
    ////////////////顶栏//////////////////////
    //广告标志
    UIImageView *logo = [[UIImageView alloc] init];
    logo.frame = CGRectMake(0, 0, 40, 40);
    logo.image = [UIImage imageNamed:@"lg.png"];
    
    
    //搜索小按钮
    UIButton*btSearch = [[UIButton alloc] init];
    btSearch.frame = CGRectMake(0, 0, 230, 30);
    [btSearch setBackgroundImage:[UIImage imageNamed:@"搜索"] forState:0];
 
    
    //二维码小按钮
    UIButton*ewm= [[UIButton alloc] init];
    ewm.frame = CGRectMake(0,0, 40, 30);
    [ewm setTitle:@"搜索" forState:UIControlStateNormal];
    
   UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:logo];
   UIBarButtonItem*item3 = [[UIBarButtonItem alloc]initWithCustomView:ewm];

    
    
    self.navigationItem.leftBarButtonItem = item1;
    self.navigationItem.titleView = btSearch;
    self.navigationItem.rightBarButtonItem = item3;

    UIScrollView *mainScrollView = [[UIScrollView alloc] init];

    mainScrollView.frame = CGRectMake(0, 0, mainwidth, mainhight);
    mainScrollView.backgroundColor =IWColor(233,234,235);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.pagingEnabled = YES;

    mainScrollView.alwaysBounceVertical =NO;
    mainScrollView.contentSize = CGSizeMake(mainwidth, 1300);
    [self.view addSubview:mainScrollView];
    self.mainScrollView=mainScrollView;
    

    
    // 1.添加UISrollView
    [self setupScrollView];
    // 2.添加pageControl
    [self setupPageControl];
    
    
    [self initSpecialView];
    [self initTotGoods];
    [self Recommendedproducts];
   
}

    ////////////添加轮播图
    ////加入页面点
    - (void)setupPageControl
    {
        // 1.添加
        UIPageControl *toppageControl = [[UIPageControl alloc] init];
        toppageControl.numberOfPages = IWNewfeatureImageCount;
        CGFloat centerX = self.view.frame.size.width * 0.5;
       CGFloat centerY = 170 - 10;
        toppageControl.center = CGPointMake(centerX, centerY);
        toppageControl.bounds = CGRectMake(0, 0, 50, 30);
        toppageControl.userInteractionEnabled = NO;
        [self.mainScrollView addSubview:toppageControl];
        self.pageControl = toppageControl;
        
        // 2.设置圆点的颜色
        self.pageControl.currentPageIndicatorTintColor = IWColor(253, 98, 42);
        self.pageControl.pageIndicatorTintColor = IWColor(189, 189, 189);
    }
    
    /**
     *  添加UISrollView
     */
    - (void)setupScrollView
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, mainwidth, 170);
        scrollView.delegate = self;
        [self.mainScrollView addSubview:scrollView];
        
        // 2.添加图片
        CGFloat imageW = scrollView.frame.size.width;
        CGFloat imageH = scrollView.frame.size.height;
        for (int index = 0; index<IWNewfeatureImageCount; index++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            
            // 设置图片
            NSString *name = [NSString stringWithFormat:@"%d.jpg", index + 1];
            imageView.image = [UIImage imageNamed:name];
            
            // 设置frame
            CGFloat imageX = index * imageW;
            imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
            
            [scrollView addSubview:imageView];
            
            self.scrollView=scrollView;
        }
        
        
        // 3.设置滚动的内容尺寸
        scrollView.contentSize = CGSizeMake(imageW * IWNewfeatureImageCount, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        
        // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
        [self addTimer];
    }
    
    /**
     *  添加定时器
     */
    - (void)addTimer
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
    /**
     *  移除定时器
     */
    - (void)removeTimer
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    - (void)nextImage
    {
        // 1.增加pageControl的页码
        long page = 0;
        if (self.pageControl.currentPage == IWNewfeatureImageCount - 1) {
            page = 0;
        } else {
            page = self.pageControl.currentPage + 1;
        }
        
        // 2.计算scrollView滚动的位置
        CGFloat offsetX = page * self.scrollView.frame.size.width;
        CGPoint offset = CGPointMake(offsetX, 0);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
    
    
    /**
     *  开始拖拽的时候调用
     */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        // 停止定时器(一旦定时器停止了,就不能再使用)
        [self removeTimer];
    }
    
    /**
     *  停止拖拽的时候调用
     */
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
    {
        // 开启定时器
        [self addTimer];
    }
    
#pragma mark - 代理方法
    /**
     *  只要UIScrollView滚动了,就会调用
     *
     */
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
    {
        // 1.取出水平方向上滚动的距离
        CGFloat offsetX = scrollView.contentOffset.x;
        
        // 2.求出页码
        double pageDouble = offsetX / scrollView.frame.size.width;
        int pageInt = (int)(pageDouble + 0.5);
        self.pageControl.currentPage = pageInt;
    }
    


-(void)initSpecialView
{
    
    UIView  *hotBuyView = [[UIView alloc]init];
    hotBuyView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)+gap,mainwidth, 50);
    hotBuyView.backgroundColor =IWColor(242, 242, 242);
    [self.mainScrollView addSubview:hotBuyView];
   
    UILabel *tsLb = [[UILabel alloc]initWithFrame:CGRectMake(gap, 0, mainwidth, 50)];
    tsLb.text = @"特色专题";
    [hotBuyView addSubview:tsLb];

    
    
    CGFloat gap = 5;
    CGFloat  pictW  = (mainwidth-20)/3;
    
    
    UIImageView *ts1 = [[UIImageView alloc]init];
    ts1.frame = CGRectMake(gap, CGRectGetMaxY(hotBuyView.frame)+gap, pictW, pictW);
    ts1.image = [UIImage imageNamed:@"药品2.jpg"];
    [self.mainScrollView addSubview:ts1];
    
    
    UIImageView *ts2 = [[UIImageView alloc]init];
    ts2.frame = CGRectMake(pictW+2*gap, CGRectGetMaxY(hotBuyView.frame)+gap, pictW, pictW);
    ts2.image = [UIImage imageNamed:@"药品2.jpg"];
    [self.mainScrollView addSubview:ts2];
    
    
    
    UIImageView *ts3 = [[UIImageView alloc]init];
    ts3.frame = CGRectMake(2*pictW+3*gap, CGRectGetMaxY(hotBuyView.frame)+gap,pictW, pictW);
    ts3.image = [UIImage imageNamed:@"药品2.jpg"];
    [self.mainScrollView addSubview:ts3];
    
    
    
    UIImageView *ts4 = [[UIImageView alloc]init];
    ts4.frame = CGRectMake(gap, CGRectGetMaxY(ts3.frame)+gap,2*pictW+gap, pictW);
    ts4.image = [UIImage imageNamed:@"药品2.jpg"];
    [self.mainScrollView addSubview:ts4];

    
    UIImageView *ts5 = [[UIImageView alloc]init];
    ts5.frame = CGRectMake(CGRectGetMaxX(ts4.frame)+gap, CGRectGetMaxY(ts3.frame)+gap,pictW, pictW/2);
    ts5.image = [UIImage imageNamed:@"药品2.jpg"];
    [self.mainScrollView addSubview:ts5];

    
    UIImageView *ts6 = [[UIImageView alloc]init];
    ts6.frame = CGRectMake(CGRectGetMaxX(ts4.frame)+gap, CGRectGetMaxY(ts5.frame)+gap,pictW, pictW/2);
    ts6.image = [UIImage imageNamed:@"药品2.jpg"];
    [self.mainScrollView addSubview:ts6];
    self.ts6 =ts6;
    
}


-(void)initTotGoods
{
    
   UIView  *hotBuyView = [[UIView alloc]init];
    hotBuyView.frame = CGRectMake(0, CGRectGetMaxY(_ts6.frame),mainwidth, 50);
    hotBuyView.backgroundColor =IWColor(255, 118, 116);
    [self.mainScrollView addSubview:hotBuyView];

    
    UILabel *itemLB = [[UILabel alloc]initWithFrame:CGRectMake(gap, 0, mainwidth, 50)];
    itemLB.text = @" 大家都在买";
    [hotBuyView addSubview:itemLB];
    

    
    
    
    
    
    
    CGFloat lineY =CGRectGetMaxY(hotBuyView.frame);
    CGFloat W =(mainwidth-24)/4;
       CGFloat H = 110;
   
    
    //总列数
    int totalcolumns = 4;
    
    
    for (int i=0; i<4; i ++) {
        
        
        UIImageView*ImageV=[[UIImageView alloc ]init];
        
        ///计算listView框框的位置
        //行号
        int row =i / totalcolumns;
        // 列号
        int col = i % totalcolumns;
        
        CGFloat listView_X =gap+col*(W+gap);
        
        CGFloat listView_Y =lineY+row*(H+gap);
        
        ImageV.frame =  CGRectMake(listView_X,listView_Y,W,H);
        
            ////listView的背景图片
        
        ImageV.image = [UIImage imageNamed:@"药品2.jpg"];
    
        
        [self.mainScrollView addSubview:ImageV];
        
    }



}




-(void)Recommendedproducts
{
    
    UIView  *hotBuyView = [[UIView alloc]init];
    hotBuyView.frame = CGRectMake(0, CGRectGetMaxY(_ts6.frame)+160,mainwidth, 50);
    hotBuyView.backgroundColor =IWColor(96, 174, 52);
    [self.mainScrollView addSubview:hotBuyView];
    
    
    UILabel *itemLB = [[UILabel alloc]initWithFrame:CGRectMake(gap, 0, mainwidth, 50)];
    itemLB.text = @"精品推荐";
    [hotBuyView addSubview:itemLB];
    
    
    
    CGFloat lineY =CGRectGetMaxY(hotBuyView.frame);
    CGFloat W =(mainwidth-20)/3;
    CGFloat H = W+40;
    
    
    //总列数
    int totalcolumns = 3;
    
    
    for (int i=0; i<12; i ++) {
    
        
        UIImageView*ImageV=[[UIImageView alloc ]init];
        
        
        ///计算listView框框的位置
        //行号
        int row =i / totalcolumns;
        // 列号
        int col = i % totalcolumns;
        
        CGFloat listView_X =gap+col*(W+gap);
        
        CGFloat listView_Y =lineY+row*(H+gap);
        
        ImageV.frame =  CGRectMake(listView_X,listView_Y,W,H);
        
        ////listView的背景图片
        
        ImageV.image = [UIImage imageNamed:@"药品2.jpg"];
        
        
        [self.mainScrollView addSubview:ImageV];
        
    }


}





@end

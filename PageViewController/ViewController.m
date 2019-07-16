//
//  ViewController.m
//  PageViewController
//
//  Created by 大碗豆 on 17/3/16.
//  Copyright © 2017年 大碗豆. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>



@property (nonatomic,strong)UIView *titleV;
@property(nonatomic,strong) UIPageViewController *pageVC;
@property(nonatomic,strong) NSMutableArray *VCarr;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self titleView];
    
}

// 根据数组元素，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewControlller {
    return [self.VCarr indexOfObject:viewControlller];
}



#pragma mark - lazy load

- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        
        /*
         UIPageViewControllerSpineLocationNone = 0, // 默认UIPageViewControllerSpineLocationMin
         UIPageViewControllerSpineLocationMin = 1,  // 书棱在左边
         UIPageViewControllerSpineLocationMid = 2,  // 书棱在中间，同时显示两页
         UIPageViewControllerSpineLocationMax = 3   // 书棱在右边
         */
        
        // 设置UIPageViewController的配置项
        NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMax] forKey:UIPageViewControllerOptionSpineLocationKey];
        
        /*
         UIPageViewControllerNavigationOrientationHorizontal = 0, 水平翻页
         UIPageViewControllerNavigationOrientationVertical = 1    垂直翻页
         */
        /*
         UIPageViewControllerTransitionStylePageCurl = 0, // 书本效果
         UIPageViewControllerTransitionStyleScroll = 1 // Scroll效果
         */
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        
        // 定义“这本书”的尺寸
        //        _pageVC.view.frame = CGRectMake(50, 100, 200, 300);
        _pageVC.view.frame = self.view.bounds;
        
        // 要显示的第几页
        //        NSArray *vcs = [NSArray arrayWithObject:self.viewControllers[2]];
        
        // 如果要同时显示两页，options参数要设置为UIPageViewControllerSpineLocationMid
        NSArray *vcs = [NSArray arrayWithObjects:self.VCarr[0], nil];
        
        [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
    return _pageVC;
}


- (NSMutableArray *)VCarr {
    if (!_VCarr) {
        _VCarr = [NSMutableArray new];
        
        NSArray *ViewControllerNames = [NSArray new];
        ViewControllerNames = @[@"omeViewController",@"towViewController",@"threeViewController",@"fourViewController"];
        
        for (int index = 0; index < ViewControllerNames.count; index++) {
            
            NSString *vcName = ViewControllerNames[index];
            Class clsVC = NSClassFromString(vcName);
            UIViewController *vc = [clsVC new];
            
            //            UIViewController *VC = [UIViewController new];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
            label.text = [NSString stringWithFormat:@"%d",index];
            
            [vc.view addSubview:label];
            
            vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
            [_VCarr addObject:vc];
        }
    }
    return _VCarr;
}


#pragma mark - UIPageViewControllerDataSource
// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.VCarr count]) {
        //无限轮播
//        index = 0;
        return nil;
    }
    
    return self.VCarr[index];
}
// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
//    self.direction = @"right";
    
    NSUInteger index = [self indexOfViewController:viewController];
    
    if (index == 0 || index == NSNotFound) {
        //无限轮播
//        index = self.VCarr.count - 1;
        return nil;
    }else{
        
        index--;
    }
    
    
    return self.VCarr[index];
}

#pragma mark - UIPageViewControllerDelegate

// 开始翻页调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
//    NSLog(@"1");
    
    
}

// 翻页完成调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
//    NSLog(@"2");
    
    UIViewController *vc = [pageViewController.viewControllers firstObject];
    NSUInteger index = [self indexOfViewController:vc];
//    NSLog(@">>>>>>>>>>>%ld",index);
    
    if (completed == 1) {
        [self selectBtnWithTag:index + 100];
    }
    
}



#pragma mark - titleView

- (void)titleView{
    UIView *titleView = [UIView new];
    [self.view addSubview:titleView];
    titleView.backgroundColor = [UIColor clearColor];
    
    CGFloat titleViewH = 50;
    titleView.frame = CGRectMake(0, 64, 414, 50);
    self.titleV = titleView;
//    titleView.layer.cornerRadius = titleViewH/2;
//    titleView.layer.masksToBounds = YES;
//    titleView.layer.borderColor = [UIColor blackColor].CGColor;
//    titleView.layer.borderWidth = 0.8f;
    
    NSArray *btnTitle = [NSArray new];
    btnTitle = @[@"待办事项",@"出库单",@"维修单",@"报废单"];
    
    CGFloat btnW = 414/btnTitle.count;
    for (NSInteger index = 0; index < btnTitle.count; index ++) {
        UIButton *btn = [UIButton new];
        [titleView addSubview:btn];
        
        btn.frame = CGRectMake(index * btnW, 0, btnW, 50);
        
        
        btn.layer.cornerRadius = titleViewH/2;
        btn.layer.masksToBounds = YES;
        
        [btn setTitle:btnTitle[index] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor cyanColor] forState:(UIControlStateSelected)];
        [btn setBackgroundImage:[UIImage imageNamed:@"btnslect"] forState:(UIControlStateSelected)];
        //        [btn setBackgroundImage:[UIImage imageNamed:@"btnBack"] forState:(UIControlStateNormal)];
        btn.highlighted = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        btn.tag = index + 100;
        [btn addTarget:self action:@selector(btnActionSC:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (index == 0) {
            btn.selected = YES;
        }
    }
    
}

- (void)btnActionSC:(UIButton *)btn{
    [self selectBtnWithTag:btn.tag];
    NSInteger index = btn.tag - 100;
//        self.index = index;
//    [UIView animateWithDuration:0.25 animations:^{
//        _scr.contentOffset = CGPointMake(index*ANYScreenWidth, 0);
//    }];
    NSArray *vcs = [NSArray arrayWithObjects:self.VCarr[index], nil];
    
    [_pageVC setViewControllers:vcs direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
//    NSLog(@"%@",[self childViewControllers]);
    
}

- (void)selectBtnWithTag:(NSUInteger)tag
{
    for (UIButton *btn in _titleV.subviews) {
        btn.selected = NO;
    }
    UIButton *button = [_titleV viewWithTag:tag];
    button.selected = YES;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

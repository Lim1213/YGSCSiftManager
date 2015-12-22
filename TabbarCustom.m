//
//  TabbarCustom.m
//  YGSCSiftManager
//
//  Created by MASAHIDE HAKUYA on 2015/12/22.
//  Copyright © 2015年 MASAHIDE HAKUYA. All rights reserved.
//

#import "TabbarCustom.h"

@interface TabbarCustom ()

@end

@implementation TabbarCustom

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 非選択時のカラー（テキスト）
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // 選択時のカラー（テキスト）
    NSDictionary *attributesSelected = @{ NSForegroundColorAttributeName : [UIColor blueColor] };
    [[UITabBarItem appearance] setTitleTextAttributes:attributesSelected forState:UIControlStateSelected];
    UITabBarItem *item1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [self.tabBar.items objectAtIndex:2];
    item1.image = [[UIImage imageNamed:@"myshifticon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"groupicon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"newsicon3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

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

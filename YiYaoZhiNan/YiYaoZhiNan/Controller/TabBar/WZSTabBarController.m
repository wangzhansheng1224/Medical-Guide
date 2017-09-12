//
//  WZSTabBarController.m
//  YiYao
//
//  Created by wzs on 16/6/17.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSTabBarController.h"

@interface WZSTabBarController ()

@end

@implementation WZSTabBarController
- (UIViewController *)createChildController:(NSString *)controllerStr title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage{
    Class controllerClass = NSClassFromString(controllerStr);
    UIViewController *controller = [[controllerClass alloc]init];
    controller.tabBarItem = [[UITabBarItem alloc]initWithTitle:title image:[UIImage loadImageByName:normalImage] selectedImage:[UIImage loadImageByName:selectedImage]];
    return [[UINavigationController alloc]initWithRootViewController:controller];
}

+ (void)initialize{
//        [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
//        [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"WZSTabBarItemData" ofType:@"plist"];
    NSArray *items = [[NSArray alloc]initWithContentsOfFile:path];
    for (NSDictionary *dic in items) {
        
        UIViewController *vc = [self createChildController:dic[@"controllerName"] title:dic[@"title"] normalImage:dic[@"normalImageName"] selectedImage:dic[@"selectedImageName"]];
        [self addChildViewController:vc];
    }
    
    // Do any additional setup after loading the view.
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

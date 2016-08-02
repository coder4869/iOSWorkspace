/*
  AppDelegate.m

  Created by coder4869 on 8/1/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ViewController *vc = [[ViewController alloc] init];
    [vc.view setBackgroundColor:[UIColor whiteColor]];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UITabBarController *tabC = [[UITabBarController alloc] init];
    tabC.viewControllers = @[nav, nav, nav];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:tabC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

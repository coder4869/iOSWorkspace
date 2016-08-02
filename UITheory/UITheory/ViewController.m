/*
  ViewController.m

  Created by coder4869 on 8/1/16.
  Copyright © 2016 coder4869. All rights reserved.
*/

#import "ViewController.h"

#import "ViewProperty.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ViewProperty *vp = [[ViewProperty alloc] initWithFrame:CGRectMake(100, 70, 200, 200)];
    [vp demo4FrameBoundsCenter:NO]; //参数为是否隐藏超出边界的子视图
    [self.view addSubview:vp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

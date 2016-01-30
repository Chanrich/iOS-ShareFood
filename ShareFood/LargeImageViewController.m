//
//  LargeImageViewController.m
//  ShareFood
//
//  Created by Richard Chan on 5/7/15.
//  Copyright (c) 2015 Richard Chan. All rights reserved.
//

#import "LargeImageViewController.h"

@interface LargeImageViewController ()

@end

@implementation LargeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.LargeImageView.image = [UIImage imageWithContentsOfFile:self.LargeImagePath];
}
- (IBAction)ButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

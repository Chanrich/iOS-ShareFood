//
//  ImageViewController.m
//  ShareFood
//
//  Created by Richard Chan on 5/5/15.
//  richard.qq.310@gmail.com
//  Copyright (c) 2015 Richard Chan. All rights reserved.
//
#import "AppDelegate.h"
#import "ImageViewController.h"
#import "LargeImageViewController.h"
@import CoreData;

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LargeImage;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImage;
@property (weak, nonatomic) IBOutlet UIImageView *RightImage;
@property NSString *EnlargeImagePath;


@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // self.LargeImage.image = [UIImage imageWithContentsOfFile:self.imagePath];
    self.LargeImage.image = [UIImage imageWithContentsOfFile:self.imagePath];
    self.LeftImage.image = [UIImage imageWithContentsOfFile:self.imagePath2];
    self.RightImage.image = [UIImage imageWithContentsOfFile:self.imagePath3];
}
- (IBAction)FoodImageClicked:(id)sender {
    // Set the shared EnlargeImagePath to Food
    self.EnlargeImagePath = self.imagePath;
}
- (IBAction)ExteriorImageClicked:(id)sender {
    // Set the shared EnlargeImagePath to Exterior
    self.EnlargeImagePath = self.imagePath2;
}
- (IBAction)InteriorImageClicked:(id)sender {
    // Set the shared EnlargeImagePath to Interior
    self.EnlargeImagePath = self.imagePath3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CancelClicked:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)DeleteClicked:(id)sender {
    // Grab the core data delegate method
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appD managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", self.currentName];
    NSArray *deleteArray = [context executeFetchRequest:request error:nil];
    for (NSManagedObject *deleteObject in deleteArray){
        [context deleteObject:deleteObject];
    }
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Error ! %@", error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    LargeImageViewController *dest = segue.destinationViewController;
    if ([dest isKindOfClass:[LargeImageViewController class]]){
        dest.LargeImagePath = self.EnlargeImagePath;
    }
}

@end

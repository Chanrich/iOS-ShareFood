//
//  ViewController.m
//  ShareFood
//
//  Created by Richard Chan on 5/3/15.
//  richard.qq.310@gmail.com
//  Copyright (c) 2015 Richard Chan. All rights reserved.
//

#import "AddNewItemViewController.h"
#import "RestaurantData.h"

@interface AddNewItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *NameField;
@property (weak, nonatomic) IBOutlet UIButton *SmileButton;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (weak, nonatomic) IBOutlet UIButton *BadButton;
@property (weak, nonatomic) IBOutlet UITextField *CommentField;
@property (weak, nonatomic) IBOutlet UIImageView *FoodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *InteriorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ExteriorImageView;

@property RestaurantData *data;

// Rating number: 3 = Good, 2 = Average, 1 = Poor
@property NSNumber* rating;
// lastpicker used to determine which photo taken: 1 = Food, 2 = Interior, 3 = Exterior
@property int lastpicker;
// Declare variables for imagePath
@property NSString *FoodPath;
@property NSString *InteriorPath;
@property NSString *ExteriorPath;
@property int allPhotoTaken;


@end

@implementation AddNewItemViewController
- (IBAction)SaveClicked:(id)sender {
    //Check conditions
    if ([self.rating isEqual:[NSNumber numberWithInt:0]] || self.lastpicker == 0 || [self.NameField.text isEqualToString:@""] || (self.allPhotoTaken == 0) ){
        // No enough info, display error
        NSString *errorMsg;
        //set default msg
        errorMsg = @"Please Enter More Information";
        // Check Individual Parameter
        if (self.allPhotoTaken == 0){
            errorMsg = @"Please Take All Three Photos.";
        }
        if ([self.NameField.text  isEqual: @""]){
            errorMsg = @"Please Enter Name";
        }
        if ([self.rating isEqual:[NSNumber numberWithInt:0]]){
            errorMsg = @"Please give a rating";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More information needed"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //Save All Data into Restaurant Data
        [self.data addData:self.NameField.text Rating:self.rating FoodPath:self.FoodPath InteriorPath:self.InteriorPath ExteriorPath:self.ExteriorPath];
        // Clear out all field
        self.NameField.text = @"";
        self.FoodPath = @"";
        self.ExteriorPath = @"";
        self.InteriorPath = @"";
        self.SmileButton.selected = NO;
        self.OKButton.selected = NO;
        self.BadButton.selected = NO;
        self.rating = [NSNumber numberWithInt:0];
        self.FoodImageView.image = [UIImage imageNamed:@"camara.png"];
        self.ExteriorImageView.image = [UIImage imageNamed:@"camara.png"];
        self.InteriorImageView.image = [UIImage imageNamed:@"camara.png"];
        // Update tableview
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_data" object:self];
        //Switch Tab to TableView
        [self tabBarController:self.tabBarController shouldSelectViewController:[self.tabBarController.viewControllers objectAtIndex:1]];
        //[self.tabBarController setSelectedIndex:1];

    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return false;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.3
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
}

- (IBAction)SmileClicked:(id)sender {
    self.SmileButton.selected = YES;
    self.OKButton.selected = NO;
    self.BadButton.selected = NO;
    self.rating = [NSNumber numberWithInt:3];
    //self.NameField.text = [self.data trynew];
}
- (IBAction)OKButtonClicked:(id)sender {
    self.SmileButton.selected = NO;
    self.OKButton.selected = YES;
    self.BadButton.selected = NO;
    self.rating = [NSNumber numberWithInt:2];
    //self.NameField.text = [self.data getName];
}
- (IBAction)BadButtonClick:(id)sender {
    self.SmileButton.selected = NO;
    self.OKButton.selected = NO;
    self.BadButton.selected = YES;
    self.rating = [NSNumber numberWithInt:1];
    //self.NameField.text = [self.data trynew2];
}
- (IBAction)FoodClicked:(id)sender {
    //Check if name field is empty
    if ([self.NameField.text  isEqual: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Name"
                                                        message:@"Please Enter Restaurant Name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.lastpicker = 1; // Set lastpicker to be recognizable by delegate function
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}
- (IBAction)InteriorClicked:(id)sender {
     //Check if name field is empty
    if ([self.NameField.text  isEqual: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Name"
                                                        message:@"Please Enter Restaurant Name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.lastpicker = 2; // Set lastpicker to be recognizable by delegate function
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}
- (IBAction)ExteriorClicked:(id)sender {
     //Check if name field is empty
    if ([self.NameField.text  isEqual: @""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Name"
                                                        message:@"Please Enter Restaurant Name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.lastpicker = 3; // Set lastpicker to be recognizable by delegate function
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //Get selected Image
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    //Save the image into local directory
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    NSString *fileName;
    NSString *fullpath;
    // Save into NSData for writing to disk
    NSData *imageData = UIImagePNGRepresentation(pickedImage);
    switch (self.lastpicker) {
        case 1:
            // Food Picture taken
            fileName = [NSString stringWithFormat:@"%@_Food.png", self.NameField.text];
            fullpath = [docPath stringByAppendingPathComponent:fileName];
            self.FoodPath = fileName;
            self.FoodImageView.image = pickedImage;
            //NSLog(@"PAth:%@", self.FoodPath);
            [imageData writeToFile:fullpath atomically:NO];
            break;
        case 2:
            // Interior Picture Taken
            fileName = [NSString stringWithFormat:@"%@_Interior.png", self.NameField.text];
            fullpath = [docPath stringByAppendingPathComponent:fileName];
            self.InteriorPath = fileName;
            self.InteriorImageView.image = pickedImage;
            //NSLog(@"PAth:%@", self.InteriorPath);
            [imageData writeToFile:fullpath atomically:NO];
            break;
        case 3:
            // Exterior Picture Taken
            fileName = [NSString stringWithFormat:@"%@_Exerior.png",self.NameField.text];
            fullpath = [docPath stringByAppendingPathComponent:fileName];
            self.ExteriorPath = fileName;
            //NSLog(@"PAth:%@", self.ExteriorPath);
            self.ExteriorImageView.image = pickedImage;
            [imageData writeToFile:fullpath atomically:NO];
            break;
            
        case 0:
            break;
    }
    
    // Check if all photo is taken
    if (![self.ExteriorPath  isEqual:@""] && ![self.InteriorPath isEqual:@""] && ![self.FoodPath isEqual:@""]){
        // All Taken
        self.allPhotoTaken = 1;
    } else {
        // Not all taken
        self.allPhotoTaken = 0;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];


}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize all the data
    self.data = [[RestaurantData alloc] init];
    self.NameField.delegate = self;
    self.NameField.text = @"";
    self.FoodPath = @"";
    self.ExteriorPath = @"";
    self.InteriorPath = @"";
    self.CommentField.delegate = self;
    self.rating = [NSNumber numberWithInt:0];
    self.lastpicker = 0;
    self.tabBarController.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

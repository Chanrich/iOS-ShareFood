//
//  EntryTableViewController.m
//  ShareFood
//
//  Created by Richard Chan on 5/4/15.
//  richard.qq.310@gmail.com
//  Copyright (c) 2015 Richard Chan. All rights reserved.
//
#import "AppDelegate.h"
#import "ImageViewController.h"
#import "EntryTableViewController.h"
@import CoreData;

@interface EntryTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property NSArray *path;
@property NSString *docPath;
@property AppDelegate *appD;
@end

@implementation EntryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"List";
    // Grab the core data delegate method
    self.appD = [[UIApplication sharedApplication] delegate];
    self.context = [self.appD managedObjectContext];
    // Get the current document directory
    self.path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.docPath = [self.path objectAtIndex:0];
    // Set the update method
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handle_data) name:@"reload_data" object:nil];
    
    NSError *error;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:self.context];
    [request setEntity:entity];
    self.dataArray = [[self.appD managedObjectContext] executeFetchRequest:request error:&error];
}

// Method to update the core data entries

- (void) handle_data {
    // Update core data
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:self.context];
    NSError *error;
    [request setEntity:entity];
    self.dataArray = [[self.appD managedObjectContext] executeFetchRequest:request error:&error];
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    // Image Processing
    NSString *imagePath = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"foodPath"];
    //NSLog(@"Cell Image Path: %@", imagePath);
    NSString *fullPath = [self.docPath stringByAppendingPathComponent:imagePath];
    cell.imageView.image = [UIImage imageWithContentsOfFile:fullPath];
    // Rating Processing
    NSString *ratingString;
    NSNumber *rating = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"rating"];
    switch ([rating integerValue]){
        case 1:
            // Not Good
            ratingString = @"Bad";
            cell.detailTextLabel.textColor = [UIColor redColor];
            break;
        case 2:
            // Average
            ratingString = @"Average";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            break;
        case 3:
            // Good
            ratingString = @"Good";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            break;
            
    }
    cell.detailTextLabel.text = ratingString;
    return cell;

}

/*

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *foodImagePath = [[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"foodPath"];
    ImageViewController *ImageViewC = [[ImageViewController alloc] init];
    NSString *fullPath = [self.docPath stringByAppendingPathComponent:foodImagePath];
    NSLog(@"Displaying image:%@",fullPath);
    ImageViewC.imagePath = fullPath;
    ImageViewC.LargeImage.image = [UIImage imageWithContentsOfFile:fullPath];
    [self.navigationController pushViewController:ImageViewC animated:YES];
}
 
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    ImageViewController *destController = segue.destinationViewController;
    // Pass the selected object to the new view controller.
    if ([destController isKindOfClass:[ImageViewController class]]){
        NSIndexPath *DestIndexPath = [self.tableView indexPathForSelectedRow];
        NSString *foodImagePath = [[self.dataArray objectAtIndex:DestIndexPath.row] valueForKey:@"foodPath"];
        NSString *exteriorImagePath = [[self.dataArray objectAtIndex:DestIndexPath.row] valueForKey:@"exteriorPath"];
        NSString *interiorImagePath = [[self.dataArray objectAtIndex:DestIndexPath.row] valueForKey:@"interiorPath"];
        NSString *fullPath = [self.docPath stringByAppendingPathComponent:foodImagePath];
        destController.imagePath = fullPath;
        fullPath = [self.docPath stringByAppendingPathComponent:exteriorImagePath];
        destController.imagePath2 = fullPath;
        fullPath = [self.docPath stringByAppendingPathComponent:interiorImagePath];
        destController.imagePath3 = fullPath;
        destController.currentName = [[self.dataArray objectAtIndex:DestIndexPath.row] valueForKey:@"name"];
    }
}



@end

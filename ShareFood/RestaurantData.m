//
//  RestaurantData.m
//  ShareFood
//
//  Created by Richard Chan on 5/4/15.
//  richard.qq.310@gmail.com
//  Copyright (c) 2015 Richard Chan. All rights reserved.
//
@import CoreData;
#import "AppDelegate.h"
#import "RestaurantData.h"

@interface RestaurantData()
@property (nonatomic,strong) NSManagedObjectContext* ManagedContext;
@property int i;
@end

@implementation RestaurantData

- (void)addData:(NSString*)Name Rating:(NSNumber*)Rating FoodPath:(NSString*)FoodPath InteriorPath:(NSString*)InteriorPath ExteriorPath:(NSString*)ExteriorPath {
    //Add one entry of data into core data
    // Get ManagedObjectContext from appDelegate
    AppDelegate* appD = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appD managedObjectContext];
    //Define new data for restaurant's info
    NSManagedObject *newDetail;
    newDetail = [NSEntityDescription insertNewObjectForEntityForName:@"Info" inManagedObjectContext:context];
    [newDetail setValue:Name forKey:@"name"];
    [newDetail setValue:FoodPath forKey:@"foodPath"];
    [newDetail setValue:InteriorPath forKey:@"interiorPath"];
    [newDetail setValue:ExteriorPath forKey:@"exteriorPath"];
    [newDetail setValue:Rating forKey:@"rating"];
    //Save
    NSError *error;
    [context save:&error];
}


@end

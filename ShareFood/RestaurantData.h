//
//  RestaurantData.h
//  ShareFood
//
//  Created by Richard Chan on 5/4/15.
//  richard.qq.310@gmail.com
//  Copyright (c) 2015 Richard Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantData : NSObject

- (void)addData:(NSString*)Name Rating:(NSNumber*)Rating FoodPath:(NSString*)FoodPath InteriorPath:(NSString*)InteriorPath ExteriorPath:(NSString*)ExteriorPath;
@end

//
//  TestModel.m
//  Data
//
//  Created by mac  on 13-3-4.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
@synthesize Bid;
@synthesize StoreName;
@synthesize Longitude;
@synthesize Latitude;


-(void)dealloc {
    self.Bid = nil;
    self.StoreName = nil;
    self.Latitude = nil;
    self.Longitude = nil;
    NSLog(@"TestModel dealloc");
    [super dealloc];
}
@end


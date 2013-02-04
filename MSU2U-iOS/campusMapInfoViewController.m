//
//  campusMapInfoViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/3/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapInfoViewController.h"

@interface campusMapInfoViewController ()

@end

@implementation campusMapInfoViewController

- (IBAction)callLocation:(UIButton *)sender {
}

-(void)sendLocationName:(NSString*)receivedLocationName
{
    self.locationName.text = receivedLocationName;
}

@end

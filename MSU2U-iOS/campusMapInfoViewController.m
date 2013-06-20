//
//  campusMapInfoViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/3/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapInfoViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface campusMapInfoViewController ()

@end

@implementation campusMapInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.buildingImage setImageWithURL:[NSURL URLWithString:buildingImageURL] placeholderImage:[UIImage imageNamed:@"Unknown.jpg"] options:0];
    self.buildingInfoTextView.text = buildingInfo;
}

-(void)sendBuildingName:(NSString*)receivedBuildingName andInfo:(NSString*)receivedBuildingInfo andImage:(NSString*)receivedBuildingImage
{
    self.title = receivedBuildingName;
    buildingInfo = receivedBuildingInfo;
    buildingImageURL = receivedBuildingImage;
}

@end

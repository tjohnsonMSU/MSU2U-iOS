//
//  campusMapInfoViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/3/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface campusMapInfoViewController : UITableViewController{
    NSString * buildingImageURL;
    NSString * buildingInfo;
}
@property (strong, nonatomic) IBOutlet UIImageView *buildingImage;

@property (strong, nonatomic) IBOutlet UITextView *buildingInfoTextView;
-(void)sendBuildingName:(NSString*)receivedBuildingName andInfo:(NSString*)receivedBuildingInfo andImage:(NSString*)receivedBuildingImage;
@end

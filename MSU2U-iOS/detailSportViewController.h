//
//  detailSportViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "campusMapViewController.h"
#import "Sport+Create.h"
#import "addEventToCalendar.h"
//ShareKit
#import "SHK.h"


@interface detailSportViewController : addEventToCalendar{
    UIBarButtonItem * rightButton;
}

//Properties
@property (strong, nonatomic) IBOutlet UIImageView *bannerImage;
@property (strong, nonatomic) IBOutlet UIImageView *homeLogo;
@property (strong, nonatomic) IBOutlet UIImageView *awayLogo;
@property (strong, nonatomic) IBOutlet UILabel *homeUniversityName;
@property (strong, nonatomic) IBOutlet UILabel *awayUniversityName;
@property (strong, nonatomic) IBOutlet UILabel *displayedStartTime;
@property (strong, nonatomic) IBOutlet UILabel *displayedStartDate;
@property (strong, nonatomic) IBOutlet UILabel *displayedLocation;
- (IBAction)sharePressed:(UIBarButtonItem *)sender;

//Public Methods
-(void)sendSportInformation:(Sport*)sportInfo;

@end

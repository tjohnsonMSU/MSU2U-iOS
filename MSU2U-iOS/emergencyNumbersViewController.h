//
//  emergencyNumbersViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/24/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface emergencyNumbersViewController : UITableViewController <CLLocationManagerDelegate>{
    NSArray * emergencyNumber;
    int chosenRow, chosenSection;
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UILabel *myCoordinate;
@property (weak, nonatomic) IBOutlet UILabel *myAddress;

@end

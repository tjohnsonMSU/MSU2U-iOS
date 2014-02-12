//
//  campusMapSettingsViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/31/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "campusMapViewController.h"

@interface campusMapSettingsViewController : UITableViewController <UIAlertViewDelegate>{
    NSUserDefaults * defaults;
}

//@property (weak, nonatomic) IBOutlet UISwitch *busTransitRouteSwitch;
@property (strong, nonatomic) IBOutlet UITableViewCell *parkingOverlayPressed;
@property (strong, nonatomic) IBOutlet UITableViewCell *campusBorderPressed;

-(void) sendMapview:(MKMapView*)mv;

//- (IBAction)busTransitRouteFlipped:(UISwitch *)sender;
@end

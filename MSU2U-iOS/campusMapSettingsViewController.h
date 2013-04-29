//
//  campusMapSettingsViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/31/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface campusMapSettingsViewController : UITableViewController{
    NSUserDefaults * defaults;
}
@property (weak, nonatomic) IBOutlet UISwitch *parkingZoneSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *campusBorderSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *busTransitRouteSwitch;

- (IBAction)parkingZoneFlipped:(id)sender;
- (IBAction)campusBorderFlipped:(UISwitch *)sender;
//- (IBAction)busTransitRouteFlipped:(UISwitch *)sender;
@end

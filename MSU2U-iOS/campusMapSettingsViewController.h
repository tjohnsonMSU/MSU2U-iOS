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

- (IBAction)parkingZoneFlipped:(UISwitch *)sender;
- (IBAction)campusBorderFlipped:(UISwitch *)sender;
@end

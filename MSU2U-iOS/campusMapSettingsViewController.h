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

//@property (weak, nonatomic) IBOutlet UISwitch *busTransitRouteSwitch;
@property (strong, nonatomic) IBOutlet UITableViewCell *parkingOverlayPressed;
@property (strong, nonatomic) IBOutlet UITableViewCell *campusBorderPressed;


//- (IBAction)busTransitRouteFlipped:(UISwitch *)sender;
@end

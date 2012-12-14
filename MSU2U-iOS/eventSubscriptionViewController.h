//
//  eventSubscriptionViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "subscriptionsViewController.h"

@interface eventSubscriptionViewController : subscriptionsViewController{
    UIBarButtonItem * rightButton;
    BOOL allSwitchesAreOn;
}

@property (strong, nonatomic) IBOutlet UISwitch *academicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *artSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *campusSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *museumSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *musicSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *personnelSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *theaterSwitch;

- (IBAction)academicFlipped:(UISwitch *)sender;
- (IBAction)artFlipped:(UISwitch *)sender;
- (IBAction)campusFlipped:(UISwitch *)sender;
- (IBAction)museumFlipped:(UISwitch *)sender;
- (IBAction)musicFlipped:(UISwitch *)sender;
- (IBAction)personnelFlipped:(UISwitch *)sender;
- (IBAction)theaterFlipped:(UISwitch *)sender;

@end

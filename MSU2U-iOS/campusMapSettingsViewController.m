//
//  campusMapSettingsViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/31/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapSettingsViewController.h"

@interface campusMapSettingsViewController ()
//A copy of the campus map view so I can alter the map from settings
@property (nonatomic, weak) MKMapView * mv;
@property (nonatomic, weak) NSDictionary * addressLookup;
@property (nonatomic, weak) NSDictionary * buildingName;
@property (nonatomic, weak) NSDictionary * coordinateLookup;
@end

@implementation campusMapSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@\n",[defaults valueForKey:@"campusMapSettingsMapRowChecked"]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return NO;
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return NO;
    else if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else
        return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    //Set up the settings options as they are in the user defaults
    if([[defaults valueForKey:@"campusMapSettingsMapRowChecked"] isEqualToString:@"Satellite Only"])
    {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"I'm trying to make 'satellite only' checked, but I guess I'm failing at that.\n");
    }
    else if([[defaults valueForKey:@"campusMapSettingsMapRowChecked"] isEqualToString:@"Roads Only"])
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]].accessoryType = UITableViewCellAccessoryCheckmark;
    else
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].accessoryType = UITableViewCellAccessoryCheckmark;
    
    if([defaults boolForKey:@"campusMapSettingsParkingLot"])
    {
        //turn on that switch
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([defaults boolForKey:@"campusMapSettingsCampusBorder"])
    {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([defaults boolForKey:@"campusMapSettingsShowAllBuildings"])
    {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    /*TODO IMPLEMENT A BETTER BUS ROUTE LATER
    if([defaults boolForKey:@"campusMapSettingsBusRoute"])
    {
        [self.busTransitRouteSwitch setOn:TRUE];
    }
    */
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                //hybrid
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Hybrid" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            case 1:
            {
                //satellite only
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Satellite Only" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            case 2:
            {
                //roads only
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setValue:@"Roads Only" forKey:@"campusMapSettingsMapRowChecked"];
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                break;
            }
            default:
                break;
        }
    }
    else if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //Parking Overlays
            if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [defaults setBool:NO forKey:@"campusMapSettingsParkingLot"];
            }
            else
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setBool:YES forKey:@"campusMapSettingsParkingLot"];
            }
        }
        else if(indexPath.row == 1)
        {
            //Campus Border
            if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                [defaults setBool:NO forKey:@"campusMapSettingsCampusBorder"];
            }
            else
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [defaults setBool:YES forKey:@"campusMapSettingsCampusBorder"];
            }
        }
    }
    else if(indexPath.section == 2){

        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

        if(indexPath.row == 0){
            //Remove all pins
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Remove All Pins" message:@"Are you sure you want to remove all pins?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, remove all pins",nil];
            [av show];
            av.tag = 0;
        }else if(indexPath.row == 1){
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Add All Buildings" message:@"Pins for every building have now been placed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [av show];
            av.tag = 1;

            //The defaults flag will let the campusMapView controller know it should drop pins for all buildings in viewDidAppear
            [defaults setBool:YES forKey:@"campusMapSettingsAddAllPins"];
        }
    }

    [defaults synchronize];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 0){
        //Remove All Pins
        if(buttonIndex == 1){
            //OK, actually remove all pins.
            [self.mv removeAnnotations:[self.mv annotations]];
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Success" message:@"All pins have been successfully removed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];

            if([defaults boolForKey:@"campusMapSettingsAddAllPins"])
            {
                //If the user removes all pins AFTER having pressed "Show All Buildings", I will disable the addition of all the building pins, essentially cancelling "Show All Buildings"
                [defaults setBool:NO forKey:@"campusMapSettingsAddAllPins"];
            }
        }
    }
}

-(void) sendMapview:(MKMapView*)mv {
    //Record a copy of the campus map
    self.mv = mv;
}

@end

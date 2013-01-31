//
//  emergencyNumbersViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/24/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "emergencyNumbersViewController.h"

@interface emergencyNumbersViewController ()
@end

@implementation emergencyNumbersViewController

-(void)viewDidLoad
{
    emergencyNumber = [[NSArray alloc] initWithObjects:@"5806953489",@"940-397-4239", nil];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    chosenRow = indexPath.row;
    chosenSection = indexPath.section;
    if(indexPath.section == 0)
    {
        //Make sure the user chose a phone number as opposed to the "More Contacts" option. Let the storyboard handle the choosing of "More Contacts", not this code.
        if(indexPath.row == 0 || indexPath.row == 1)
        {
            NSLog(@"emergency Number: A phone number was touched...try to make call\n");
            [self makePhoneCall:[emergencyNumber objectAtIndex:indexPath.row]];
        }
        else
        {
            NSLog(@"emergency Number: A phone number was NOT touched because the indexPath.row is %i\n",indexPath.row);
        }
    }
    else
    {
        //User wants to view a webpage
        [self performSegueWithIdentifier:@"toWebView" sender:tableView];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * stringURL;
    if(chosenSection == 1)
    {
        switch(chosenRow)
        {
            case 0:stringURL = @"http://police.mwsu.edu/crimelogs/crimelog_list.asp?a=showall&value=1&LL=497";break;
            case 1:stringURL = @"http://police.mwsu.edu/pdf/Clery-Stats-2011.pdf";break;
        }
    }
    else if(chosenSection == 2)
    {
        switch(chosenRow)
        {
            case 0:stringURL = @"http://webforms.mwsu.edu/TakeSurvey.aspx?SurveyID=m2LJ452&LL=501"; break;
            case 1:stringURL = @"http://webforms.mwsu.edu/TakeSurvey.aspx?SurveyID=m21M352&LL=503"; break;
        }
    }
    if(chosenSection != 0)
    {
        [segue.destinationViewController sendWebsiteToVisit:stringURL andTitle:@"MSU Link"];
    }
}

-(void)makePhoneCall:(NSString*)phoneNumber
{
    //Remove all unwanted characters from phone number
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    //Prepare to make the call. Once call is completed, the screen will return to the app.
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]]];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:0];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    
    self.myCoordinate.text = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
}

@end

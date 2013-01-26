//
//  moreEmergencyContactsTableViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/24/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "moreEmergencyContactsTableViewController.h"

@interface moreEmergencyContactsTableViewController ()

@end

@implementation moreEmergencyContactsTableViewController

-(void)viewDidLoad
{
    fireAndPoliceNumber = [[NSArray alloc] initWithObjects:@"(940)397-4239",@"940-761-7901",@"940-761-7600",@"940-766-8276",nil];
    publicSafetyNumber = [[NSArray alloc] initWithObjects:@"940-692-1993",@"1-800-273-8255",@"1-800-252-5400",@"940-692-1993",@"940-761-7842",@"1-800-222-1222", nil];
    hospitalNumber = [[NSArray alloc] initWithObjects:@"940-322-1911",@"940-764-7000",@"940-763-7990",@"940-692-5888",@"940-692-1220", nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        //I'm in section 1
        NSLog(@"I'm in section 1, and I pressed row %i\n",indexPath.row);
        [self makePhoneCall:[fireAndPoliceNumber objectAtIndex:indexPath.row]];
    }
    else if(indexPath.section == 2)
        [self makePhoneCall:[hospitalNumber objectAtIndex:indexPath.row]];
    else if(indexPath.section == 3)
        [self makePhoneCall:[publicSafetyNumber objectAtIndex:indexPath.row]];
}

-(void)makePhoneCall:(NSString*)phoneNumber
{
    //Remove all unwanted characters from phone number
    NSString *cleanedString = [[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    //Prepare to make the call. Once call is completed, the screen will return to the app.
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", cleanedString]]];
}
@end

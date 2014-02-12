//
//  devV1ViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 5/2/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "devV1ViewController.h"

@interface devV1ViewController ()

@end

@implementation devV1ViewController


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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
            //developers
        case 0:
            switch (indexPath.row) {
                case 0:
                    //Eric Binnion
                    webLink = @"http://www.linkedin.com/profile/view?id=52202642&authType=NAME_SEARCH&authToken=OiQ7&locale=en_US&srchid=0b39f104-dbde-4dcc-85b9-db59d7c18b40-0&srchindex=1&srchtotal=1&goback=%2Efps_PBCK_eric+binnion_*1_*1_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1_*51_*1_*51_true_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2&pvs=ps&trk=pp_profile_name_link";
                    name = @"Eric Binnion";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 1:
                    //Muminur Rahman
                    webLink = @"http://www.linkedin.com/profile/view?id=236691897&locale=en_US&trk=tyah";
                    name = @"Muminur Rahman";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 2:
                    //Chase Sawyer
                    webLink = @"";
                    name = @"Chase Sawyer";
                    //[self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 3:
                    //Shawn Seals
                    webLink = @"";
                    name = @"Shawn Seals";
                    //[self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                    
                default:
                    break;
            }
            break;
            //faculty sponsors
        case 1:
            switch (indexPath.row) {
                case 0:
                    //Dr. Terry Griffin
                    webLink = @"http://www.linkedin.com/profile/view?id=72781229&authType=NAME_SEARCH&authToken=pLO2&locale=en_US&srchid=95f70f27-dd0b-4045-aff4-2345331816af-0&srchindex=1&srchtotal=457&goback=%2Efps_PBCK_terry+griffin_*1_*1_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1_*51_*1_*51_true_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2&pvs=ps&trk=pp_profile_name_link";
                    name = @"Dr. Terry Griffin";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 1:
                    //Dr. Tina Johnson
                    webLink = @"http://www.linkedin.com/profile/view?id=84631128&authType=NAME_SEARCH&authToken=AcQh&locale=en_US&srchid=b83f5275-115b-4863-8484-e6be1447c0bb-0&srchindex=1&srchtotal=3501&goback=%2Efps_PBCK_tina+johnson_*1_*1_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1_*51_*1_*51_true_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2&pvs=ps&trk=pp_profile_name_link";
                    name = @"Dr. Tina Johnson";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController sendURL:webLink andTitle:name andMessagePrefix:name];
}


@end

//
//  devV2ViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 5/2/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "devV2ViewController.h"

@interface devV2ViewController ()

@end

@implementation devV2ViewController

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
                    //matthew farmer
                    webLink = @"http://www.linkedin.com/profile/view?id=223627443&trk=tab_pro";
                    name = @"Matthew Farmer";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 1:
                    //robin goodefellowe
                    webLink = @"http://www.linkedin.com/profile/view?id=66591072&locale=en_US&trk=tyah";
                    name = @"Robin Goodfellowe";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 2:
                    //simba musarurwa
                    webLink = @"http://www.linkedin.com/profile/view?id=234180320&locale=en_US&trk=tyah";
                    name = @"Simba Musarurwa";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 3:
                    //Muminur Rahman
                    webLink = @"http://www.linkedin.com/profile/view?id=236691897&locale=en_US&trk=tyah";
                    name = @"Muminur Rahman";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 4:
                    //Kerde Severin
                    webLink = @"http://www.linkedin.com/profile/view?id=225844737&locale=en_US&trk=tyah2";
                    name = @"Kerde Severin";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 5:
                    //Terrance Smith
                    webLink = @"http://www.linkedin.com/profile/view?id=160262859&authType=name&authToken=DwBk&offset=0&ref=PYMK&trk=prof-sb-pdm-pymk-name";
                    name = @"Terrance Smith";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                    
                default:
                    break;
            }
            break;
            //contributors
        case 1:
            switch (indexPath.row) {
                case 0:
                    //matthew steimel
                    webLink = @"http://www.linkedin.com/profile/view?id=228821234&authType=NAME_SEARCH&authToken=HdK-&locale=en_US&srchid=b0436a7b-2989-4f98-9ab3-76cc4fb8cd94-0&srchindex=1&srchtotal=4&goback=%2Efps_PBCK_Matthew+Steimel_*1_*1_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1_*51_*1_*51_true_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2&pvs=ps&trk=pp_profile_name_link";
                    name = @"Matthew Steimel";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 1:
                    //kistel hazel
                    webLink = @"";
                    name = @"Kistel Hazel";
                    //[self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 2:
                    //danya bynoe
                    name = @"Danya Bynoe";
                    break;
                    
                default:
                    break;
            }
            break;
            //faculty sponsors
        case 2:
            switch (indexPath.row) {
                case 0:
                    //Dr. Terry Griffin
                    webLink = @"http://www.linkedin.com/profile/view?id=72781229&authType=NAME_SEARCH&authToken=pLO2&locale=en_US&srchid=416cbd35-9674-414d-979b-154ee4285bff-0&srchindex=1&srchtotal=457&goback=%2Efps_PBCK_terry+griffin_*1_*1_*1_*1_*1_*1_*2_*1_Y_*1_*1_*1_false_1_R_*1_*51_*1_*51_true_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2_*2&pvs=ps&trk=pp_profile_name_link";
                    name = @"Dr. Terry Griffin";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 1:
                    //Dr. Tina Johnson
                    webLink = @"http://www.linkedin.com/profile/view?id=84631128&authType=name&authToken=nkuU&offset=1&ref=PYMK&trk=prof-sb-pdm-pymk-photo";
                    name = @"Dr. Tina Johnson";
                    [self performSegueWithIdentifier:@"toWebView" sender:tableView];
                    break;
                case 2:
                    //Shawn Seals
                    name = @"Shawn Seals";
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

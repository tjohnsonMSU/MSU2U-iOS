//
//  mediaMenuViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/15/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "mediaMenuViewController.h"

@interface mediaMenuViewController ()

@end

@implementation mediaMenuViewController

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //chosenRow/section are private variables I can use with a scope that can be used in any function I desire. It is needed in the prepareForSegue method since that method does not have access to indexPath.row or indexPath.section
    chosenRow = indexPath.row;
    chosenSection = indexPath.section;
    
    //Assume I'm going to the toWebView unless I get caught in the if/else/switch below
    NSString * mySegueIdentifier = @"toWebView";

    //Print Media
    if(chosenSection == 1)
    {
        switch(chosenRow)
        {
            //Voices
            case 0:mySegueIdentifier = @"toVoicesMenu"; break;
            default:break;
        }
    }
    
    [self performSegueWithIdentifier:mySegueIdentifier sender:tableView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * stringURL = nil;
    
    //Social Media
    if(chosenSection != 1 && chosenRow != 0)
    {
        if(chosenSection == 0)
        {
            switch(chosenRow)
            {
                    //Facebook
                case 0:stringURL = @"https://www.facebook.com/MidwesternState?rf=108025715893156"; break;
                    //Twitter
                case 1:stringURL = @"https://twitter.com/MidwesternState"; break;
                default:break;
            }
        }
        //Print Media
        else if(chosenSection == 1)
        {
            switch(chosenRow)
            {
                    //Voices
                case 0:break;
                    //Student Handbook
                case 1:stringURL = @"http://students.mwsu.edu/studentaffairs/pdf/studenthandbook2012_13.pdf"; break;
                default:break;
            }
        }
        //Images and Music
        else if(chosenSection == 2)
        {
            switch(chosenRow)
            {
                    //Campus Gallery
                case 0:stringURL = @"http://www.flickr.com/search/show/?q=Midwestern+State"; break;
                    //Fight Song
                case 1:stringURL = @"http://www.youtube.com/watch?v=XeIKnBDN4To"; break;
                default:break;
            }
        }
        //Links
        else if(chosenSection == 3)
        {
            switch(chosenRow)
            {
                    //MSU Home Page
                case 0:stringURL = @"http://www.mwsu.edu/"; break;
                    //Mustangs Sports
                case 1:stringURL = @"http://www.msumustangs.com/mobile"; break;
                    //Webmail
                case 2:stringURL = @"http://infosys.mwsu.edu/email/"; break;
                default:break;
            }
        }
        //Error
        else
        {
            NSLog(@"!!! Unexpected section number of %i in Media Menu View Controller...\n",chosenSection);
        }
        [segue.destinationViewController sendWebsiteToVisit:stringURL andTitle:@"MSU Link"];
    }
}

@end

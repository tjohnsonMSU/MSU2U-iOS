//
//  twitterViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "twitterViewController.h"

@interface twitterViewController ()

@end

@implementation twitterViewController

@synthesize searchBar = _searchBar;
@synthesize searchDisplayControl = _searchDisplayControl;

-(void)viewDidLoad
{
    //self.jsonURL = @"CHANGE ME";
    self.twitterProfilesAndHashtags = [[NSArray alloc]initWithObjects:@"MidwesternState",@"MSUMustangs",@"matthewfarm",@"MWSUCampusWatch",@"MidwesternAVP",@"msu2u_devteam",@"WichitanOnline",@"MSUUnivDev",@"MSU_VP",@"mwsu_sg",@"#SocialStampede",@"#MidwesternState",@"#msu2u",@"#msumustangs",@"MSUCyclingTeam",@"msuchiomega", nil];
    
    self.entityName = @"Tweet";
    self.sortDescriptorKey = @"created_at";
    self.cellIdentifier = @"tweetCell";
    self.segueIdentifier = @"toTweet";
    
    //self.keyToSearchOn = @"title";
    self.keysToSearchOn = [[NSMutableArray alloc]initWithObjects:@"text",@"screen_name", nil];
    
    self.childNumber = [NSNumber numberWithInt:7];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.searchDisplayControl setActive:NO];
}

- (IBAction)tweet:(UIButton *)sender {
    NSLog(@"Tweet tweet said the bird!\n");
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"#SocialStampede "];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops! Could not compose tweet"
                                  message:@"Please check that you have internet access and that you have a Twitter account setup in your device's Settings > Twitter menu and try again."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
@end

//
//  detailSportViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailSportViewController.h"

@interface detailSportViewController ()
@property (weak, nonatomic) NSString* receivedTitle;
@property (weak, nonatomic) NSString* receivedStartTime;
@property (weak, nonatomic) NSString* receivedDescription;
@property (weak, nonatomic) NSString* receivedLink;
@property (weak, nonatomic) NSString* receivedEvgameid;
@property (weak, nonatomic) NSString* receivedEvlocation;
@property (weak, nonatomic) NSString* receivedStartDate;
@property (weak, nonatomic) NSString* receivedEndDate;
@property (weak, nonatomic) NSString* receivedSteamLogo;
@property (weak, nonatomic) NSString* receivedSopponentLogo;
@property (weak, nonatomic) NSString* receivedHomeTeam;
@property (weak, nonatomic) NSString* receivedAwayTeam;
@end

@implementation detailSportViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                   style:UIBarButtonSystemItemDone target:self action:@selector(shareEvent)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void) shareEvent
{
    //Write the code to add the event to the iPhone's calendar
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    eventStore = [[EKEventStore alloc] init];
    
    //Set the Title of your View
    self.title = self.receivedStartDate;
    
    //Setup all the images
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
    
    //Set the table labels up based upon the received information
    self.displayedLocation.text = self.receivedEvlocation;
    self.displayedStartDate.text = self.receivedStartDate;
    self.displayedStartTime.text = self.receivedStartTime;
    self.homeUniversityName.text = self.receivedHomeTeam;
    self.awayUniversityName.text = self.receivedAwayTeam;
}

-(void)sendSportInformation:(Sport *)sportInfo
{
    self.receivedStartTime = sportInfo.startTime;
    self.receivedTitle = sportInfo.title;
    self.receivedDescription = sportInfo.content;
    self.receivedLink = sportInfo.link;
    self.receivedEvgameid = sportInfo.evgameid;
    self.receivedEvlocation = sportInfo.evlocation;
    self.receivedStartDate = sportInfo.startDate;
    self.receivedEndDate = sportInfo.endDate;
    self.receivedSteamLogo = sportInfo.steamlogo;
    self.receivedSopponentLogo = sportInfo.sopponentlogo;
    self.receivedHomeTeam = sportInfo.homeTeam;
    self.receivedAwayTeam = sportInfo.awayTeam;
    
    //For my table content, make sure the received information is not null or blank. If so, set it to N/A so my table view won't crash.
    if([self.receivedTitle length] == 0) self.receivedTitle = @"N/A";
    if([self.receivedStartDate length] == 0) self.receivedStartDate = @"N/A";
    if([self.receivedStartTime length] == 0) self.receivedStartTime = @"N/A";
    if([self.receivedEvlocation length] == 0) self.receivedEvlocation = @"N/A";
    
    //Send the addEventToCalendar class your information so that it will know how to add this event to the calendar if necessary
    self.title = self.receivedDescription;
    self.startTime = self.receivedStartTime;
    self.startDate = self.receivedStartDate;
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender {
}

-(void)downloadImage
{
    NSLog(@"I received %@ (home) and %@ (away) as my logo links!\n",self.receivedSteamLogo,self.receivedSopponentLogo);
    self.receivedSteamLogo = [self.receivedSteamLogo stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.receivedSopponentLogo = [self.receivedSopponentLogo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.homeLogo setImageWithURL:[NSURL URLWithString:self.receivedSteamLogo]
               placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self.awayLogo setImageWithURL:[NSURL URLWithString:self.receivedSopponentLogo]
                   placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//TABLE METHODS

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Did the Add Event to Calendar cell get selected?
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            //This is iOS 6.0 and above, so I have to ask the user for permission to access their calendar before adding the event!
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                [self performSelectorOnMainThread:@selector(addEventToMainCalendar) withObject:nil waitUntilDone:YES];
            }];
        }
        else
        {
            //This is iOS 5.0 and below, so I don't need to ask the user for permission first to access their calendar(s).
            [self addEventToMainCalendar];
        }
    }
}

@end
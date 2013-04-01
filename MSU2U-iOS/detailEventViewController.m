//
//  detailEventViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailEventViewController.h"

@interface detailEventViewController ()
@end

@implementation detailEventViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup the text in the navigation bar
    self.title = receivedEvent.category;
    
    if([receivedEvent.category isEqualToString:@"Men's Basketball"])
    {
        self.backgroundPhoto.image = [UIImage imageNamed:@"menbasketballBG.jpg"];
    }
    
    //Set your labels
    self.titleLabel.text = receivedEvent.title;
    self.locationLabel.text = receivedEvent.location;
    NSLog(@"The date is %@\n",receivedEvent.startdate);
    self.startingDateLabel.text = [NSDateFormatter localizedStringFromDate:receivedEvent.startdate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    //Setup the images
    if([receivedEvent.isHomeGame isEqualToString:@"yes"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self downloadImageForHome:receivedEvent.teamlogo andAway:receivedEvent.opponentlogo];
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self downloadImageForHome:receivedEvent.opponentlogo andAway:receivedEvent.teamlogo];
        });
    }
}

-(void)sendEventInformation:(Event*)eventInfo
{
    receivedEvent = eventInfo;
    receivedEvent.teamlogo = @"http://www.msumustangs.com/images/logos/m6.png";
    //Give the addEventToCalendarClass the event information so that the event can be added to the calendar if required
    /*self.title = receivedEvent.category;
    self.startDate = self.receivedStartDate;
    self.startTime = self.receivedStartTime;*/
}

-(void)downloadImageForHome:(NSString*)homeTeam andAway:(NSString *)awayTeam
{
    homeTeam = [homeTeam stringByReplacingOccurrencesOfString:@" " withString:@""];
    awayTeam = [awayTeam stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.homePhoto setImageWithURL:[NSURL URLWithString:homeTeam]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self.awayPhoto setImageWithURL:[NSURL URLWithString:awayTeam]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)addToCalendar:(UIButton *)sender {
    //Setup the variables for this event in the addEventToMainCalendar class
    NSLog(@"Well, the date on my end before sending to addEventToMainCalendar is %@\n",receivedEvent.startdate);
    self.calendarEventTitle = receivedEvent.title;
    self.calendarEventStartDate = receivedEvent.startdate;
    self.calendarEventEndDate = receivedEvent.enddate;
    [self addEventToMainCalendar];
}

- (IBAction)showInMap:(UIButton *)sender {
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender
{
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:receivedEvent.link];
    SHKItem *item = [SHKItem URL:url title:receivedEvent.title contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)viewInBrowser:(UIButton *)sender {
    NSLog(@"I'm going to go view this thing in the browser. woohoo!!\n");
}
@end

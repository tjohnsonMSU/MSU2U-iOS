//
//  detailEventViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailEventViewController.h"

@interface detailEventViewController ()
@property (weak, nonatomic) NSString* receivedTitle;
@property (weak, nonatomic) NSString* receivedStartTime;
@property (weak, nonatomic) NSString* receivedDescription;
@property (weak, nonatomic) NSString* receivedLink;
@property (weak, nonatomic) NSString* receivedEvgameid;
@property (weak, nonatomic) NSString* receivedEvlocation;
@property (weak, nonatomic) NSString* receivedStartDate;
@property (weak, nonatomic) NSString* receivedEndDate;
@end

@implementation detailEventViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) shareEvent
{
    //Write the code to add the event to the iPhone's calendar
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    log = [[logPrinter alloc]init];
    [log functionEnteredClass:[self class] Function:_cmd];
    
    self.descriptionTextView.text = self.receivedDescription;
    self.titleLabel.text = self.receivedTitle;
    
    if([self.receivedStartDate length]==0)
    {
        self.receivedStartDate = @"";
    }
    if([self.receivedStartTime length]==0)
    {
        self.receivedStartTime = @"";
    }
    NSString * timeDate = self.receivedStartDate;
    timeDate = [timeDate stringByAppendingString:@" at "];
    timeDate = [timeDate stringByAppendingString:self.receivedStartTime];
    
    self.timeDateLabel.text = timeDate;
    self.locationLabel.text = self.receivedEvlocation;
    
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)sendEventInformation:(Event*)eventInfo
{
    [log functionEnteredClass:[self class] Function:_cmd];
    self.receivedTitle = eventInfo.title;
    self.receivedDescription = eventInfo.content;
    self.receivedEndDate = eventInfo.endDate;
    self.receivedStartTime = eventInfo.startTime;
    self.receivedStartDate = eventInfo.startDate;
    self.receivedEvlocation = eventInfo.evlocation;
    
    //Give the addEventToCalendarClass the event information so that the event can be added to the calendar if required
    self.title = self.receivedTitle;
    self.startDate = self.receivedStartDate;
    self.startTime = self.receivedStartTime;
    [log functionExitedClass:[self class] Function:_cmd];
}

- (void)didReceiveMemoryWarning
{
    [log functionEnteredClass:[self class] Function:_cmd];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [log functionExitedClass:[self class] Function:_cmd];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [log functionEnteredClass:[self class] Function:_cmd];
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
    else
    {
        [log outputClass:[self class] Function:_cmd Message:@"Did not select 'Add Event to Calendar, btw."];
    }
    [log functionExitedClass:[self class] Function:_cmd];
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender
{
    [log functionEnteredClass:[self class] Function:_cmd];
    // Create the item to share (in this example, a url)
    NSURL *url = [NSURL URLWithString:self.receivedLink];
    SHKItem *item = [SHKItem URL:url title:self.receivedTitle contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showInView:self.view];
    [log functionExitedClass:[self class] Function:_cmd];
}
@end

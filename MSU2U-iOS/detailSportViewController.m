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
    //Remove the default background from my table view
    self.sportTable.backgroundColor = [UIColor clearColor];
    self.sportTable.opaque = NO;
    self.sportTable.backgroundView = nil;
    
    //Initialize my arrays which will be used to populate data into my table rows
    tableLabel = [[NSArray alloc]initWithObjects:@"title",@"start date",@"start time",@"location",nil];
    tableContent = [[NSArray alloc]initWithObjects:self.receivedTitle,self.receivedStartDate,self.receivedStartTime,self.receivedEvlocation,nil];
    
    self.title = self.receivedStartDate;
    
    //Setup all the images
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadImage];
    });
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
    
    //For my table content, make sure the received information is not null or blank. If so, set it to N/A so my table view won't crash.
    if([self.receivedTitle length] == 0) self.receivedTitle = @"N/A";
    if([self.receivedStartDate length] == 0) self.receivedStartDate = @"N/A";
    if([self.receivedStartTime length] == 0) self.receivedStartTime = @"N/A";
    if([self.receivedEvlocation length] == 0) self.receivedEvlocation = @"N/A";
}

-(void)downloadImage
{
    NSLog(@"I received %@ (home) and %@ (away) as my logo links!\n",self.receivedSteamLogo,self.receivedSopponentLogo);
    self.receivedSteamLogo = [self.receivedSteamLogo stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.receivedSopponentLogo = [self.receivedSopponentLogo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.homePhoto setImageWithURL:[NSURL URLWithString:self.receivedSteamLogo]
               placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self.awayPhoto setImageWithURL:[NSURL URLWithString:self.receivedSopponentLogo]
                   placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//TABLE METHODS

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 4;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Identifier for retrieving reusable cells
    NSString * cellIdentifier;
    
    if(indexPath.section == 0)
    {
        if(indexPath.row != 3 && indexPath.row != 4)
        {
            cellIdentifier = @"sportCell";
        }
        else if(indexPath.row == 3)
        {
            cellIdentifier = @"athleticLocationCell";
        }
    }
    else
    {
        cellIdentifier = @"addEventToCalendarCell";
    }
    
    // Attempt to request the reusable cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // No cell available - create one.
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Set the text of the cell to the row index.
    if(indexPath.section == 0)
    {
        cell.textLabel.text = [tableContent objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [tableLabel objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = @"Add Event to Calendar";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Did the Add Event to Calendar cell get selected?
    if(indexPath.section == 1 && indexPath.row == 0)
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
        NSLog(@"Did not select Add Event to Calendar, btw.\n");
    }
}

-(void) addEventToMainCalendar
{
    NSLog(@"Attempting to add this event to calendar: %@, %@\n",self.receivedTitle,self.receivedStartDate);
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = self.receivedTitle;
    
    //Get the Date prepared
    NSCalendar *greg = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //Rip apart my receivedStartDate (2013-1-1) to 2013 1 1
    NSArray *dateBits = [self.receivedStartDate componentsSeparatedByString: @"-"];
    NSArray *timeBits;
    NSArray *amOrPm;
    if([self.receivedStartTime isEqualToString:@"N/A"])
    {
        NSLog(@"There is no start time...\n");
        timeBits = [[NSArray alloc]initWithObjects:@"12", nil];
    }
    else
    {
        NSLog(@"Start time is %@...\n",self.receivedStartTime);
        timeBits = [self.receivedStartTime componentsSeparatedByString: @":"];
        amOrPm = [[timeBits objectAtIndex:1] componentsSeparatedByString:@" "];
        NSLog(@"amOrPm at index 1 is %@...\n",[amOrPm objectAtIndex:1]);
    }
    
    NSLog(@"My bits: year is %d, month is %d, day is %d, time is %d, am or pm is %@\n",[[dateBits objectAtIndex:0]intValue],[[dateBits objectAtIndex:1]intValue],[[dateBits objectAtIndex:2]intValue],[[timeBits objectAtIndex:0]intValue],[amOrPm objectAtIndex:1]);
    
    comps.day = [[dateBits objectAtIndex:2] intValue];
    comps.month = [[dateBits objectAtIndex:1] intValue];
    comps.year = [[dateBits objectAtIndex:0] intValue];

    //What should the hour be?
    if([[timeBits objectAtIndex:0] intValue] >= 0 && [[timeBits objectAtIndex:0]intValue] <= 24)
    {
        if([[amOrPm objectAtIndex:1]isEqualToString:@"PM"])
        {
            //convert to military time
            comps.hour = [[timeBits objectAtIndex:0]intValue]+12;
        }
        else
        {
            //leave as is because this is in the morning and is already in military time
            comps.hour = [[timeBits objectAtIndex:0] intValue];
        }
        event.allDay = NO;
    }
    else
    {
        NSLog(@"The start time for this event is < 0 or > 24 which is screwy, so I'll just this is an all day event...\n");
        event.allDay = YES;
    }
    
    NSDate *eventDate = [greg dateFromComponents:comps];
    
    event.startDate = eventDate;
    
    //time interval is in seconds. I need to know an end time to calculate this, but for now I'll just say an hour.
    event.endDate   = [[NSDate alloc] initWithTimeInterval:3600 sinceDate:event.startDate];
    
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    
    //Figure out if this event date is in the past. If so, don't add it and let the user know you didn't add it and why!
    UIAlertView *alert;
    if([self isFutureDay:eventDate])
    {
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
        if (!err)
        {
            alert = [[UIAlertView alloc]
                                  initWithTitle:@"Event Created Successfully!"
                                  message:self.receivedTitle
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        }
    }
    else
    {
        alert = [[UIAlertView alloc]
                              initWithTitle:@"Event Creation Failed"
                              message:@"Can't add a past event to calendar"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    }
    [alert show];
}

- (BOOL)isFutureDay:(NSDate*)eventDate
{
    NSDate *today = [NSDate date]; // it will give you current date
    NSDate *newDate = eventDate; // your date
    
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:newDate]; // comparing two dates
    
    if(result==NSOrderedDescending)
        return false;
    else
        return true;
}

@end
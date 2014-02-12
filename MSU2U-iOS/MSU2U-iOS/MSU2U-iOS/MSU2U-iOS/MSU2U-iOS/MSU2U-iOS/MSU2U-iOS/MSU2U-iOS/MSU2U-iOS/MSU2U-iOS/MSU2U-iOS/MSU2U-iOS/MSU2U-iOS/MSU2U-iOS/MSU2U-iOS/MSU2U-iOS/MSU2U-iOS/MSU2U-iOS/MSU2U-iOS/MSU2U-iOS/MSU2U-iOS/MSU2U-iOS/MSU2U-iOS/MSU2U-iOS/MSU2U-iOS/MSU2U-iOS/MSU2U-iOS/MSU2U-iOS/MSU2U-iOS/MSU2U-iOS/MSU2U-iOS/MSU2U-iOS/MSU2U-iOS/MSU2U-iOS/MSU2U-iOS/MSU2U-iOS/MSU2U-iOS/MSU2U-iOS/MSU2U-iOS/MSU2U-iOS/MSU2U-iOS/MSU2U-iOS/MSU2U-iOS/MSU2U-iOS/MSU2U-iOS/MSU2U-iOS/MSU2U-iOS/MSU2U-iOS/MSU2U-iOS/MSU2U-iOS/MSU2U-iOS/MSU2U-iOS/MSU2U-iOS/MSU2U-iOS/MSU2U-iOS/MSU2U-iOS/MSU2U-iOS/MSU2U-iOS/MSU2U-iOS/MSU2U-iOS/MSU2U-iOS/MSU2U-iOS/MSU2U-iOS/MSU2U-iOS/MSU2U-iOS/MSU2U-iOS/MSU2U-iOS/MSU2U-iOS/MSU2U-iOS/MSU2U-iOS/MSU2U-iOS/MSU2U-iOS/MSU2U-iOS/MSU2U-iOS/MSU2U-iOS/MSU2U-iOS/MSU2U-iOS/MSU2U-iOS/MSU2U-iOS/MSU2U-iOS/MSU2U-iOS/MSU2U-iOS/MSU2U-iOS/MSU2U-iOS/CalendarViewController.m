//
//  CalendarViewController.m
//  MSU2U-iOS
//
//  Created by Hieu Tran and Romando Garcia on 12/20/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "CalendarViewController.h"
#import <EventKit/EventKit.h>
#import "addEventToCalendar.h"

@interface CalendarViewController ()

@property (nonatomic,strong) NSArray * spring14;
@property (nonatomic,strong) NSArray * fSummer14;
@property (nonatomic,strong) NSArray * sSummer14;
@property (nonatomic,strong) NSArray * sDate;
@property (nonatomic,strong) NSArray * eDate;
@property (nonatomic,strong) NSMutableArray * arrayStartDate;
@property (nonatomic,strong) NSMutableArray * arrayEndDate;
@end

@implementation CalendarViewController

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
    
    //load the array of spring with the object as event, key as dates
    self.spring14 = [[NSArray alloc]initWithObjects:
                     @{@"title":@"Application Date for Admission",@"date":@"November 1, 2013"},
                     @{@"title":@"Application Deadline",@"date":@"December 15, 2013"},
                     @{@"title":@"Reenrolling Student Registration",@"date":@"January 6, 2014 - January 7, 2014"},
                     @{@"title":@"Orientation, Advising and Registration",@"date":@"January 8, 2014 - January 9,2014"},
                     @{@"title":@"Student Advising and Registration",@"date":@"January 10, 2014"},
                     @{@"title":@"Classes begin",@"date":@"January 11, 2014"},
                     @{@"title":@"Change of Schedule or Late Registration",@"date":@"January 13, 2014 - January 15, 2014"},
                     @{@"title":@"Martin Luther King's - No classes",@"date":@"January 20, 2014"},
                     @{@"title":@"Deadline for May graduates",@"date":@"February 17, 2014"},
                     @{@"title":@"Last Day for drop with a “W”, 4:00 p.m.",@"date":@"March 10,2014"},
                     @{@"title":@"Spring Break",@"date":@"March 15, 2014 - March 23, 2014"},
                     @{@"title":@"Easter Break",@"date":@"April 16, 2014 - April 20, 2014"},
                     @{@"title":@"Last Day of classes",@"date":@"May 2, 2014"},
                     @{@"title":@"Final exam",@"date": @"May 3, 2014 - May 9, 2014"},
                     @{@"title":@"Commencement",@"date":@"May 10, 2014"},nil];
    
    //load the summer array with object as events, key as dates
    self.fSummer14 = [[NSArray alloc]initWithObjects:
                      @{@"title":@"Priority Application Date for Admission",@"date":@"May 1, 2014"},
                      @{@"title":@"Application Deadline for Admission",@"date":@"May 15,2014"},
                      @{@"title":@"Memorial Day Holiday",@"date":@"May 26, 2014"},
                      @{@"title":@"Reenrolling Student Registration", @"date":@"May 27, 2014 - May 28, 2014"},
                      @{@"title":@"Student Orientation, Advising, and Registration",@"date":@"May 29, 2014"},
                      @{@"title":@"Classes begin", @"date":@"June 2, 2014"},
                      @{@"title":@"Final exam", @"date":@"June 3, 2014"},
                      nil];
    self.sSummer14 = [[NSArray alloc]initWithObjects:
                      @{@"title":@"Priority Application Date for Admission", @"date":@"June 1, 2014"},
                      @{@"title":@"Application Deadline for Admission", @"date":@"June 15,2014"},
                      @{@"title":@"Student Orientation, Advising, and Registration", @"date":@"July 3, 2014"},
                      @{@"title":@"Independence Day Holiday", @"date":@"July 4, 2014"},
                      @{@"title":@"Classes begin", @"date":@"July 7, 2014"},
                      @{@"title":@"Deadline for August graduate to file for graduation", @"date":@"July 7, 2014"},
                      @{@"title":@"Final exam", @"date":@"August 7, 2014"},
                      nil];
}
- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section
{
    //return the section header for each row section
    NSString *result = nil;
    switch (section) {
        case 0:
            result = @"Spring Semester 2014";
            return result;
            break;
        case 1:
            result = @"First Summer Session 2014";
            return result;
            break;
        case 2:
            result = @"Second Summer Session 2014";
            return result;
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section)
    {
        case 0:
            return [self.spring14 count];
            break;
        case 1:
            return [self.fSummer14 count];
            break;
        case 2:
            return [self.sSummer14 count];
            break;
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    int section = [indexPath section];
    
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //using switch to set the label for the section in the table
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"title"];
            cell.detailTextLabel.text = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"date"];
            break;
        case 1:
            cell.textLabel.text = [[self.fSummer14 objectAtIndex:indexPath.row]objectForKey:@"title"];
            cell.detailTextLabel.text = [[self.fSummer14 objectAtIndex:indexPath.row]objectForKey:@"date"];
            break;
        case 2:
            cell.textLabel.text = [[self.sSummer14 objectAtIndex:indexPath.row]objectForKey:@"title"];
            cell.detailTextLabel.text = [[self.sSummer14 objectAtIndex:indexPath.row]objectForKey:@"date"];
            break;
            
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    addEventToCalendar * event = [[addEventToCalendar alloc]init];
    event.calendarEventTitle =[[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"title"];
    event.calendarEventStartDate = [self.arrayStartDate objectAtIndex:0];
    event.calendarEventEndDate = [self.arrayEndDate objectAtIndex:0];
    [event addEventToMainCalendar];
    
}

-(void)startDateStringtoDate
{
    self.arrayStartDate = [[NSMutableArray alloc]init];
    self.sDate = [[NSArray alloc]initWithObjects:
                  @"11-01-2013",@"12-15-2013",@"01-06-2014",@"01-08-2014",@"01-10-2014",
                  @"01-11-2014",@"01-13-2014",@"01-20-2014",@"02-17-2014",@"03-10-2014",
                  @"03-15-2014",@"04-16-2014",@"05-02-2014",@"05-03-2014",@"05-10-2014",
                  @"05-01-2014",@"05-15-2014",@"05-26-2014",@"05-27-2014",@"05-29-2014",
                  @"06-02-2014",@"06-03-2014",@"06-01-2014",@"06-15-2014",@"07-03-2014",
                  @"07-04-2014",@"07-07-2014",@"07-07-2014",@"08-07-2014",nil];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    for (int i =0; i< [self.sDate count]; i++)
    {
        NSDate * dateFromString = [dateFormat dateFromString:[self.sDate objectAtIndex:i]];
        [_arrayStartDate addObject:dateFromString];
    }
}

-(void)endDateStringtoDate
{
    self.arrayEndDate = [[NSMutableArray alloc]init];
    self.eDate = [[NSArray alloc]initWithObjects:
                  @"11-01-2013",@"12-15-2013",@"01-07-2014",@"01-09-2014",@"01-10-2014",
                  @"01-11-2014",@"01-15-2014",@"01-20-2014",@"02-17-2014",@"03-10-2014",
                  @"03-23-2014",@"04-20-2014",@"05-02-2014",@"05-09-2014",@"05-10-2014",
                  @"05-01-2014",@"05-15-2014",@"05-26-2014",@"05-28-2014",@"05-29-2014",
                  @"06-02-2014",@"06-03-2014",@"06-01-2014",@"06-15-2014",@"07-03-2014",
                  @"07-04-2014",@"07-07-2014",@"07-07-2014",@"08-07-2014",nil];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    for (int i =0; i< [self.sDate count]; i++)
    {
        NSDate * dateFromString = [dateFormat dateFromString:[self.sDate objectAtIndex:i]];
        [_arrayEndDate addObject:dateFromString];
    }
}

@end

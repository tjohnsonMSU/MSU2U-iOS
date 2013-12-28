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
@property (nonatomic,strong) NSArray * summer14;

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
                          @{@"title":@"Application Date for Admission",@"startDate":@"November 1, 2013", @"endDate":@"November 1, 2013"},
                          @{@"title":@"Application Deadline",@"startDate":@"December 15, 2013",@"endDate":@"December 15, 2013"},
                          @{@"title":@"Reenrolling Student Registration",@"date":@"January 6, 2014",@"endDate":@"January 7, 2014"},
                          @{@"title":@"Orientation, Advising and Registration",@"startDate":@"January 8, 2014",@"endDate":@"January 9,2014"},
                          @{@"title":@"Student Advising and Registration",@"startDate":@"January 10, 2014",@"endDate":@"January 10 ,2014"},
                          @{@"title":@"Classes begin",@"startDate":@"January 11, 2014",@"endDate":@"January 11,2014"},
                          @{@"title":@"Change of Schedule or Late Registration",@"startDate":@"January 13, 2014",@"endDate":@"January 15, 2014"},
                          @{@"title":@"Martin Luther King's - No classes",@"startDate":@"January 20, 2014",@"endDate":@"January 20, 2014"},
                          @{@"title":@"Deadline for May graduates",@"startDate":@"February 17, 2014",@"endDate":@"February 17,2014"},
                          @{@"title":@"Last Day for drop with a “W”, 4:00 p.m.",@"startDate":@"March 10,2014",@"endDate":@"March 10,2014"},
                          @{@"title":@"Spring Break",@"startDate":@"March 15, 2014",@"endDate":@"March 23, 2014"},
                          @{@"title":@"Easter Break",@"startDate":@"April 16, 2014",@"endDate":@"April 20, 2014"},
                          @{@"title":@"Last Day of classes",@"startDate":@"May 2, 2014", @"endDate":@"May 2, 2014"},
                          @{@"title":@"Final exam",@"startDate": @"May 3, 2014",@"endDate":@"May 9, 2014"},
                          @{@"title":@"Commencement",@"startDate":@"May 10",@"endDate":@"May 9, 2014"},nil];
    
    //load the summer array with object as events, key as dates
    self.summer14 = [[NSArray alloc]initWithObjects:
                     @{@"title":@"First Term: June 2 - July 3",@"startDate":@"June 2, 2014",@"endDate":@"July 3,2014"},
                     @{@"title":@"Priority Application Date for Admission",@"startDate":@"May 1, 2014",@"endDate":@"May 1, 2014"},
                     @{@"title":@"Application Deadline for Admission",@"startDate":@"May 15,2014",@"endDate":@"May 15,2014",@"endDate":@"May 15, 2014"},
                     @{@"title":@"Memorial Day Holiday",@"startDate":@"May 26, 2014",@"endDate":@"May 26, 2014"},
                     @{@"title":@"Reenrolling Student Registration", @"startDate":@"May 27, 2014",@"endDate":@"May 28, 2014"},
                     @{@"title":@"Student Orientation, Advising, and Registration",@"startDate":@"May 29, 2014", @"endDate": @"May 29, 2014"},
                     @{@"title":@"Classes begin", @"startDate":@"June 2, 2014",@"endDate":@"June 2, 2014"},
                     @{@"title":@"Second Term: July 7 - August 7", @"startDate":@"July 7, 2014",@"endDate":@"August 7, 2014"},
                     @{@"title":@"Priority Application Date for Admission", @"startDate":@"June 1, 2014",@"endDate":@"June 1, 2014"},
                     @{@"title":@"Application Deadline for Admission", @"startDate":@"June 15,2014",@"endDate":@"June 15, 2014"},
                     @{@"title":@"Student Orientation, Advising, and Registration", @"startDate":@"July 3, 2014",@"endDate":@"July 3, 2014"},
                     @{@"title":@"Independence Day Holiday", @"startDate":@"July 4, 2014",@"endDate":@"July 4, 2014"},
                     @{@"title":@"Classes begin", @"startDate":@"July 7, 2014",@"endDate":@"July 7,2014"},
                     @{@"title":@"Deadline for August graduate to file for graduation", @"startDate":@"July 7, 2014",@"endDate":@"July 7, 2014"},
                     @{@"title":@"Final exam", @"startDate":@"August 7, 2014",@"endDate":@"August 7, 2014"},
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
            result = @"Summer Session 2014";
            return result;
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
    return 2;
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
            return [self.summer14 count];
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
            cell.detailTextLabel.text = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"startDate"];
            break;
        case 1:
            cell.textLabel.text = [[self.summer14 objectAtIndex:indexPath.row]objectForKey:@"title"];
            cell.detailTextLabel.text = [[self.summer14 objectAtIndex:indexPath.row]objectForKey:@"startDate"];
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    EKEventStore *eventStore = [[EKEventStore alloc]init];
//    EKEventStore *event = [EKEvent eventWithEventStore:eventStore];
//    
//    event.title = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"title"];
//    event.setdate = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"date"];
//    
//    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"",[[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"title"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Awesome!", nil];
//    
//    [av show];
    addEventToCalendar * event = [[addEventToCalendar alloc]init];
    event.calendarEventTitle =[[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"title"];
    event.calendarEventStartDate = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"startDate"];
    event.calendarEventEndDate = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"endDate"];
    [event addEventToMainCalendar];
  
}



@end

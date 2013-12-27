//
//  CalendarViewController.m
//  MSU2U-iOS
//
//  Created by Hieu Tran and Romando Garcia on 12/20/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@property (nonatomic,strong) NSArray * eventCalendar;
@property (nonatomic,strong) NSArray * semester;
@property (nonatomic,strong) NSArray * spring14;
@property (nonatomic,strong) NSArray * fall13;
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
    self.spring14 = [[NSArray alloc]initWithObjects:
                          @{@"title":@"Application Date for Admission",@"date":@"November 1, 2013"},
                          @{@"title":@"Application Deadline",@"date":@"December 15, 2013"},
                          @{@"title":@"Reenrolling Student Registration",@"date": @"January 6 - January 7"},
                          @{@"title":@"Orientation, Advising and Registration",@"date": @"January 8 - January 9"},
                          @{@"title":@"Student Advising and Registration",@"date": @"January 10"},
                          @{@"title":@"Classes begin",@"date":@"January 11"},
                          @{@"title":@"Change of Schedule or Late Registration",@"date": @"January 13 - January 15"},
                          @{@"title":@"Martin Luther King's - No classes",@"date":@"January 20"},
                          @{@"title":@"Deadline for May graduates",@"date":@"February 17"},
                          @{@"title":@"Last Day for drop with a “W”, 4:00 p.m.",@"date":@"March 10"},
                          @{@"title":@"Spring Break",@"date": @"March 15 - March 23"},
                          @{@"title":@"Easter Break",@"date": @"April 16 - April 20"},
                          @{@"title":@"Last Day of classes",@"date":@"May 2"},
                          @{@"title":@"Final exam",@"date": @"May 3 - May 9"},
                          @{@"title":@"Commencement",@"date":@"May 10"},nil];
    
    self.summer14 = [[NSArray alloc]initWithObjects:
                     @{@"title":@"First Term", @"date":@"June 2 - July 3"},
                     @{@"title":@"Priority Application Date for Admission", @"date":@"May 1"},
                     @{@"title":@"Application Deadline for Admission", @"date":@"May 15"},
                     @{@"title":@"Memorial Day Holiday", @"date":@"May 26"},
                     @{@"title":@"Reenrolling Student Registration", @"date":@"May 27 - May 28"},
                     @{@"title":@"Student Orientation, Advising, and Registration", @"date":@"May 29"},
                     @{@"title":@"Classes begin", @"date":@"June 2"},
                     @{@"title":@"Second Term", @"date":@"July 7 - August 7"},
                     @{@"title":@"Priority Application Date for Admission", @"date":@"June 1"},
                     @{@"title":@"Application Deadline for Admission", @"date":@"June 15"},
                     @{@"title":@"Student Orientation, Advising, and Registration", @"date":@"July 3"},
                     @{@"title":@"Independence Day Holiday", @"date":@"July 4"},
                     @{@"title":@"Class begin", @"date":@"July 7"},
                     @{@"title":@"Deadline for August graduate to file for graduation", @"date":@"July 7"},
                     @{@"title":@"Final exam", @"date":@"August 7"},
                     nil];

}
- (NSString *) tableView:(UITableView *)tableView
 titleForHeaderInSection:(NSInteger)section
{
    
    NSString *result = nil;
//    
//    if ([tableView isEqual:self.tableView] &&
//        section == 0){
//        result = @"Spring Semester 2014";
//    }
//
//    return result;
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
 //   return [self.spring14 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.detailTextLabel.text = [[self.spring14 objectAtIndex:indexPath.row]objectForKey:@"date"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

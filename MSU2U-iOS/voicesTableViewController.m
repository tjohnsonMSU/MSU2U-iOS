//
//  voicesTableViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/15/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "voicesTableViewController.h"

@interface voicesTableViewController ()
@end

@implementation voicesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    voicesYear = [[NSArray alloc] initWithObjects:@"1977",@"1978",@"1979",@"1980",@"1990",@"1991",@"1992",@"1994",@"2010", nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [voicesYear count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"voicesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [voicesYear objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"[ EXAMPLE ROW ONLY ]";
    
    //Example: 1977.png
    cell.imageView.image = [UIImage imageNamed:[[voicesYear objectAtIndex:indexPath.row]stringByAppendingString:@".png"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //chosenRow is a private variable I can use with a scope that can be used in any function I desire. It is needed in the prepareForSegue method since that method does not have access to indexPath.row
    chosenRow = indexPath.row;
    [self performSegueWithIdentifier:@"showVoicesWebView" sender:tableView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"I'm preparing for a segue to showVoicesWebView\n");
    NSString * stringURL = @"http://www.matthewfarmer.net/pdf/";
    
    stringURL = [stringURL stringByAppendingString:[voicesYear objectAtIndex:chosenRow]];
    stringURL = [stringURL stringByAppendingString:@".pdf"];
    NSLog(@"My constructed URL for the Voices PDF is %@\n",stringURL);
    
    [segue.destinationViewController sendWebsiteToVisit:stringURL];
}

@end

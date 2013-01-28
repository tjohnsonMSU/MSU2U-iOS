//
//  campusMapViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/27/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapViewController.h"

@interface campusMapViewController ()

@end

@implementation campusMapViewController

-(void)viewDidLoad
{
    //Load the Buildings Array
    buildings = [[NSArray alloc]initWithObjects:@"Bridwell Courts",@"Bolin Hall",@"Redwine Fitness Center",@"Moffett Library",nil];
    self.campusMap.mapType = MKMapTypeHybrid;
}

-(void)viewDidAppear:(BOOL)animated
{
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(33.871841,-98.521914);
    MKCoordinateRegion adjustedRegion = [self.campusMap regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1000, 1000)];
    [self.campusMap setRegion:adjustedRegion animated:NO];
}

-(void)addPinWithTitle:(NSString*)title atLocation:(CLLocationCoordinate2D) coordinate
{
    MSUBuilding * testBuilding = [[MSUBuilding alloc] init];
    NSLog(@"Received coordinate: %f,%f\n",coordinate.latitude,coordinate.longitude);
    //Create information for this test site
    testBuilding.title = title;
    testBuilding.coordinate = coordinate;
    
    //Add annotation to the map
    [self.campusMap addAnnotation:testBuilding];
    NSLog(@"Campus Map: Leaving buttonPressed...\n");
}

//SEARCH BAR TABLE VIEW STUFF
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [buildings count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testing"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [buildings objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [buildings filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLLocationCoordinate2D coordinate;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        float latitude = 0, longitude = 0;
        
        if([[searchResults objectAtIndex:indexPath.row] isEqualToString:@"Bridwell Courts"])
        {
            latitude=33.877163;longitude=-98.524114;
        }
        else if([[searchResults objectAtIndex:indexPath.row] isEqualToString:@"Bolin Hall"])
        {
            latitude=33.873962;longitude=-98.519436;
        }
        else if([[searchResults objectAtIndex:indexPath.row] isEqualToString:@"Redwine Fitness Center"])
        {
            latitude=33.869992;longitude=-98.523706;
        }
        else if([[searchResults objectAtIndex:indexPath.row] isEqualToString:@"Moffett Library"])
        {
            latitude=33.874855;longitude=-98.519200;
        }
        
        coordinate = CLLocationCoordinate2DMake(latitude,longitude);
        [self addPinWithTitle:[searchResults objectAtIndex:indexPath.row] atLocation:coordinate];
    }
    MKCoordinateRegion adjustedRegion = [self.campusMap regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.campusMap setRegion:adjustedRegion animated:YES];
}

@end

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

- (NSArray *)executeDataFetch:(NSString *)query
{
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}

-(void)viewDidLoad
{
    //Load the Buildings Array
    //buildings = [[NSArray alloc]initWithObjects:@"Bridwell Courts",@"Bolin Hall",@"Redwine Fitness Center",@"Moffett Library",nil];
    self.campusMap.mapType = MKMapTypeHybrid;
    
    //Allocate arrays
    self.buildingName = [[NSMutableArray alloc]init];
    self.buildingCoordinate = [[NSMutableArray alloc]init];
    
    //Download the JSON data
    buildings = [self executeDataFetch:@"http://www.matthewfarmer.net/buildings.json"];
    
    for(NSDictionary * dataInfo in buildings)
    {
        [self.buildingName addObject:[dataInfo objectForKey:@"name"]];
        [self.buildingCoordinate addObject:[[NSArray alloc]initWithObjects:[dataInfo objectForKey:@"latitude"],[dataInfo objectForKey:@"longitude"], nil]];
    }
    
    //Place the organized JSON data into a dictionary format that can be more easily worked with later
    self.buildingList = [[NSMutableDictionary alloc]initWithObjects:self.buildingCoordinate forKeys:self.buildingName];
}

-(void)viewDidAppear:(BOOL)animated
{
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(33.871841,-98.521914);
    MKCoordinateRegion adjustedRegion = [self.campusMap regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1000, 1000)];
    [self.campusMap setRegion:adjustedRegion animated:NO];
}

-(void)addPinWithTitle:(NSString*)title atLocation:(NSArray*) coordinate
{
    MSUBuilding * testBuilding = [[MSUBuilding alloc] init];
    NSLog(@"Received coordinate: %@,%@\n",[coordinate objectAtIndex:0],[coordinate objectAtIndex:1]);
    
    //Create information for this test site
    testBuilding.title = title;
    
    CLLocationCoordinate2D myCoordinate = CLLocationCoordinate2DMake([[coordinate objectAtIndex:0]floatValue], [[coordinate objectAtIndex:1]floatValue]);
    
    testBuilding.coordinate = myCoordinate;
    
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
        return [self.buildingName count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testing"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [self.buildingName objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [self.buildingName filteredArrayUsingPredicate:resultPredicate];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self addPinWithTitle:[searchResults objectAtIndex:indexPath.row] atLocation:[self.buildingList objectForKey:[searchResults objectAtIndex:indexPath.row]]];
    }
    float latitude = [[[self.buildingList objectForKey:[searchResults objectAtIndex:indexPath.row]] objectAtIndex:0] floatValue];
    float longitude = [[[self.buildingList objectForKey:[searchResults objectAtIndex:indexPath.row]]objectAtIndex:1] floatValue];
    
    coordinate = CLLocationCoordinate2DMake(latitude,longitude);
                                              
    MKCoordinateRegion adjustedRegion = [self.campusMap regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 250, 250)];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.campusMap setRegion:adjustedRegion animated:YES];
}

@end

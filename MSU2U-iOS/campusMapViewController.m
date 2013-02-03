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

@synthesize campusMap = _campusMap;

- (NSArray *)executeDataFetch:(NSString *)query
{
    NSString * textPath = [[NSBundle mainBundle]pathForResource:@"buildings" ofType:@"json"];
    NSError * error;
    NSData *jsonData = [[NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];

    NSArray *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
     
    return results;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //Remove map overlays if any.
    
    //Set map type
    self.campusMap.mapType = MKMapTypeHybrid;
    
    //Allocate arrays
    self.buildingName = [[NSMutableArray alloc]init];
    self.buildingCoordinate = [[NSMutableArray alloc]init];
    
    //Download the JSON data
    buildings = [self executeDataFetch:@"buildings.json"];
    
    for(NSDictionary * dataInfo in buildings)
    {
        [self.buildingName addObject:[dataInfo objectForKey:@"name"]];
        [self.buildingCoordinate addObject:[[NSArray alloc]initWithObjects:[dataInfo objectForKey:@"latitude"],[dataInfo objectForKey:@"longitude"], nil]];
    }
    
    //Place the organized JSON data into a dictionary format that can be more easily worked with later
    self.buildingList = [[NSMutableDictionary alloc]initWithObjects:self.buildingCoordinate forKeys:self.buildingName];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    NSLog(@"I'm in mapview view for overlay...\n");
	if([overlay isKindOfClass:[MKPolygon class]]){
        NSLog(@"I'm an MKPolygon class...\n");
		MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
		view.lineWidth=1;
		//view.strokeColor=[UIColor yellowColor];
		view.strokeColor = _parkingLotColor;
        //view.fillColor=[[UIColor yellowColor] colorWithAlphaComponent:0.5];
        view.fillColor = [_parkingLotColor colorWithAlphaComponent:0.5];
        return view;
	}
    else if([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineView * view = [[MKPolylineView alloc]initWithPolyline:overlay];
        view.lineWidth=5;
        view.strokeColor = _polylineColor;
        if(_polylineColor == [UIColor purpleColor])
        {
            //bus
            view.tag = 1;
        }
        else if(_polylineColor == [UIColor greenColor])
        {
            //campus border
            view.tag = 2;
        }
        return view;
    }
    NSLog(@"ERROR: Overlay was not of type MKPolygon OR MKPolylineView\n");
	return nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.campusMap removeOverlays:[_campusMap overlays]];
    //Define map view region
    MKCoordinateSpan span;
	span.latitudeDelta=.01;
	span.longitudeDelta=.01;
    
	MKCoordinateRegion region;
	region.span=span;
	region.center=CLLocationCoordinate2DMake(33.871841, -98.521914);
    
    [_campusMap setRegion:region animated:NO];
	[_campusMap regionThatFits:region];
    
    //#####
    //####
    //### Draw Overlays!
    //##
    //#
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"campusMapSettingsParkingLot"])
    {
        overlay * pl = [[overlay alloc]init];
        _parkingLotColor = [UIColor yellowColor];
        [pl drawCommuterParkingLots:_campusMap];
        _parkingLotColor = [UIColor cyanColor];
        [pl drawReservedParkingLots:_campusMap];
        _parkingLotColor = [UIColor redColor];
        [pl drawResidentialParkingLots:_campusMap];
        _parkingLotColor = [UIColor orangeColor];
        [pl drawHybridParkingLots:_campusMap];
    }
    else
    {
        [_campusMap removeOverlays:[_campusMap overlays]];
    }
    
    if([defaults boolForKey:@"campusMapSettingsBusRoute"])
    {
        overlay * pk = [[overlay alloc]init];
        _polylineColor = [UIColor purpleColor];
        [pk busRoute:_campusMap];
    }
    else
    {
        //Remove only the bus route tag
        [[self.view.window viewWithTag:1] removeFromSuperview];
    }
    
    if([defaults boolForKey:@"campusMapSettingsCampusBorder"])
    {
        overlay * pc = [[overlay alloc]init];
        _polylineColor = [UIColor greenColor];
        [pc campusBorder:_campusMap];
    }
    else
    {
        //Remove only the campus border
        [[self.view.window viewWithTag:2] removeFromSuperview];
    }
    
    //#####
    //####
    //### Draw appropriate may type!
    //##
    //#
    NSLog(@"My map type should be %@\n",[defaults objectForKey:@"campusMapSettingsMapRowChecked"]);
    if([[defaults objectForKey:@"campusMapSettingsMapRowChecked"] isEqualToString:@"Hybrid"])
    {
        self.campusMap.mapType = MKMapTypeHybrid;
    }
    else if([[defaults objectForKey:@"campusMapSettingsMapRowChecked"]isEqualToString:@"Satellite Only"])
    {
        self.campusMap.mapType = MKMapTypeSatellite;
    }
    else if([[defaults objectForKey:@"campusMapSettingsMapRowChecked"]isEqualToString:@"Roads Only"])
    {
        self.campusMap.mapType = MKMapTypeStandard;
    }
    
    [super viewDidLoad];
}

-(void)addPinWithTitle:(NSString*)title atLocation:(NSArray*) coordinate
{
    MSULocation * testBuilding = [[MSULocation alloc] init];
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

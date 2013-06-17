//
//  campusMapViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/27/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapViewController.h"

typedef void (^RWLocationCallback)(CLLocationCoordinate2D);

@interface campusMapViewController (){
    RWLocationCallback _foundLocationCallback;
}
@end

@implementation campusMapViewController

@synthesize campusMap = _campusMap;

- (NSArray *)executeDataFetch:(NSString *)query
{
    //Get all of the buildings loaded so that searches may be conducted
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
    
    //Keys to search on
    self.keysToSearchOn = [[NSArray alloc] initWithObjects:@"buildingName",@"tag", nil];
    
    //Set map type
    self.campusMap.mapType = MKMapTypeHybrid;
    
    //Allocate arrays
    self.buildingName = [[NSMutableArray alloc]init];
    self.buildingCoordinate = [[NSMutableArray alloc]init];
    self.buildingAddress = [[NSMutableArray alloc]init];
    self.tag = [[NSMutableArray alloc]init];
    
    //Download the JSON data
    buildings = [self executeDataFetch:@"buildings.json"];
    
    NSLog(@"About to stuff buildings into datainfo...\n");
    for(NSDictionary * dataInfo in buildings)
    {
        [self.buildingName addObject:[dataInfo objectForKey:@"name"]];
        [self.buildingCoordinate addObject:[[NSArray alloc]initWithObjects:[dataInfo objectForKey:@"latitude"],[dataInfo objectForKey:@"longitude"], nil]];
        [self.buildingAddress addObject:[[NSArray alloc]initWithObjects:
                                         [dataInfo objectForKey:@"addressCountryCode"],
                                         [dataInfo objectForKey:@"addressStreetCode"],
                                         [dataInfo objectForKey:@"addressStateCode"],
                                         [dataInfo objectForKey:@"addressCityCode"],
                                         [dataInfo objectForKey:@"addressZIPCode"],
                                         nil]];
        [self.tag addObject:[dataInfo objectForKey:@"tag"]];
    }
    //Place the organized JSON data into a dictionary format that can be more easily worked with later
    self.tagToBuildingNameLookup = [[NSDictionary alloc]initWithObjects:self.buildingName forKeys:self.tag];
    self.coordinateLookup = [[NSDictionary alloc]initWithObjects:self.buildingCoordinate forKeys:self.buildingName];
    self.addressLookup = [[NSDictionary alloc]initWithObjects:self.buildingAddress forKeys:self.buildingName];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MSULocation class]]) {
        static NSString *const kPinIdentifier = @"MSULocation";
        MKPinAnnotationView *view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kPinIdentifier];
        if (!view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinIdentifier];
            view.canShowCallout = YES;
            view.calloutOffset = CGPointMake(-5, 5);
            view.animatesDrop = NO;
        }
        
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return view;
    }
    return nil;
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	if([overlay isKindOfClass:[MKPolygon class]]){
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
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    _selectedLocation = (MSULocation*)view.annotation;
    
    // 1
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Show Directions",@"Remove Pin", nil];
    
    // 3
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    // 4
    //[sheet showInView:self.view];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)performAfterFindingLocation:(RWLocationCallback)callback
{
    if (self.campusMap.userLocation != nil) {
        if (callback) {
            callback(self.campusMap.userLocation.coordinate);
        }
    } else {
        _foundLocationCallback = [callback copy];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_foundLocationCallback) {
        _foundLocationCallback(userLocation.coordinate);
    }
    _foundLocationCallback = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 1
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == 0) {
            // Open Apple Maps and 
            /*MKMapItem *mapItem = [_selectedLocation mapItem];
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            [mapItem openInMapsWithLaunchOptions:launchOptions];
             */
            // Create an MKMapItem to pass to the Apple Maps app
            NSDictionary *addressDict = @{
                                          (NSString *) kABPersonAddressStreetKey : _selectedLocation.addressStreetKey,
                                          (NSString *) kABPersonAddressCityKey : _selectedLocation.addressCityKey,
                                          (NSString *) kABPersonAddressStateKey : _selectedLocation.addressStateKey,
                                          (NSString *) kABPersonAddressZIPKey : _selectedLocation.addressZIPKey,
                                          (NSString *) kABPersonAddressCountryKey : _selectedLocation.countryKey
                                          };
            
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[_selectedLocation coordinate]
                                                           addressDictionary:addressDict];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:[_selectedLocation title]];
            
            // Set the directions mode to "Walking"
            // Can use MKLaunchOptionsDirectionsModeDriving instead
            NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
            // Get the "Current User Location" MKMapItem
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            // Pass the current location and destination map items to the Maps app
            // Set the direction mode in the launchOptions dictionary
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] 
                           launchOptions:launchOptions];
            
        } else if (buttonIndex == 1) {
            // REMOVE PIN HERE
            id<MKAnnotation> ann = [[_campusMap selectedAnnotations] objectAtIndex:0];
            NSLog(@"ann.title = %@", ann.title);
            [_campusMap removeAnnotation:ann];
        } else if (buttonIndex == 2) {
            // SHOW MORE INFO CODE HERE
        }
    }
    
    // 5
    _selectedLocation = nil;
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

-(void)addPinWithTitle:(NSString*)title atLocation:(NSArray*)locationInfo atAddress:(NSArray*)addressInfo
{
    //locationInfo:
    //Index 0 is an array with two elements: latitude and longitude
    //Index 1 is an array with five elements: country code, street, state, city, ZIP
    //Therefore, to get the street for example, I need to go to index 1 of the object at index 1 of locationInfo
    MSULocation * testBuilding = [[MSULocation alloc] init];
    
    //Create information for this test site
    testBuilding.title = title;
    testBuilding.countryKey = [addressInfo objectAtIndex:0];
    testBuilding.addressStreetKey = [addressInfo objectAtIndex:1];
    testBuilding.addressStateKey = [addressInfo objectAtIndex:2];
    testBuilding.addressCityKey = [addressInfo objectAtIndex:3];
    testBuilding.addressZIPKey = [addressInfo objectAtIndex:4];
    
    CLLocationCoordinate2D myCoordinate = CLLocationCoordinate2DMake([[locationInfo objectAtIndex:0]floatValue], [[locationInfo objectAtIndex:1]floatValue]);
    
    testBuilding.coordinate = myCoordinate;
    
    //Add annotation to the map
    [self.campusMap addAnnotation:testBuilding];
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
    //ORIGINAL MAP SEARCH CODE
    searchResults = [[NSMutableArray alloc]init];
    
    
    NSArray *words = [searchText componentsSeparatedByString:@" "];
    NSMutableArray *predicateList = [NSMutableArray array];
    
    for (NSString *word in words) {
        if ([word length] > 0)
        {
            NSString * buildingMyPredicate = [[NSString alloc]init];

            NSString *escaped = [word stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];

            buildingMyPredicate = [buildingMyPredicate stringByAppendingString:[NSString stringWithFormat:@"SELF CONTAINS[c] '%@'",escaped]];

            NSPredicate *pred = [NSPredicate predicateWithFormat:buildingMyPredicate];
            [predicateList addObject:pred];
        }
    }
    NSPredicate *resultPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
    
    tagResults = [self.tag filteredArrayUsingPredicate:resultPredicate];
    
    //OK, I have all the appropriate matching tags. Now, I just need the building name associated with each tag!
    for(int i=0; i<[tagResults count]; i++)
    {
        NSLog(@"%d: %@\n",i,[tagResults objectAtIndex:i]);
        [searchResults addObject:[self.tagToBuildingNameLookup objectForKey:[tagResults objectAtIndex:i]]];
    }
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

//What happens when a search result is selected?
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLLocationCoordinate2D coordinate;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self addPinWithTitle:[searchResults objectAtIndex:indexPath.row] atLocation:[self.coordinateLookup objectForKey:[searchResults objectAtIndex:indexPath.row]] atAddress:[self.addressLookup objectForKey:[searchResults objectAtIndex:indexPath.row]]];
    }
    
    float latitude = [[[self.coordinateLookup objectForKey:[searchResults objectAtIndex:indexPath.row]] objectAtIndex:0] floatValue];
    float longitude = [[[self.coordinateLookup objectForKey:[searchResults objectAtIndex:indexPath.row]]objectAtIndex:1] floatValue];
    
    coordinate = CLLocationCoordinate2DMake(latitude,longitude);
                                              
    MKCoordinateRegion adjustedRegion = [self.campusMap regionThatFits:MKCoordinateRegionMakeWithDistance(coordinate, 250, 250)];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.campusMap setRegion:adjustedRegion animated:YES];
}

@end

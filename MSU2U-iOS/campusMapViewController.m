//
//  campusMapViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/22/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "campusMapViewController.h"

@interface campusMapViewController ()
@end

@implementation campusMapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // initialize default map view properties
    defaultCenter = CLLocationCoordinate2DMake(33.732894,-118.091718);
    defaultSpan = MKCoordinateSpanMake(0.028270, 0.0465364);
    
    // Setup MapView's inital region
    defaultRegion = MKCoordinateRegionMake(defaultCenter, defaultSpan);
    
    // create the map view
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    myMapView = [[MKMapView alloc] initWithFrame:screenRect];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // update map's initial view
    [myMapView setRegion:defaultRegion animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

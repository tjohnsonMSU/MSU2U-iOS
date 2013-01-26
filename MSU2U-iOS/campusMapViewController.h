//
//  campusMapViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/22/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface campusMapViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *myMapView;
    MKCoordinateRegion defaultRegion;
    CLLocationCoordinate2D defaultCenter;
    MKCoordinateSpan defaultSpan;
}

@end

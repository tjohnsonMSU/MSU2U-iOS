//
//  campusMapViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/27/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MSULocation.h"
#import "overlay.h"

@interface campusMapViewController : UIViewController<MKMapViewDelegate>{
    NSArray *buildings;
    NSArray *searchResults;
    MKMapView * _campusMap;
    UIColor * _parkingLotColor;
    UIColor * _polylineColor;
}
@property (strong,nonatomic) NSDictionary * buildingList;

@property (strong,nonatomic) NSMutableArray * buildingName;

@property (strong,nonatomic) NSMutableArray * buildingCoordinate;

@property (retain, nonatomic) IBOutlet MKMapView *campusMap;

@end

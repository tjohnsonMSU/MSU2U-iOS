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
#import <AddressBook/AddressBook.h>
#import "campusMapInfoViewController.h"

@interface campusMapViewController : UIViewController<MKMapViewDelegate, UIActionSheetDelegate>{
    NSArray *buildings;
    NSArray *searchResults;
    MKMapView * _campusMap;
    UIColor * _parkingLotColor;
    UIColor * _polylineColor;
    MSULocation * _selectedLocation;
}
@property (strong,nonatomic) NSDictionary * coordinateLookup;

@property (strong,nonatomic) NSMutableArray * buildingName;

@property (strong,nonatomic) NSMutableArray * buildingCoordinate;

@property (retain, nonatomic) IBOutlet MKMapView *campusMap;

@property (strong,nonatomic) NSMutableArray * buildingAddress;

@property (strong,nonatomic) NSDictionary * addressLookup;

@end

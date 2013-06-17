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
    NSMutableArray *searchResults;
    NSArray *tagResults;
    MKMapView * _campusMap;
    UIColor * _parkingLotColor;
    UIColor * _polylineColor;
    MSULocation * _selectedLocation;
    bool buildingInfoPressed;
}
@property (strong,nonatomic) NSDictionary * coordinateLookup;

@property (strong,nonatomic) NSMutableArray * buildingName;

@property (strong,nonatomic) NSMutableArray * buildingImage;

@property (strong,nonatomic) NSMutableArray * buildingInfo;

@property (strong,nonatomic) NSMutableArray * buildingCoordinate;

@property (retain, nonatomic) IBOutlet MKMapView *campusMap;

@property (strong,nonatomic) NSMutableArray * buildingAddress;

@property (strong,nonatomic) NSMutableArray * tag;

@property (strong,nonatomic) NSDictionary * addressLookup;

@property (strong,nonatomic) NSDictionary * tagToBuildingNameLookup;
@property (strong,nonatomic) NSDictionary * buildingNameToInfoLookup;
@property (strong,nonatomic) NSDictionary * buildingNameToImageLookup;

@property (strong,nonatomic) NSArray * keysToSearchOn;

@end

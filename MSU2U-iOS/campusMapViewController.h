//
//  campusMapViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/27/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MSUBuilding.h"

@interface campusMapViewController : UIViewController{
    NSArray *buildings;
    NSArray *searchResults;
}

@property (strong,nonatomic) NSDictionary * buildingList;

@property (strong,nonatomic) NSMutableArray * buildingName;

@property (strong,nonatomic) NSMutableArray * buildingCoordinate;

@property (weak, nonatomic) IBOutlet MKMapView *campusMap;
@end

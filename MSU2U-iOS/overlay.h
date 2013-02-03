//
//  overlay.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/1/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "campusMapViewController.h"

@interface overlay : NSObject{
    MKPolygon *parkingPolygon;
    MKPolyline *route;
}

@property (weak, nonatomic) NSString * name;
-(void)drawCommuterParkingLots:(MKMapView*)mapView;
-(void)drawReservedParkingLots:(MKMapView*)mapView;
-(void)drawResidentialParkingLots:(MKMapView*)mapView;
-(void)drawHybridParkingLots:(MKMapView*)mapView;
-(void)busRoute:(MKMapView*)mapView;
-(void)campusBorder:(MKMapView*)mapView;
@end

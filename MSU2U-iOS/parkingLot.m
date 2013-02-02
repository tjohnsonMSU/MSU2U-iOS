//
//  parkingLot.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/1/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "parkingLot.h"

@implementation parkingLot

-(void)drawCommuterParkingLots:(MKMapView*)mapView
{
    //Moffett Library Parking Lot (Commuters)
    CLLocationCoordinate2D moffettCommuterCoords[9]={
        CLLocationCoordinate2DMake(33.87519,-98.520171),
        CLLocationCoordinate2DMake(33.875228,-98.51927),
        CLLocationCoordinate2DMake(33.875146,-98.519267),
        CLLocationCoordinate2DMake(33.87514,-98.519627),
        CLLocationCoordinate2DMake(33.874403,-98.519645),
        CLLocationCoordinate2DMake(33.874403,-98.519366),
        CLLocationCoordinate2DMake(33.874356,-98.519353),
        CLLocationCoordinate2DMake(33.874359,-98.520155),
        CLLocationCoordinate2DMake(33.87519,-98.520171)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:moffettCommuterCoords count:9];
    [mapView addOverlay:parkingPolygon];
    
    //Bolin Parking Lot (Commuters)
    CLLocationCoordinate2D bolinCommuterCoords[7]={
        CLLocationCoordinate2DMake(33.873431,-98.519726),
        CLLocationCoordinate2DMake(33.873428,-98.519053),
        CLLocationCoordinate2DMake(33.872921,-98.519058),
        CLLocationCoordinate2DMake(33.872943,-98.520176),
        CLLocationCoordinate2DMake(33.873331,-98.520174),
        CLLocationCoordinate2DMake(33.873346,-98.519742),
        CLLocationCoordinate2DMake(33.873431,-98.519726)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bolinCommuterCoords count:7];
    [mapView addOverlay:parkingPolygon];
}

-(void)drawReservedParkingLots:(MKMapView*)mapView
{
    //Bolin Parking Lot 1 (Reserved)
    CLLocationCoordinate2D bolinReserved1Coords[5]={
        CLLocationCoordinate2DMake(33.8742,-98.520176),
        CLLocationCoordinate2DMake(33.874197,-98.519981),
        CLLocationCoordinate2DMake(33.873617,-98.519989),
        CLLocationCoordinate2DMake(33.873633,-98.520182),
        CLLocationCoordinate2DMake(33.8742,-98.520176)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bolinReserved1Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Bolin Parking Lot 2 (Reserved)
    CLLocationCoordinate2D bolinReserved2Coords[5]={
        CLLocationCoordinate2DMake(33.873457,-98.520176),
        CLLocationCoordinate2DMake(33.87345,-98.519728),
        CLLocationCoordinate2DMake(33.873381,-98.519718),
        CLLocationCoordinate2DMake(33.873353,-98.520168),
        CLLocationCoordinate2DMake(33.873457,-98.520176)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bolinReserved2Coords count:5];
    [mapView addOverlay:parkingPolygon];
}

-(void)drawResidentialParkingLots:(MKMapView*)mapView
{
    
}

-(void)drawHybridParkingLots:(MKMapView*)mapView
{
    //Bolin Parking Lot 2 (Reserved)
    CLLocationCoordinate2D practiceFieldsHybridCoords[5]={
        CLLocationCoordinate2DMake(33.872801,-98.522075),
        CLLocationCoordinate2DMake(33.872769,-98.520471),
        CLLocationCoordinate2DMake(33.872451,-98.520471),
        CLLocationCoordinate2DMake(33.872385,-98.520547),
        CLLocationCoordinate2DMake(33.872399,-98.522075)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:practiceFieldsHybridCoords count:5];
    [mapView addOverlay:parkingPolygon];
}
@end

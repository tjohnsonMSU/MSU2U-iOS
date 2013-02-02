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
    CLLocationCoordinate2D moffettCommuterCoords[7]={
        CLLocationCoordinate2DMake(33.874715,-98.520163),
        CLLocationCoordinate2DMake(33.874727,-98.519683),
        CLLocationCoordinate2DMake(33.874425,-98.519648),
        CLLocationCoordinate2DMake(33.874413,-98.519364),
        CLLocationCoordinate2DMake(33.874353,-98.519353),
        CLLocationCoordinate2DMake(33.874346,-98.520168),
        CLLocationCoordinate2DMake(33.874715,-98.520163)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:moffettCommuterCoords count:7];
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
    
    //Prothro Yeager Parking Lot (Commuters)
    CLLocationCoordinate2D prothroYeagerCommuterCoords[5]={
        CLLocationCoordinate2DMake(33.873493,-98.521893),
        CLLocationCoordinate2DMake(33.873456,-98.520858),
        CLLocationCoordinate2DMake(33.872936,-98.520847),
        CLLocationCoordinate2DMake(33.872926,-98.521933),
        CLLocationCoordinate2DMake(33.873493,-98.521893)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:prothroYeagerCommuterCoords count:5];
    [mapView addOverlay:parkingPolygon];
}

-(void)drawReservedParkingLots:(MKMapView*)mapView
{
    //Moffett Library Parking Lot (Reserved)
    CLLocationCoordinate2D moffettReservedCoords[7]={
        CLLocationCoordinate2DMake(33.875228,-98.520171),
        CLLocationCoordinate2DMake(33.875241,-98.519275),
        CLLocationCoordinate2DMake(33.875162,-98.519259),
        CLLocationCoordinate2DMake(33.875143,-98.519629),
        CLLocationCoordinate2DMake(33.874872,-98.519632),
        CLLocationCoordinate2DMake(33.874894,-98.520158),
        CLLocationCoordinate2DMake(33.875228,-98.520171)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:moffettReservedCoords count:7];
    [mapView addOverlay:parkingPolygon];
    
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
    
    //Prothro Yeager Parking Lot 1 (Reserved)
    CLLocationCoordinate2D prothroYeagerReserved1Coords[6]={
        CLLocationCoordinate2DMake(33.873696,-98.521893),
        CLLocationCoordinate2DMake(33.873703,-98.521257),
        CLLocationCoordinate2DMake(33.873614,-98.521204),
        CLLocationCoordinate2DMake(33.873542,-98.521204),
        CLLocationCoordinate2DMake(33.873542,-98.521904),
        CLLocationCoordinate2DMake(33.873696,-98.521893)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:prothroYeagerReserved1Coords count:6];
    [mapView addOverlay:parkingPolygon];
    
    //Prothro Yeager Parking Lot 2 (Reserved)
    CLLocationCoordinate2D prothroYeagerReserved2Coords[6]={
        CLLocationCoordinate2DMake(33.873692,-98.521045),
        CLLocationCoordinate2DMake(33.873701,-98.520391),
        CLLocationCoordinate2DMake(33.873556,-98.520388),
        CLLocationCoordinate2DMake(33.873547,-98.521072),
        CLLocationCoordinate2DMake(33.873635,-98.521083),
        CLLocationCoordinate2DMake(33.873692,-98.521045)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:prothroYeagerReserved2Coords count:6];
    [mapView addOverlay:parkingPolygon];
    
    //Prothro Yeager Parking Lot 3 (Reserved)
    CLLocationCoordinate2D prothroYeagerReserved3Coords[5]={
        CLLocationCoordinate2DMake(33.873506,-98.520831),
        CLLocationCoordinate2DMake(33.8735,-98.520737),
        CLLocationCoordinate2DMake(33.87293,-98.520753),
        CLLocationCoordinate2DMake(33.872939,-98.52086),
        CLLocationCoordinate2DMake(33.873506,-98.520831)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:prothroYeagerReserved3Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Prothro Yeager Parking Lot 4 (Reserved)
    CLLocationCoordinate2D prothroYeagerReserved4Coords[5]={
        CLLocationCoordinate2DMake(33.874218,-98.521937),
        CLLocationCoordinate2DMake(33.874224,-98.521876),
        CLLocationCoordinate2DMake(33.873723,-98.521874),
        CLLocationCoordinate2DMake(33.873729,-98.521937),
        CLLocationCoordinate2DMake(33.874218,-98.521937)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:prothroYeagerReserved4Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Teepee Parking Lot 4 (Reserved)
    CLLocationCoordinate2D teepeeReserved1Coords[5]={
        CLLocationCoordinate2DMake(33.873384,-98.522066),
        CLLocationCoordinate2DMake(33.873402,-98.522015),
        CLLocationCoordinate2DMake(33.873026,-98.522016),
        CLLocationCoordinate2DMake(33.873026,-98.52207),
        CLLocationCoordinate2DMake(33.873384,-98.522066)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:teepeeReserved1Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Teepee Parking Lot 4 (Reserved)
    CLLocationCoordinate2D teepeeReserved4Coords[5]={
        CLLocationCoordinate2DMake(33.873611,-98.522218),
        CLLocationCoordinate2DMake(33.873604,-98.522133),
        CLLocationCoordinate2DMake(33.873541,-98.522134),
        CLLocationCoordinate2DMake(33.873543,-98.522218),
        CLLocationCoordinate2DMake(33.873611,-98.522218)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:teepeeReserved4Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Fain Parking Lot 1 (Reserved)
    CLLocationCoordinate2D fainParking1Coords[5]={
        CLLocationCoordinate2DMake(33.872905,-98.5234),
        CLLocationCoordinate2DMake(33.872896,-98.522312),
        CLLocationCoordinate2DMake(33.872877,-98.522311),
        CLLocationCoordinate2DMake(33.872874,-98.523392),
        CLLocationCoordinate2DMake(33.872905,-98.5234)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:fainParking1Coords count:5];
    [mapView addOverlay:parkingPolygon];
}

-(void)drawResidentialParkingLots:(MKMapView*)mapView
{
    //Teepee Parking Lot (Residential)
    CLLocationCoordinate2D teepeeResidentialCoords[5]={
        CLLocationCoordinate2DMake(33.874362,-98.522066),
        CLLocationCoordinate2DMake(33.874366,-98.521987),
        CLLocationCoordinate2DMake(33.87354,-98.521999),
        CLLocationCoordinate2DMake(33.873541,-98.522065),
        CLLocationCoordinate2DMake(33.874362,-98.522066)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:teepeeResidentialCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Fain Residential Lot (Residential)
    CLLocationCoordinate2D fainResidentialCoords[11]={
        CLLocationCoordinate2DMake(33.875044,-98.523568),
        CLLocationCoordinate2DMake(33.875049,-98.52348),
        CLLocationCoordinate2DMake(33.874992,-98.523457),
        CLLocationCoordinate2DMake(33.874994,-98.522735),
        CLLocationCoordinate2DMake(33.874761,-98.522743),
        CLLocationCoordinate2DMake(33.874687,-98.522833),
        CLLocationCoordinate2DMake(33.87456,-98.522816),
        CLLocationCoordinate2DMake(33.874549,-98.523493),
        CLLocationCoordinate2DMake(33.874683,-98.523529),
        CLLocationCoordinate2DMake(33.874699,-98.523585),
        CLLocationCoordinate2DMake(33.875044,-98.523568)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:fainResidentialCoords count:11];
    [mapView addOverlay:parkingPolygon];
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

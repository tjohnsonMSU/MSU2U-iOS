//
//  parkingLot.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 2/1/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "parkingLot.h"

@implementation parkingLot

//###############################################################
//# COMMUTER LOTS
//###############################################################
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
    
    //Louis Rodriguez New
    CLLocationCoordinate2D louisRodriguezNewCoords[5]={
        CLLocationCoordinate2DMake(33.876994,-98.523559),
        CLLocationCoordinate2DMake(33.87701,-98.52288),
        CLLocationCoordinate2DMake(33.876544,-98.522876),
        CLLocationCoordinate2DMake(33.876536,-98.52356),
        CLLocationCoordinate2DMake(33.876994,-98.523559)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:louisRodriguezNewCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Louis Rodriguez New 2
    CLLocationCoordinate2D louisRodriguezNew2Coords[7]={
        CLLocationCoordinate2DMake(33.877939,-98.524552),
        CLLocationCoordinate2DMake(33.877931,-98.523754),
        CLLocationCoordinate2DMake(33.877786,-98.523744),
        CLLocationCoordinate2DMake(33.877786,-98.524169),
        CLLocationCoordinate2DMake(33.877396,-98.524173),
        CLLocationCoordinate2DMake(33.877394,-98.524583),
        CLLocationCoordinate2DMake(33.877939,-98.524552)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:louisRodriguezNew2Coords count:7];
    [mapView addOverlay:parkingPolygon];
    
    //Dillard Commuter 1
    CLLocationCoordinate2D dillardCommuter1Coords[7]={
        CLLocationCoordinate2DMake(33.877616,-98.521645),
        CLLocationCoordinate2DMake(33.877627,-98.520999),
        CLLocationCoordinate2DMake(33.877499,-98.520994),
        CLLocationCoordinate2DMake(33.87749,-98.521011),
        CLLocationCoordinate2DMake(33.877389,-98.521013),
        CLLocationCoordinate2DMake(33.877363,-98.521654),
        CLLocationCoordinate2DMake(33.877616,-98.521645)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dillardCommuter1Coords count:7];
    [mapView addOverlay:parkingPolygon];
    
    //Dillard Commuter 2 East
    CLLocationCoordinate2D dillardCommuter2eastCoords[9]={
        CLLocationCoordinate2DMake(33.87761,-98.520882),
        CLLocationCoordinate2DMake(33.877611,-98.520446),
        CLLocationCoordinate2DMake(33.877559,-98.520446),
        CLLocationCoordinate2DMake(33.877499,-98.520429),
        CLLocationCoordinate2DMake(33.877381,-98.520431),
        CLLocationCoordinate2DMake(33.877384,-98.520876),
        CLLocationCoordinate2DMake(33.877493,-98.520875),
        CLLocationCoordinate2DMake(33.877516,-98.520887),
        CLLocationCoordinate2DMake(33.87761,-98.520882)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dillardCommuter2eastCoords count:9];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin North
    CLLocationCoordinate2D hardinNorthCoords[12]={
        CLLocationCoordinate2DMake(33.877549,-98.520177),
        CLLocationCoordinate2DMake(33.877544,-98.520097),
        CLLocationCoordinate2DMake(33.877599,-98.519987),
        CLLocationCoordinate2DMake(33.877646,-98.519986),
        CLLocationCoordinate2DMake(33.877649,-98.519436),
        CLLocationCoordinate2DMake(33.877568,-98.519382),
        CLLocationCoordinate2DMake(33.877044,-98.519395),
        CLLocationCoordinate2DMake(33.876939,-98.519414),
        CLLocationCoordinate2DMake(33.876948,-98.519952),
        CLLocationCoordinate2DMake(33.877076,-98.519984),
        CLLocationCoordinate2DMake(33.8771,-98.52018),
        CLLocationCoordinate2DMake(33.877549,-98.520177)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinNorthCoords count:12];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Street Moffett Commuter
    CLLocationCoordinate2D hardinStreetMoffettCoords[5]={
        CLLocationCoordinate2DMake(33.875333,-98.519335),
        CLLocationCoordinate2DMake(33.875335,-98.518767),
        CLLocationCoordinate2DMake(33.87531,-98.518766),
        CLLocationCoordinate2DMake(33.87531,-98.519336),
        CLLocationCoordinate2DMake(33.875333,-98.519335)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinStreetMoffettCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Taft South Commuter
    CLLocationCoordinate2D hardinTaftSouthCoords[5]={
        CLLocationCoordinate2DMake(33.876175,-98.518597),
        CLLocationCoordinate2DMake(33.876204,-98.518562),
        CLLocationCoordinate2DMake(33.875407,-98.518559),
        CLLocationCoordinate2DMake(33.87539,-98.518603),
        CLLocationCoordinate2DMake(33.876175,-98.518597)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinTaftSouthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Taft North Commuter
    CLLocationCoordinate2D hardinTaftNorthCoords[5]={
        CLLocationCoordinate2DMake(33.877515,-98.518589),
        CLLocationCoordinate2DMake(33.87755,-98.518552),
        CLLocationCoordinate2DMake(33.876361,-98.51856),
        CLLocationCoordinate2DMake(33.876333,-98.518597),
        CLLocationCoordinate2DMake(33.877515,-98.518589)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinTaftNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Student Union Street East
    CLLocationCoordinate2D studentUnionStreetEastCoords[5]={
        CLLocationCoordinate2DMake(33.875166,-98.52031),
        CLLocationCoordinate2DMake(33.875165,-98.520284),
        CLLocationCoordinate2DMake(33.87475,-98.520286),
        CLLocationCoordinate2DMake(33.874751,-98.520312),
        CLLocationCoordinate2DMake(33.875166,-98.52031)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:studentUnionStreetEastCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Student Union Street North
    CLLocationCoordinate2D studentUnionStreetNorthCoords[5]={
        CLLocationCoordinate2DMake(33.875273,-98.521872),
        CLLocationCoordinate2DMake(33.875273,-98.520392),
        CLLocationCoordinate2DMake(33.875245,-98.520391),
        CLLocationCoordinate2DMake(33.875241,-98.521868),
        CLLocationCoordinate2DMake(33.875273,-98.521872)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:studentUnionStreetNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Fain
    CLLocationCoordinate2D fainCoords[7]={
        CLLocationCoordinate2DMake(33.875358,-98.521847),
        CLLocationCoordinate2DMake(33.875429,-98.521761),
        CLLocationCoordinate2DMake(33.875429,-98.521471),
        CLLocationCoordinate2DMake(33.875388,-98.521421),
        CLLocationCoordinate2DMake(33.875388,-98.521721),
        CLLocationCoordinate2DMake(33.875355,-98.52176),
        CLLocationCoordinate2DMake(33.875358,-98.521847)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:fainCoords count:7];
    [mapView addOverlay:parkingPolygon];
    
    //Fain West Commuter
    CLLocationCoordinate2D fainWestCommuterCoords[5]={
        CLLocationCoordinate2DMake(33.875683,-98.5219),
        CLLocationCoordinate2DMake(33.875721,-98.521839),
        CLLocationCoordinate2DMake(33.875458,-98.521845),
        CLLocationCoordinate2DMake(33.875412,-98.521896),
        CLLocationCoordinate2DMake(33.875683,-98.5219)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:fainWestCommuterCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Power Plant South
    CLLocationCoordinate2D powerPlantSouthCoords[5]={
        CLLocationCoordinate2DMake(33.872957,-98.52062),
        CLLocationCoordinate2DMake(33.87295,-98.520409),
        CLLocationCoordinate2DMake(33.872896,-98.520408),
        CLLocationCoordinate2DMake(33.872898,-98.520619),
        CLLocationCoordinate2DMake(33.872957,-98.52062)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:powerPlantSouthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street West
    CLLocationCoordinate2D dlLigonStreetWestCoords[5]={
        CLLocationCoordinate2DMake(33.872773,-98.520433),
        CLLocationCoordinate2DMake(33.872772,-98.520388),
        CLLocationCoordinate2DMake(33.870832,-98.520386),
        CLLocationCoordinate2DMake(33.870804,-98.520442),
        CLLocationCoordinate2DMake(33.872773,-98.520433)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetWestCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street South East
    CLLocationCoordinate2D dlLigonStreetSouthEastCoords[5]={
        CLLocationCoordinate2DMake(33.871046,-98.520277),
        CLLocationCoordinate2DMake(33.871078,-98.520227),
        CLLocationCoordinate2DMake(33.870782,-98.520226),
        CLLocationCoordinate2DMake(33.87075,-98.520282),
        CLLocationCoordinate2DMake(33.871046,-98.520277)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetSouthEastCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street North West
    CLLocationCoordinate2D dlLigonStreetNorthWestCoords[5]={
        CLLocationCoordinate2DMake(33.872826,-98.520118),
        CLLocationCoordinate2DMake(33.872834,-98.519123),
        CLLocationCoordinate2DMake(33.87281,-98.519122),
        CLLocationCoordinate2DMake(33.872802,-98.520115),
        CLLocationCoordinate2DMake(33.872826,-98.520118)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetNorthWestCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street North East
    CLLocationCoordinate2D dlLigonStreetNorthEastCoords[5]={
        CLLocationCoordinate2DMake(33.872836,-98.519022),
        CLLocationCoordinate2DMake(33.87282,-98.518684),
        CLLocationCoordinate2DMake(33.872789,-98.518648),
        CLLocationCoordinate2DMake(33.872807,-98.519021),
        CLLocationCoordinate2DMake(33.872836,-98.519022)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetNorthEastCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Soccer Softball
    CLLocationCoordinate2D soccerSoftballSouthCoords[5]={
        CLLocationCoordinate2DMake(33.872426,-98.523716),
        CLLocationCoordinate2DMake(33.872425,-98.523502),
        CLLocationCoordinate2DMake(33.871621,-98.523508),
        CLLocationCoordinate2DMake(33.871614,-98.523717),
        CLLocationCoordinate2DMake(33.872426,-98.523716)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:soccerSoftballSouthCoords count:5];
    [mapView addOverlay:parkingPolygon];
}

//###############################################################
//# RESERVED LOTS
//###############################################################
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
    
    //McCullough Parking Lot(Reserved)
    CLLocationCoordinate2D mcCulloughCoords[5]={
        CLLocationCoordinate2DMake(33.875254,-98.522779),
        CLLocationCoordinate2DMake(33.875254,-98.522711),
        CLLocationCoordinate2DMake(33.875063,-98.52271),
        CLLocationCoordinate2DMake(33.875065,-98.522784),
        CLLocationCoordinate2DMake(33.875254,-98.522779)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:mcCulloughCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Paint Building Lot(Reserved)
    CLLocationCoordinate2D paintBuildingCoords[5]={
        CLLocationCoordinate2DMake(33.876533,-98.523556),
        CLLocationCoordinate2DMake(33.876532,-98.522873),
        CLLocationCoordinate2DMake(33.876406,-98.522873),
        CLLocationCoordinate2DMake(33.876388,-98.523556),
        CLLocationCoordinate2DMake(33.876533,-98.523556)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:paintBuildingCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Police Lot(Reserved)
    CLLocationCoordinate2D policeCoords[9]={
        CLLocationCoordinate2DMake(33.877546,-98.524029),
        CLLocationCoordinate2DMake(33.877542,-98.523781),
        CLLocationCoordinate2DMake(33.877386,-98.523781),
        CLLocationCoordinate2DMake(33.877384,-98.52405),
        CLLocationCoordinate2DMake(33.877428,-98.524047),
        CLLocationCoordinate2DMake(33.877433,-98.524077),
        CLLocationCoordinate2DMake(33.877499,-98.524078),
        CLLocationCoordinate2DMake(33.877498,-98.524025),
        CLLocationCoordinate2DMake(33.877546,-98.524029)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:policeCoords count:9];
    [mapView addOverlay:parkingPolygon];
    
    //Bridwell 0
    CLLocationCoordinate2D bridwell0Coords[5]={
        CLLocationCoordinate2DMake(33.87785,-98.522928),
        CLLocationCoordinate2DMake(33.877851,-98.522872),
        CLLocationCoordinate2DMake(33.877703,-98.522873),
        CLLocationCoordinate2DMake(33.877705,-98.522932),
        CLLocationCoordinate2DMake(33.87785,-98.522928)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bridwell0Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Bridwell 1
    CLLocationCoordinate2D bridwell1Coords[5]={
        CLLocationCoordinate2DMake(33.877651,-98.52293),
        CLLocationCoordinate2DMake(33.877654,-98.522877),
        CLLocationCoordinate2DMake(33.877475,-98.52288),
        CLLocationCoordinate2DMake(33.877484,-98.522934),
        CLLocationCoordinate2DMake(33.877651,-98.52293)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bridwell1Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Bridwell 2
    CLLocationCoordinate2D bridwell2Coords[5]={
        CLLocationCoordinate2DMake(33.877848,-98.522794),
        CLLocationCoordinate2DMake(33.877859,-98.522735),
        CLLocationCoordinate2DMake(33.877541,-98.522714),
        CLLocationCoordinate2DMake(33.877531,-98.522788),
        CLLocationCoordinate2DMake(33.877848,-98.522794)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bridwell2Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Bridwell 3
    CLLocationCoordinate2D bridwell3Coords[5]={
        CLLocationCoordinate2DMake(33.877373,-98.522798),
        CLLocationCoordinate2DMake(33.877373,-98.522737),
        CLLocationCoordinate2DMake(33.877139,-98.522742),
        CLLocationCoordinate2DMake(33.877134,-98.522793),
        CLLocationCoordinate2DMake(33.877373,-98.522798)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bridwell3Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Dillard
    CLLocationCoordinate2D dillard1Coords[10]={
        CLLocationCoordinate2DMake(33.877612,-98.521795),
        CLLocationCoordinate2DMake(33.877616,-98.521645),
        CLLocationCoordinate2DMake(33.877363,-98.521654),
        CLLocationCoordinate2DMake(33.877356,-98.521066),
        CLLocationCoordinate2DMake(33.877267,-98.521072),
        CLLocationCoordinate2DMake(33.877276,-98.521217),
        CLLocationCoordinate2DMake(33.877204,-98.52122),
        CLLocationCoordinate2DMake(33.877207,-98.521499),
        CLLocationCoordinate2DMake(33.877213,-98.52181),
        CLLocationCoordinate2DMake(33.877612,-98.521795)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dillard1Coords count:10];
    [mapView addOverlay:parkingPolygon];
    
    //Dillard 2 Coords (West South)
    CLLocationCoordinate2D dillard2Coords[5]={
        CLLocationCoordinate2DMake(33.877158,-98.521792),
        CLLocationCoordinate2DMake(33.87716,-98.521504),
        CLLocationCoordinate2DMake(33.877107,-98.521504),
        CLLocationCoordinate2DMake(33.877099,-98.52179),
        CLLocationCoordinate2DMake(33.877158,-98.521792)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dillard2Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Dillard 3 Coords (East South)
    CLLocationCoordinate2D dillard3Coords[11]={
        CLLocationCoordinate2DMake(33.877331,-98.520815),
        CLLocationCoordinate2DMake(33.877329,-98.520433),
        CLLocationCoordinate2DMake(33.877151,-98.520432),
        CLLocationCoordinate2DMake(33.877154,-98.520354),
        CLLocationCoordinate2DMake(33.877092,-98.520354),
        CLLocationCoordinate2DMake(33.877095,-98.520582),
        CLLocationCoordinate2DMake(33.877201,-98.520585),
        CLLocationCoordinate2DMake(33.877204,-98.520669),
        CLLocationCoordinate2DMake(33.877273,-98.520671),
        CLLocationCoordinate2DMake(33.877278,-98.520815),
        CLLocationCoordinate2DMake(33.877331,-98.520815)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dillard3Coords count:11];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Administration Building (Reserved)
    CLLocationCoordinate2D hardinReservedCoords[12]={
        CLLocationCoordinate2DMake(33.876984,-98.520181),
        CLLocationCoordinate2DMake(33.876985,-98.52001),
        CLLocationCoordinate2DMake(33.876309,-98.520013),
        CLLocationCoordinate2DMake(33.876281,-98.520064),
        CLLocationCoordinate2DMake(33.87622,-98.520068),
        CLLocationCoordinate2DMake(33.876251,-98.520012),
        CLLocationCoordinate2DMake(33.876034,-98.520013),
        CLLocationCoordinate2DMake(33.875917,-98.52009),
        CLLocationCoordinate2DMake(33.875916,-98.520144),
        CLLocationCoordinate2DMake(33.876051,-98.520143),
        CLLocationCoordinate2DMake(33.876098,-98.520189),
        CLLocationCoordinate2DMake(33.876984,-98.520181)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinReservedCoords count:12];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Street Plaza 1 North (Reserved)
    CLLocationCoordinate2D hardinStreetPlaza1Coords[5]={
        CLLocationCoordinate2DMake(33.876894,-98.520301),
        CLLocationCoordinate2DMake(33.876895,-98.520272),
        CLLocationCoordinate2DMake(33.876251,-98.520274),
        CLLocationCoordinate2DMake(33.87625,-98.520304),
        CLLocationCoordinate2DMake(33.876894,-98.520301)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinStreetPlaza1Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Street Plaza 2 Middle (Reserved)
    CLLocationCoordinate2D hardinStreetPlaza2Coords[5]={
        CLLocationCoordinate2DMake(33.876115,-98.520304),
        CLLocationCoordinate2DMake(33.876115,-98.520277),
        CLLocationCoordinate2DMake(33.875663,-98.52028),
        CLLocationCoordinate2DMake(33.875662,-98.520306),
        CLLocationCoordinate2DMake(33.876115,-98.520304)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinStreetPlaza2Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Street Plaza 3 South(Reserved)
    CLLocationCoordinate2D hardinStreetPlaza3Coords[5]={
        CLLocationCoordinate2DMake(33.87559,-98.520307),
        CLLocationCoordinate2DMake(33.875588,-98.520281),
        CLLocationCoordinate2DMake(33.875473,-98.520282),
        CLLocationCoordinate2DMake(33.875474,-98.52031),
        CLLocationCoordinate2DMake(33.87559,-98.520307)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinStreetPlaza3Coords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Street Moffett West (Reserved)
    CLLocationCoordinate2D hardinStreetMoffettWestCoords[5]={
        CLLocationCoordinate2DMake(33.875338,-98.520103),
        CLLocationCoordinate2DMake(33.875335,-98.519838),
        CLLocationCoordinate2DMake(33.875312,-98.519838),
        CLLocationCoordinate2DMake(33.875312,-98.520103),
        CLLocationCoordinate2DMake(33.875338,-98.520103)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinStreetMoffettWestCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Hardin Street Moffett East (Reserved)
    CLLocationCoordinate2D hardinStreetMoffettEastCoords[5]={
        CLLocationCoordinate2DMake(33.875337,-98.519752),
        CLLocationCoordinate2DMake(33.875335,-98.519399),
        CLLocationCoordinate2DMake(33.875311,-98.519399),
        CLLocationCoordinate2DMake(33.875311,-98.519749),
        CLLocationCoordinate2DMake(33.875337,-98.519752)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:hardinStreetMoffettEastCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Bolin Street Reserved
    CLLocationCoordinate2D bolinStreetReservedCoords[5]={
        CLLocationCoordinate2DMake(33.874181,-98.520318),
        CLLocationCoordinate2DMake(33.874179,-98.520288),
        CLLocationCoordinate2DMake(33.873757,-98.520286),
        CLLocationCoordinate2DMake(33.873757,-98.520317),
        CLLocationCoordinate2DMake(33.874181,-98.520318)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bolinStreetReservedCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Fain West Reserved
    CLLocationCoordinate2D fainWestReservedCoords[16]={
        CLLocationCoordinate2DMake(33.875974,-98.521891),
        CLLocationCoordinate2DMake(33.875988,-98.521872),
        CLLocationCoordinate2DMake(33.875956,-98.521838),
        CLLocationCoordinate2DMake(33.875733,-98.52184),
        CLLocationCoordinate2DMake(33.875681,-98.521924),
        CLLocationCoordinate2DMake(33.875411,-98.521935),
        CLLocationCoordinate2DMake(33.875469,-98.522014),
        CLLocationCoordinate2DMake(33.875556,-98.522014),
        CLLocationCoordinate2DMake(33.87561,-98.5221),
        CLLocationCoordinate2DMake(33.876033,-98.522098),
        CLLocationCoordinate2DMake(33.876046,-98.522042),
        CLLocationCoordinate2DMake(33.876088,-98.522079),
        CLLocationCoordinate2DMake(33.876103,-98.522055),
        CLLocationCoordinate2DMake(33.876103,-98.521939),
        CLLocationCoordinate2DMake(33.876056,-98.52189),
        CLLocationCoordinate2DMake(33.875974,-98.521891)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:fainWestReservedCoords count:16];
    [mapView addOverlay:parkingPolygon];
    
    //Daniel Building South
    CLLocationCoordinate2D danielBuildingSouthCoords[11]={
        CLLocationCoordinate2DMake(33.875494,-98.522611),
        CLLocationCoordinate2DMake(33.875547,-98.522555),
        CLLocationCoordinate2DMake(33.875548,-98.52224),
        CLLocationCoordinate2DMake(33.875527,-98.522217),
        CLLocationCoordinate2DMake(33.875503,-98.52224),
        CLLocationCoordinate2DMake(33.875435,-98.522236),
        CLLocationCoordinate2DMake(33.875412,-98.522209),
        CLLocationCoordinate2DMake(33.875393,-98.522232),
        CLLocationCoordinate2DMake(33.875394,-98.52254),
        CLLocationCoordinate2DMake(33.875446,-98.522596),
        CLLocationCoordinate2DMake(33.875494,-98.522611)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:danielBuildingSouthCoords count:11];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street East Middle
    CLLocationCoordinate2D dlLigonStreetEastMiddleCoords[5]={
        CLLocationCoordinate2DMake(33.87176,-98.520273),
        CLLocationCoordinate2DMake(33.871783,-98.520223),
        CLLocationCoordinate2DMake(33.871081,-98.520226),
        CLLocationCoordinate2DMake(33.871047,-98.520278),
        CLLocationCoordinate2DMake(33.871753,-98.520274)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetEastMiddleCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street East Middle
    CLLocationCoordinate2D dlLigonStreetEastNorthCoords[5]={
        CLLocationCoordinate2DMake(33.872549,-98.52027),
        CLLocationCoordinate2DMake(33.872552,-98.520219),
        CLLocationCoordinate2DMake(33.87194,-98.520221),
        CLLocationCoordinate2DMake(33.871908,-98.520274),
        CLLocationCoordinate2DMake(33.872549,-98.52027)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetEastNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //DL Ligon Street North
    CLLocationCoordinate2D dlLigonStreetNorthCoords[5]={
        CLLocationCoordinate2DMake(33.872834,-98.519123),
        CLLocationCoordinate2DMake(33.872836,-98.519022),
        CLLocationCoordinate2DMake(33.872807,-98.519021),
        CLLocationCoordinate2DMake(33.87281,-98.519122),
        CLLocationCoordinate2DMake(33.872834,-98.519123)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:dlLigonStreetNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Soccer Softball North
    CLLocationCoordinate2D soccerSoftballNorthCoords[5]={
        CLLocationCoordinate2DMake(33.872615,-98.523702),
        CLLocationCoordinate2DMake(33.872654,-98.523493),
        CLLocationCoordinate2DMake(33.872425,-98.523502),
        CLLocationCoordinate2DMake(33.872426,-98.523716),
        CLLocationCoordinate2DMake(33.872615,-98.523702)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:soccerSoftballNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Wellness Center North
    CLLocationCoordinate2D wellnessCenterNorthCoords[5]={
        CLLocationCoordinate2DMake(33.870006,-98.523093),
        CLLocationCoordinate2DMake(33.870005,-98.523033),
        CLLocationCoordinate2DMake(33.869877,-98.523034),
        CLLocationCoordinate2DMake(33.869881,-98.52309),
        CLLocationCoordinate2DMake(33.870006,-98.523093)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:wellnessCenterNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Wellness Center South
    CLLocationCoordinate2D wellnessCenterSouthCoords[5]={
        CLLocationCoordinate2DMake(33.86982,-98.523091),
        CLLocationCoordinate2DMake(33.869819,-98.523034),
        CLLocationCoordinate2DMake(33.869538,-98.523029),
        CLLocationCoordinate2DMake(33.869544,-98.523087),
        CLLocationCoordinate2DMake(33.86982,-98.523091)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:wellnessCenterSouthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Sundancer North
    CLLocationCoordinate2D sundancerNorthCoords[5]={
        CLLocationCoordinate2DMake(33.871216,-98.525003),
        CLLocationCoordinate2DMake(33.871219,-98.52495),
        CLLocationCoordinate2DMake(33.87114,-98.524948),
        CLLocationCoordinate2DMake(33.871142,-98.52501),
        CLLocationCoordinate2DMake(33.871216,-98.525003)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:sundancerNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Sundancer South
    CLLocationCoordinate2D sundancerSouthCoords[5]={
        CLLocationCoordinate2DMake(33.870874,-98.525012),
        CLLocationCoordinate2DMake(33.870872,-98.524955),
        CLLocationCoordinate2DMake(33.870798,-98.524951),
        CLLocationCoordinate2DMake(33.870797,-98.525013),
        CLLocationCoordinate2DMake(33.870874,-98.525012)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:sundancerSouthCoords count:5];
    [mapView addOverlay:parkingPolygon];
}

//###############################################################
//# RESIDENTIAL LOTS
//###############################################################

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
    
    //Fain Residential Lot (Residential)
    CLLocationCoordinate2D fainResidential2Coords[9]={
        CLLocationCoordinate2DMake(33.874464,-98.523501),
        CLLocationCoordinate2DMake(33.874472,-98.522868),
        CLLocationCoordinate2DMake(33.874313,-98.522852),
        CLLocationCoordinate2DMake(33.874297,-98.522755),
        CLLocationCoordinate2DMake(33.874067,-98.522745),
        CLLocationCoordinate2DMake(33.874062,-98.522822),
        CLLocationCoordinate2DMake(33.874007,-98.522825),
        CLLocationCoordinate2DMake(33.874013,-98.5235),
        CLLocationCoordinate2DMake(33.874464,-98.523501)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:fainResidential2Coords count:9];
    [mapView addOverlay:parkingPolygon];
    
    //Fain Residential Lot (Residential)
    CLLocationCoordinate2D sunWatcherCoords[17]={
        CLLocationCoordinate2DMake(33.875348,-98.524573),
        CLLocationCoordinate2DMake(33.87536,-98.523785),
        CLLocationCoordinate2DMake(33.875204,-98.523784),
        CLLocationCoordinate2DMake(33.875207,-98.524244),
        CLLocationCoordinate2DMake(33.875003,-98.524237),
        CLLocationCoordinate2DMake(33.875012,-98.524438),
        CLLocationCoordinate2DMake(33.873937,-98.524446),
        CLLocationCoordinate2DMake(33.873926,-98.524256),
        CLLocationCoordinate2DMake(33.873723,-98.524247),
        CLLocationCoordinate2DMake(33.87372,-98.523828),
        CLLocationCoordinate2DMake(33.873547,-98.52382),
        CLLocationCoordinate2DMake(33.87355,-98.524523),
        CLLocationCoordinate2DMake(33.873614,-98.524526),
        CLLocationCoordinate2DMake(33.87362,-98.524641),
        CLLocationCoordinate2DMake(33.875251,-98.524636),
        CLLocationCoordinate2DMake(33.875256,-98.524571),
        CLLocationCoordinate2DMake(33.875348,-98.524573)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:sunWatcherCoords count:17];
    [mapView addOverlay:parkingPolygon];
    
    //Bridwell Courts (Residential)
    CLLocationCoordinate2D bridwellCourtsCoords[13]={
        CLLocationCoordinate2DMake(33.877349,-98.524567),
        CLLocationCoordinate2DMake(33.877343,-98.523808),
        CLLocationCoordinate2DMake(33.877299,-98.523805),
        CLLocationCoordinate2DMake(33.877307,-98.524365),
        CLLocationCoordinate2DMake(33.877217,-98.524365),
        CLLocationCoordinate2DMake(33.877215,-98.524434),
        CLLocationCoordinate2DMake(33.877084,-98.524436),
        CLLocationCoordinate2DMake(33.87708,-98.524366),
        CLLocationCoordinate2DMake(33.876974,-98.524362),
        CLLocationCoordinate2DMake(33.876979,-98.523815),
        CLLocationCoordinate2DMake(33.876892,-98.523809),
        CLLocationCoordinate2DMake(33.876907,-98.524547),
        CLLocationCoordinate2DMake(33.877349,-98.524567)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:bridwellCourtsCoords count:13];
    [mapView addOverlay:parkingPolygon];
    
    //Sunwatcher Street North
    CLLocationCoordinate2D sunwatcherStreetNorthCoords[5]={
        CLLocationCoordinate2DMake(33.874694,-98.523767),
        CLLocationCoordinate2DMake(33.874716,-98.523739),
        CLLocationCoordinate2DMake(33.874513,-98.523738),
        CLLocationCoordinate2DMake(33.874516,-98.523769),
        CLLocationCoordinate2DMake(33.874694,-98.523767)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:sunwatcherStreetNorthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Sunwatcher Street South
    CLLocationCoordinate2D sunwatcherStreetSouthCoords[5]={
        CLLocationCoordinate2DMake(33.874418,-98.523769),
        CLLocationCoordinate2DMake(33.874418,-98.523741),
        CLLocationCoordinate2DMake(33.874186,-98.52374),
        CLLocationCoordinate2DMake(33.874184,-98.523771),
        CLLocationCoordinate2DMake(33.874418,-98.523769)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:sunwatcherStreetSouthCoords count:5];
    [mapView addOverlay:parkingPolygon];
    
    //Sundance Court
    CLLocationCoordinate2D sundanceCourtCoords[44]={
        CLLocationCoordinate2DMake(33.871006,-98.526123),
        CLLocationCoordinate2DMake(33.871196,-98.525611),
        CLLocationCoordinate2DMake(33.871155,-98.525586),
        CLLocationCoordinate2DMake(33.871172,-98.525552),
        CLLocationCoordinate2DMake(33.871212,-98.525584),
        CLLocationCoordinate2DMake(33.871308,-98.525424),
        CLLocationCoordinate2DMake(33.87127,-98.525388),
        CLLocationCoordinate2DMake(33.871289,-98.525357),
        CLLocationCoordinate2DMake(33.871334,-98.525358),
        CLLocationCoordinate2DMake(33.871335,-98.525158),
        CLLocationCoordinate2DMake(33.871286,-98.525155),
        CLLocationCoordinate2DMake(33.871286,-98.525088),
        CLLocationCoordinate2DMake(33.871388,-98.525088),
        CLLocationCoordinate2DMake(33.871438,-98.525145),
        CLLocationCoordinate2DMake(33.871482,-98.525082),
        CLLocationCoordinate2DMake(33.871544,-98.525033),
        CLLocationCoordinate2DMake(33.871712,-98.524758),
        CLLocationCoordinate2DMake(33.871724,-98.524657),
        CLLocationCoordinate2DMake(33.871776,-98.524653),
        CLLocationCoordinate2DMake(33.871771,-98.523972),
        CLLocationCoordinate2DMake(33.871608,-98.52397),
        CLLocationCoordinate2DMake(33.87166,-98.524709),
        CLLocationCoordinate2DMake(33.871483,-98.525006),
        CLLocationCoordinate2DMake(33.871434,-98.525007),
        CLLocationCoordinate2DMake(33.87144,-98.524929),
        CLLocationCoordinate2DMake(33.871219,-98.52495),//1
        CLLocationCoordinate2DMake(33.871216,-98.525003),//
        CLLocationCoordinate2DMake(33.871142,-98.52501),//
        CLLocationCoordinate2DMake(33.87114,-98.524948),//
        CLLocationCoordinate2DMake(33.870872,-98.524955),//2
        CLLocationCoordinate2DMake(33.870874,-98.525012),//
        CLLocationCoordinate2DMake(33.870797,-98.525013),//
        CLLocationCoordinate2DMake(33.870798,-98.524951),//
        CLLocationCoordinate2DMake(33.870752,-98.525012),
        CLLocationCoordinate2DMake(33.870724,-98.525014),
        CLLocationCoordinate2DMake(33.870729,-98.525119),
        CLLocationCoordinate2DMake(33.870683,-98.52512),
        CLLocationCoordinate2DMake(33.870682,-98.526101),
        CLLocationCoordinate2DMake(33.870741,-98.526101),
        CLLocationCoordinate2DMake(33.870742,-98.526167),
        CLLocationCoordinate2DMake(33.870939,-98.526166),
        CLLocationCoordinate2DMake(33.87094,-98.526105),
        CLLocationCoordinate2DMake(33.870961,-98.526098),
        CLLocationCoordinate2DMake(33.871006,-98.526123)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:sundanceCourtCoords count:44];
    [mapView addOverlay:parkingPolygon];
}

//###############################################################
//# HYBRID LOTS
//###############################################################
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
    
    //Church1 Louis Rodriguez Drive
    CLLocationCoordinate2D church1Coords[7]={
        CLLocationCoordinate2DMake(33.873521,-98.52512),
        CLLocationCoordinate2DMake(33.873529,-98.524349),
        CLLocationCoordinate2DMake(33.873479,-98.52435),
        CLLocationCoordinate2DMake(33.873463,-98.524715),
        CLLocationCoordinate2DMake(33.873369,-98.524716),
        CLLocationCoordinate2DMake(33.873372,-98.525124),
        CLLocationCoordinate2DMake(33.873521,-98.52512)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:church1Coords count:7];
    [mapView addOverlay:parkingPolygon];
    
    //Louis Rodriguez Drive Hybrid
    CLLocationCoordinate2D louisRodiguezCoords[5]={
        CLLocationCoordinate2DMake(33.876498,-98.524306),
        CLLocationCoordinate2DMake(33.876503,-98.523775),
        CLLocationCoordinate2DMake(33.875786,-98.523765),
        CLLocationCoordinate2DMake(33.875796,-98.524315),
        CLLocationCoordinate2DMake(33.876498,-98.524306)
    };
    parkingPolygon=[MKPolygon polygonWithCoordinates:louisRodiguezCoords count:5];
    [mapView addOverlay:parkingPolygon];
}
@end

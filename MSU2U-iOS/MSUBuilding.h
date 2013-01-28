//
//  MSUBuilding.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/28/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MSUBuilding : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (MKMapItem*)mapItem;

@end

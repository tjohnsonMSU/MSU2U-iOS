//
//  MSUBuilding.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/28/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MSULocation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * countryKey;
@property (nonatomic, copy) NSString * addressCityKey;
@property (nonatomic, copy) NSString * addressStateKey;
@property (nonatomic, copy) NSString * addressStreetKey;
@property (nonatomic, copy) NSString * addressZIPKey;
@property (nonatomic, copy) NSString * phoneNumber;
@property (nonatomic, copy) NSString * addressUrl;
@property (nonatomic, copy) NSString * description;
@property (nonatomic, copy) NSString * imageUrl;

- (MKMapItem*)mapItem;

@end

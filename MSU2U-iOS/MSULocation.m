//
//  MSUBuilding.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/28/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "MSULocation.h"
#import <AddressBook/AddressBook.h>

@implementation MSULocation

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{
                                  (NSString*)kABPersonAddressCountryKey : self.countryKey,
                                  (NSString*)kABPersonAddressCityKey : self.addressCityKey,
                                  (NSString*)kABPersonAddressStreetKey : self.addressStreetKey,
                                  (NSString*)kABPersonAddressZIPKey : self.addressZIPKey};
    // 2
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    // 3
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    mapItem.phoneNumber = self.phoneNumber;
    mapItem.url = [NSURL URLWithString:self.addressUrl];
    
    return mapItem;
}

@end
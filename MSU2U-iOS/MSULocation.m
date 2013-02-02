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
    // 1
    NSDictionary *addressDict = @{
                                  (NSString*)kABPersonAddressCountryKey : @"UK",
                                  (NSString*)kABPersonAddressCityKey : @"London",
                                  (NSString*)kABPersonAddressStreetKey : @"10 Downing Street",
                                  (NSString*)kABPersonAddressZIPKey : @"SW1A 2AA"};
    
    // 2
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    // 3
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    mapItem.phoneNumber = @"+44-20-8123-4567";
    mapItem.url = [NSURL URLWithString:@"http://www.raywenderlich.com/"];
    
    return mapItem;
}


@end

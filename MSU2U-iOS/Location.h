//
//  Entity.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/29/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end

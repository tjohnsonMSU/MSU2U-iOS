//
//  Location+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/29/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Location.h"

@interface Location (Create)
+(Location *)locationWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
@end

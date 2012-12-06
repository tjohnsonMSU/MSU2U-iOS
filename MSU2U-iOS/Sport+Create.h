//
//  Sport+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "Sport.h"

@interface Sport (Create)
+(Sport *)sportWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
@end

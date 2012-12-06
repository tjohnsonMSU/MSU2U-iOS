//
//  Event+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "Event.h"

@interface Event (Create)
+(Event *)eventWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
@end

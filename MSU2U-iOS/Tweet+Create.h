//
//  Tweet+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/11/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Tweet.h"

@interface Tweet (Create)
+(Tweet *)tweetWithInfo:(NSDictionary*)info isProfile:(BOOL)isProfile inManagedObjectContext:(NSManagedObjectContext*)context;
@end

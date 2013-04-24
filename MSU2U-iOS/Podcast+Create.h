//
//  Podcast+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/23/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Podcast.h"

@interface Podcast (Create)
+(Podcast *)podcastWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
@end

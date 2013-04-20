//
//  Video+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/19/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Video.h"

@interface Video (Create)
+(Video *)videoWithInfo:(NSDictionary*)info isVimeo:(BOOL)isVimeo inManagedObjectContext:(NSManagedObjectContext*)context;
@end

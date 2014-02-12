//
//  Game+Create.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 5/6/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Game.h"

@interface Game (Create)
+(Game *)gameWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context;
@end

//
//  Location+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 1/29/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Location+Create.h"

@implementation Location (Create)
+(Location *)locationWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Location * location = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [info objectForKey:@"name"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * allLocations = [context executeFetchRequest:request error:&error];
    
    if(!allLocations || ([allLocations count] > 1))
    {
        //handle error
    }
    else if(![allLocations count])
    {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        
        location.name = [info objectForKey:@"name"];
        location.longitude = [info objectForKey:@"longitude"];
        location.latitude = [info objectForKey:@"latitude"];
    }
    else
    {
        location = [allLocations lastObject];
    }
    
    return location;
}
@end

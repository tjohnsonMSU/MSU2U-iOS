//
//  Event+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "Event+Create.h"

@implementation Event (Create)
+(Event *)eventWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Event * event = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", [info objectForKey:@"title"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * events = [context executeFetchRequest:request error:&error];
    
    if(!events || ([events count] > 1))
    {
        //handle error
    }
    else if(![events count])
    {
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        
        event.startDate = [info objectForKey:@"StartTime"];
        event.title = [info objectForKey:@"title"];
        event.content = [info objectForKey:@"description"];
        event.link = [info objectForKey:@"link"];
        event.evgameid = [info objectForKey:@"evgameid"];
        event.evlocation = [info objectForKey:@"evlocation"];
        event.startDate = [info objectForKey:@"StartDate"];
        event.endDate = [info objectForKey:@"EndDate"];
        event.category = [info objectForKey:@"category"];
    }
    else
    {
        event = [events lastObject];
    }
    
    return event;
}
@end

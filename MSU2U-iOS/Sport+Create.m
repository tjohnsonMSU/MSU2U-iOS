//
//  Sport+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "Sport+Create.h"

@implementation Sport (Create)
+(Sport *)sportWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Sport * sport = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Sport"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", [info objectForKey:@"title"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * sports = [context executeFetchRequest:request error:&error];
    
    if(!sports || ([sports count] > 1))
    {
        //handle error
        NSLog(@"Error in sportWithInfo!!!\n");
    }
    else if(![sports count])
    {
        sport = [NSEntityDescription insertNewObjectForEntityForName:@"Sport" inManagedObjectContext:context];
        
        sport.title = [info objectForKey:@"title"];
        sport.content = [info objectForKey:@"content"];
        sport.link = [info objectForKey:@"link"];
        sport.evgameid = [info objectForKey:@"evgameid"];
        sport.evlocation = [info objectForKey:@"evlocation"];
        sport.startDate = [info objectForKey:@"StartDate"];
        sport.startTime = [info objectForKey:@"StartTime"];
        sport.endDate = [info objectForKey:@"EndDate"];
        sport.steamlogo = [info objectForKey:@"steamlogo"];
        sport.sopponentlogo = [info objectForKey:@"sopponentlogo"];
        sport.sportType = [info objectForKey:@"sportType"];
        sport.homeTeam = [info objectForKey:@"homeTeam"];
        sport.awayTeam = [info objectForKey:@"awayTeam"];
    }
    else
    {
        sport = [sports lastObject];
    }
    
    return sport;
}
@end

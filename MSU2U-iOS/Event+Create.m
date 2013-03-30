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
    request.predicate = [NSPredicate predicateWithFormat:@"gameid = %@", [info objectForKey:@"gameid"]];
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
        
        event.title = [info objectForKey:@"title"];
        event.desc = [info objectForKey:@"description"];
        event.link = [info objectForKey:@"link"];
        event.teamlogo = [info objectForKey:@"teamlogo"];
        event.opponentlogo = [info objectForKey:@"opponentlogo"];
        event.location = [info objectForKey:@"location"];
        
        //Setup the dates
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        //           Sample Time:      2013-05-23T17:00:00.0000000
        [dateFormatter setDateFormat: @"Y-MM-ddTHH:mm:ss.SSSSSSS"];
        
        event.startdate = [dateFormatter dateFromString:[info objectForKey:@"startdate"]];
        event.enddate = [dateFormatter dateFromString:[info objectForKey:@"enddate"]];
        
        //OK, so I'd like to know what kind of sport this is. msuMustangs.com won't say in their RSS, but I can find out by looking in the title.
        NSArray * sportCategories = [[NSArray alloc]initWithObjects:@"Men's Cross Country/Track",@"Women's Cross Country/Track",@"Men's Basketball",@"Women's Basketball",@"Football",@"Men's Golf",@"Women's Golf",@"Men's Soccer",@"Women's Soccer",@"Softball",@"Men's Tennis",@"Women's Tennis",@"Volleyball", nil];
        int found = 0;
        for(int i=0; i<[sportCategories count]; i++)
        {
            //If I find my current sport category in the title string, then set my event category equal to the sport category that was found in the title string and break
            if([event.title rangeOfString:[sportCategories objectAtIndex:i]].location != NSNotFound)
            {
                event.category = [sportCategories objectAtIndex:i];
                found = 1;
                break;
            }
        }
        if(found == 0)
        {
            NSLog(@"#### I couldn't figure out what sport category thish person belonged to! Title: %@\n",event.title);
            event.category = @"NCAA";
        }
        
        NSLog(@"!@#!@#!@#!@# %@\n",event.title);
    }
    else
    {
        event = [events lastObject];
    }
    
    return event;
}
@end

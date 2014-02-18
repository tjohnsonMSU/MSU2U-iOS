//
//  Game+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 5/6/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Game+Create.h"

@implementation Game (Create)
+(Game *)gameWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Game * game = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Game"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", [info objectForKey:@"title"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * games = [context executeFetchRequest:request error:&error];
    
    if(!games || ([games count] > 1))
    {
        //handle error
    }
    else if(![games count])
    {
        //Never seen this event before, add it to my list
        game = [self createNewGame:info inContext:context];
    }
    else
    {
        //I already have this event, but I need to make sure nothing has changed
        game = [games lastObject];
    }
    
    return game;
}

+(Game*)createNewGame:(NSDictionary*)info inContext:(NSManagedObjectContext*)context
{
    Game * game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" inManagedObjectContext:context];
    
    game.title = [info objectForKey:@"title"];
    game.desc = [info objectForKey:@"description"];
    game.link = [info objectForKey:@"link"];
    //NSLog(@"MSU logo is at %@\n",[info objectForKey:@"teamlogo"]);
    game.teamlogo = [info objectForKey:@"teamlogo"];
    game.opponentlogo = [info objectForKey:@"opponentlogo"];
    game.location = [info objectForKey:@"location"];
    
    //Figure out if this is a home game or not
    if([game.location isEqualToString:@"Wichita Falls, TX"] || [game.location isEqualToString:@"Wichita Falls, Texas"] || [game.location isEqualToString:@"Wichita Falls"])
    {
        game.isHomeGame = @"yes";
    }
    else
    {
        game.isHomeGame = @"no";
    }
    
    //Setup the dates
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //[dateFormatter setLocale:usLocale];
    NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:cst];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    //           Sample Time:      2013-05-23T17:00:00.0000000
    //[dateFormatter setDateFormat: @"y-MM-ddTHH:mm:ss.SSSSSSS"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSArray * array1 = [[[info objectForKey:@"startdate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] componentsSeparatedByString:@"."];
    NSArray * array2 = [[[info objectForKey:@"enddate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] componentsSeparatedByString:@"."];
    
    game.startdate = [dateFormatter dateFromString:[array1 objectAtIndex:0]];
    game.enddate = [dateFormatter dateFromString:[array2 objectAtIndex:0]];
    NSLog(@"%@ %@\n",game.startdate,game.enddate);
    
    //OK, so I'd like to know what kind of sport this is. msuMustangs.com won't say in their RSS, but I can find out by looking in the title.
    NSArray * sportCategories = [[NSArray alloc]initWithObjects:@"Women's Track",@"Men's Basketball",@"Women's Basketball",@"Football",@"Men's Golf",@"Women's Golf",@"Men's Soccer",@"Women's Soccer",@"Softball",@"Men's Tennis",@"Women's Tennis",@"Volleyball", nil];
    int found = 0;
    for(int i=0; i<[sportCategories count]; i++)
    {
        //If I find my current sport category in the title string, then set my event category equal to the sport category that was found in the title string and break
        if([game.title rangeOfString:[sportCategories objectAtIndex:i]].location != NSNotFound)
        {
            game.category = [sportCategories objectAtIndex:i];
            found = 1;
            break;
        }
    }
    if(found == 0)
    {
        NSLog(@"#### I couldn't figure out what sport category thish person belonged to! Title: %@\n",game.title);
        game.category = @"NCAA";
    }
    return game;
}
@end

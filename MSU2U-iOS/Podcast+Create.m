//
//  Podcast+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/23/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Podcast+Create.h"

@implementation Podcast (Create)

+(Podcast *)podcastWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    Podcast * podcast = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Podcast"];
    
    //What attribute makes a tweet unique?
    request.predicate = [NSPredicate predicateWithFormat:@"podcast_id = %@", [info objectForKey:@"Article_ID"]];
    
    //How is the information sorted?
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pubDate" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * allPodcast = [context executeFetchRequest:request error:&error];
    
    if(!allPodcast || ([allPodcast count] > 1))
    {
        //handle error
    }
    else if(![allPodcast count])
    {
        podcast = [self createNewPodcast:info inContext:context];
    }
    else
    {
        //It apears this video exists already in the core data. Well, has any information been updated since the time I downloaded the original?
        podcast = [allPodcast lastObject];
    }
    
    return podcast;
}

+(Podcast*)createNewPodcast:(NSDictionary*)info inContext:(NSManagedObjectContext*)context
{
    Podcast * podcast = [NSEntityDescription insertNewObjectForEntityForName:@"Podcast" inManagedObjectContext:context];
    
    //Get all of the video information
    podcast.podcast_id = [info objectForKey:@"Article_ID"];
    podcast.title = [info objectForKey:@"Title"];
    podcast.link = [info objectForKey:@"Link"];
    
    //Determine who the author is
    if([podcast.link rangeOfString:@"msumustangs"].location == NSNotFound)
    {
        //Since there shouldn't be anyone else but msumustangs in our podcast list, just put Unknown as the alternative author case
        podcast.author = @"Unknown";
    }
    else
    {
        podcast.author = @"MSUMustangs.com";
    }
       
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:cst];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    //Format of the last_changed: 2013-03-27 23:19:29
    [dateFormatter setDateFormat: @"mm/dd/yyyy"];
    NSDate * date = [dateFormatter dateFromString:[info objectForKey:@"Pub_Date"]];
    podcast.pubDate = date;
    
    return podcast;
}
@end

//
//  Tweet+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/11/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Tweet+Create.h"

@implementation Tweet (Create)
+(Tweet *)tweetWithInfo:(NSDictionary*)info isProfile:(BOOL)isProfile inManagedObjectContext:(NSManagedObjectContext*)context
{
    Tweet * tweet = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    //What attribute makes a tweet unique?
    request.predicate = [NSPredicate predicateWithFormat:@"id_str = %@", [info objectForKey:@"id_str"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * allTweet = [context executeFetchRequest:request error:&error];
    
    if(!allTweet || ([allTweet count] > 1))
    {
        //handle error
    }
    else if(![allTweet count])
    {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
        tweet.text = [info objectForKey:@"text"];
        
        //Convert the created_at string to an NSDate to be stored in tweet.created_at
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        
        tweet.id_str = [info objectForKey:@"id_str"];
        if(isProfile)
        {
            //Date formatter
            [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
            
            //Other stuff
            tweet.screen_name = [[info objectForKey:@"user"]objectForKey:@"screen_name"];
            tweet.profile_image_url = [[info objectForKey:@"user"] objectForKey:@"profile_image_url"];
            tweet.profile_background_image_url = [[info objectForKey:@"user"] objectForKey:@"profile_background_image_url"];
            tweet.name = [[info objectForKey:@"user"] objectForKey:@"name"];
        }
        else
        {
            //### hashtag
            
            //Date Formatter
            [dateFormatter setDateFormat: @"EEE, dd MMM yyyy HH:mm:ss Z"];
            
            //Other Stuff
            tweet.screen_name = [info objectForKey:@"screen_name"];
            tweet.profile_image_url = [info objectForKey:@"profile_image_url"];
            tweet.profile_background_image_url = [info objectForKey:@"profile_background_image_url"];
            tweet.name = [info objectForKey:@"from_user_name"];
        }
        NSDate *date = [dateFormatter dateFromString:[info objectForKey:@"created_at"]];
        tweet.created_at = date;
    }
    else
    {
        tweet = [allTweet lastObject];
    }
    
    return tweet;
}
@end

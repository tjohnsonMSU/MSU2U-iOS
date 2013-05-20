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
    //NSLog(@"START\n");
    Tweet * tweet = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    
    //What attribute makes a tweet unique?
    //NSLog(@"Request Predicate\n");
    request.predicate = [NSPredicate predicateWithFormat:@"id_str = %@",[info objectForKey:@"id_str"]];

    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * allTweet = [context executeFetchRequest:request error:&error];
    
    //NSLog(@"If/else/else\n");
    if(!allTweet || ([allTweet count] > 1))
    {
        //NSLog(@"error!\n");
    }
    else if(![allTweet count])
    {
        //Brand new, never before seen Tweet. Add it!
        //NSLog(@"Brand new...\n");
        tweet = [self createNewTweet:info inContext:context isProfile:isProfile];
    }
    else
    {
        //NSLog(@"Get old tweet, I've seen this before\n");
        tweet = [allTweet lastObject];
    }
    
    return tweet;
}

+(Tweet*)createNewTweet:(NSDictionary*)info inContext:(NSManagedObjectContext*)context isProfile:(BOOL)isProfile
{
    Tweet * tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
    tweet.text = [info objectForKey:@"text"];
    
    //Convert the created_at string to an NSDate to be stored in tweet.created_at
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    //tweet.id_str = [info objectForKey:@"id_str"];
    if(isProfile)
    {
        //NSLog(@"isProfile = TRUE");
        //Other stuff
        //NSLog(@"Setting id_str...\n");
        tweet.id_str = [info objectForKey:@"id_str"];
        //NSLog(@"SEtting max_id...\n");
        tweet.max_id = [info objectForKey:@"id_str"];
    }
    else
    {
        //NSLog(@"isProfile = FALSE");
        //### hashtag
        tweet.id_str = [NSString stringWithFormat:@"%@",[info objectForKey:@"id_str"]];
        tweet.max_id = tweet.id_str;
    }
    
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    tweet.screen_name = [[info objectForKey:@"user"]objectForKey:@"screen_name"];
    tweet.profile_image_url = [[info objectForKey:@"user"] objectForKey:@"profile_image_url"];
    tweet.profile_background_image_url = [[info objectForKey:@"user"] objectForKey:@"profile_background_image_url"];
    tweet.name = [[info objectForKey:@"user"] objectForKey:@"name"];
    
    NSDate *date = [dateFormatter dateFromString:[info objectForKey:@"created_at"]];
    tweet.created_at = date;
    
    return tweet;
}

@end

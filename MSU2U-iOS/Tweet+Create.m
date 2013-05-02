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
        //Brand new, never before seen Tweet. Add it!
        tweet = [self createNewTweet:info inContext:context isProfile:isProfile];
    }
    else
    {
        //Ok, I already have this tweet, but has the screen_name, profile image, or real name changed for any tweet?
        tweet = [allTweet lastObject];
        BOOL deleteMe = false;
        
        if(isProfile)
        {
            if(![tweet.profile_image_url isEqualToString:[[info objectForKey:@"user"] objectForKey:@"profile_image_url"]] || ![tweet.screen_name isEqualToString:[[info objectForKey:@"user"]objectForKey:@"screen_name"]] || ![tweet.name isEqualToString:[[info objectForKey:@"user"] objectForKey:@"name"]])
                deleteMe = true;
        }
        else
        {
            if(![tweet.profile_image_url isEqualToString:[info objectForKey:@"profile_image_url"]] || ![tweet.screen_name isEqualToString:[info objectForKey:@"from_user"]] || ![tweet.name isEqualToString:[info objectForKey:@"from_user_name"]])
                deleteMe = true;
        }
        
        if(deleteMe)
        {
            NSLog(@"Something changed for %@\n",tweet.screen_name);
            //Well, something changed so remove this tweet and add the new copy in
            for (NSManagedObject * t in allTweet)
            {
                [context deleteObject:t];
            }
            
            //create a new tweet
            tweet = [self createNewTweet:info inContext:context isProfile:isProfile];
        }

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
    
    tweet.id_str = [info objectForKey:@"id_str"];
    if(isProfile)
    {
        //Date formatter
        [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
        
        //Other stuff
        tweet.max_id = [info objectForKey:@"id_str"];
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
        tweet.screen_name = [info objectForKey:@"from_user"];
        tweet.profile_image_url = [info objectForKey:@"profile_image_url"];
        tweet.profile_background_image_url = [info objectForKey:@"profile_background_image_url"];
        tweet.name = [info objectForKey:@"from_user_name"];
        tweet.max_id = [info objectForKey:@"id_str"];
    }
    NSDate *date = [dateFormatter dateFromString:[info objectForKey:@"created_at"]];
    tweet.created_at = date;
    
    return tweet;
}

@end

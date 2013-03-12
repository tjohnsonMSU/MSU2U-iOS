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
        tweet.created_at = [info objectForKey:@"created_at"];
        tweet.id_str = [info objectForKey:@"id_str"];
        if(isProfile)
        {
            tweet.screen_name = [[info objectForKey:@"user"]objectForKey:@"screen_name"];
            tweet.profile_image_url = [[info objectForKey:@"user"] objectForKey:@"profile_image_url"];
            tweet.profile_background_image_url = [[info objectForKey:@"user"] objectForKey:@"profile_background_image_url"];
            tweet.name = [[info objectForKey:@"user"] objectForKey:@"name"];
        }
        else
        {
            //### hashtag
            tweet.screen_name = [info objectForKey:@"screen_name"];
            tweet.profile_image_url = [info objectForKey:@"profile_image_url"];
            tweet.profile_background_image_url = [info objectForKey:@"profile_background_image_url"];
            tweet.name = [info objectForKey:@"from_user_name"];
        }
    }
    else
    {
        tweet = [allTweet lastObject];
    }
    
    return tweet;
}
@end

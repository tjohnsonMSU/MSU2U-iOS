//
//  Video+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/19/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import "Video+Create.h"

@implementation Video (Create)
+(Video *)videoWithInfo:(NSDictionary*)info isVimeo:(BOOL)isVimeo inManagedObjectContext:(NSManagedObjectContext*)context
{
    Video * video = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
    
    //What attribute makes a tweet unique?

    NSString * theVideoIDnumber = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    request.predicate = [NSPredicate predicateWithFormat:@"video_id = %@", theVideoIDnumber];

    //How is the information sorted?
    if(isVimeo)
    {
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"upload_date" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    }
    else
    {
        /*
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"uploaded" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
         */
    }
    
    NSError * error = nil;
    NSArray * allVideo = [context executeFetchRequest:request error:&error];
    
    if(!allVideo || ([allVideo count] > 1))
    {
        //handle error
    }
    else if(![allVideo count])
    {
        video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:context];
        
        if(isVimeo)
        {
            //Get all of the video information
            video.video_id = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
            video.title = [info objectForKey:@"title"];
            video.thumbnail_small = [info objectForKey:@"thumbnail_small"];
            video.user_portrait_small = [info objectForKey:@"user_portrait_small"];
            video.desc = [info objectForKey:@"description"];
            video.tags = [info objectForKey:@"tags"];
            video.user_id = [NSString stringWithFormat:@"%@",[info objectForKey:@"user_id"]];
            video.url = [info objectForKey:@"url"];
            video.user_name = [info objectForKey:@"user_name"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeZone:cst];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            
            //Format of the last_changed: 2013-03-27 23:19:29
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            NSDate * date = [dateFormatter dateFromString:[info objectForKey:@"upload_date"]];
            video.upload_date = date;
        }
        //YouTube video
        else
        {
            NSLog(@"I'm a YouTube video...\n");
            
            //get the youtube video info
            //NSLog(@"id...\n");
            video.video_id = [info objectForKey:@"id"];
            //NSLog(@"title...\n");
            video.title = [info objectForKey:@"title"];
            //NSLog(@"thumbnail...\n");
            video.thumbnail_small = [[info objectForKey:@"thumbnail"] objectForKey:@"hqDefault"];
            //NSLog(@"user portrait...\n");
            video.user_portrait_small = @"";
            //NSLog(@"description...\n");
            video.desc = [info objectForKey:@"description"];
            //NSLog(@"category...\n");
            video.tags = [info objectForKey:@"category"];
            //NSLog(@"user_id...\n");
            video.user_id = @"";
            //NSLog(@"url...\n");
            video.url = [[info objectForKey:@"player"] objectForKey:@"default"];
            NSLog(@"My video URL is %@\n",video.url);
            //NSLog(@"user_name...\n");
            video.user_name = [info objectForKey:@"uploader"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [dateFormatter setDateStyle:NSDateFormatterLongStyle];
            [dateFormatter setTimeZone:cst];
            [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
            
            //Format of the last_changed: 2013-03-27 23:19:29
            [dateFormatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.000'Z'"];
            NSDate * date = [dateFormatter dateFromString:[info objectForKey:@"uploaded"]];
            video.upload_date = date;
        }
    }
    else
    {
        video = [allVideo lastObject];
    }
    
    return video;
}
@end

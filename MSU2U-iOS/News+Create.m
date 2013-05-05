//
//  News+Create.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "News+Create.h"

@implementation News (Create)

+(News *)newsWithInfo:(NSDictionary*)info inManagedObjectContext:(NSManagedObjectContext*)context
{
    News * news = nil;
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"News"];
    request.predicate = [NSPredicate predicateWithFormat:@"article_id = %@", [info objectForKey:@"Article_ID"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"last_changed" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError * error = nil;
    NSArray * allNews = [context executeFetchRequest:request error:&error];
    
    if(!allNews || ([allNews count] > 1))
    {
        //handle error
    }
    else if(![allNews count])
    {
        news = [self createNewNews:info inContext:context];
    }
    else
    {
        news = [allNews lastObject];
        
        if([news.title isEqualToString:[info objectForKey:@"Title"]] && [news.image isEqualToString:[info objectForKey:@"image"]] && [news.short_description isEqualToString:[info objectForKey:@"Short_Description"]] && [news.long_description isEqualToString:[info objectForKey:@"Long_Description"]])
        {
            //OK, this news item has not significantly changed so keep it the same
            NSLog(@"News item has not changed...\n");
        }
        else
        {
            //Well, something changed so remove this video and add the new copy in
            for (NSManagedObject * n in allNews)
            {
                [context deleteObject:n];
            }
            
            //create a new video
            news = [self createNewNews:info inContext:context];
        }
    }
    
    return news;
}

+(News*)createNewNews:(NSDictionary*)info inContext:(NSManagedObjectContext*)context
{
    News * news = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:context];
    
    news.article_id = [info objectForKey:@"Article_ID"];
    news.title = [info objectForKey:@"Title"];
    news.link = [info objectForKey:@"Link"];
    news.category_1 = [info objectForKey:@"Category_1"];
    news.short_description = [info objectForKey:@"Short_Description"];
    news.doc_creator = [info objectForKey:@"Doc_Creator"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]*>"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    [regex replaceMatchesInString:[info objectForKey:@"Long_Description"]
                          options:0
                            range:NSMakeRange(0, [[info objectForKey:@"Long_Description"] length])
                     withTemplate:@""];
    
    [[info objectForKey:@"Long_Description"] replaceOccurrencesOfString:@"<br />" withString:@"" options:nil range:NSMakeRange(0,[[info objectForKey:@"Long_Description"] length])];
    
    news.long_description = [info objectForKey:@"Long_Description"];
    news.image = [info objectForKey:@"image"];
    
    //Handle the dates
    //Convert the created_at string to an NSDate to be stored in tweet.created_at
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:cst];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    [dateFormatter setDateFormat: @"EEE, dd MMMM y HH:mm:ss ZZZZ"];
    NSDate *last_changed_date = [dateFormatter dateFromString:[info objectForKey:@"Last_Changed"]];
    news.last_changed = last_changed_date;
    
    [dateFormatter setDateFormat: @"EEE, dd MMMM y HH:mm:ss ZZZZ"];
    NSDate *pub_date_date = [dateFormatter dateFromString:[info objectForKey:@"Pub_Date"]];
    news.pub_date = pub_date_date;
    
    //figure out what publication source this news article is from. This is tricky and not 100% fool proof. Currently using a hokey means of deciding whether
    //  the publication is from MSU Mustangs or Wichitan based upon the listed category for the article
    news.publication = [info objectForKey:@"Publication"];
    
    return news;
}

@end

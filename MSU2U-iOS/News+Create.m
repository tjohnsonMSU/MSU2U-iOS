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
        news = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:context];
        
        news.article_id = [info objectForKey:@"Article_ID"];
        news.title = [info objectForKey:@"Title"];
        news.link = [info objectForKey:@"Link"];
        news.category_1 = [info objectForKey:@"Category_1"];
        news.short_description = [info objectForKey:@"Short_Description"];
        news.doc_creator = [info objectForKey:@"Doc_Creator"];
        news.long_description = [info objectForKey:@"Long_Description"];
        
        //Handle the dates
        //Convert the created_at string to an NSDate to be stored in tweet.created_at
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone * cst = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeZone:cst];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        
        //Format of the last_changed: 2013-03-27 23:19:29 
        [dateFormatter setDateFormat: @"EEE, dd MMMM y HH:mm:ss ZZZZ"];
        NSDate *last_changed_date = [dateFormatter dateFromString:[info objectForKey:@"Last_Changed"]];
        news.last_changed = last_changed_date;
        
        //Format of the Pub_Date: 0000-00-00
        [dateFormatter setDateFormat: @"EEE, dd MMMM y HH:mm:ss ZZZZ"];
        NSDate *pub_date_date = [dateFormatter dateFromString:[info objectForKey:@"Pub_Date"]];
        news.pub_date = pub_date_date;
        
        //figure out what publication source this news article is from. This is tricky and not 100% fool proof. Currently using a hokey means of deciding whether
        //  the publication is from MSU Mustangs or Wichitan based upon the listed category for the article
        if([news.doc_creator isEqualToString:@"msumustangs.com"])
        {
            news.publication = @"MSU Mustangs";
            news.image = [info objectForKey:@"image"];
        }
        else
        {
            news.publication = @"The Wichitan";
            
            
            NSString *url = nil;
            NSString *htmlString = news.long_description;
            NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
            // find start of IMG tag
            /*[theScanner scanUpToString:@"<img" intoString:nil];
            if (![theScanner isAtEnd]) {
                [theScanner scanUpToString:@"src" intoString:nil];
                NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                [theScanner scanCharactersFromSet:charset intoString:nil];
                [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                // "url" now contains the URL of the img
            }*/
            
            NSLog(@"My alleged wichitan images: %@\n",[info objectForKey:@"image"]);
            news.image = [info objectForKey:@"image"];
        }
        
    }
    else
    {
        news = [allNews lastObject];
    }
    
    return news;
}
@end

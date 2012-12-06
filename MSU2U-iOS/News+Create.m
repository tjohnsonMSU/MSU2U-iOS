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
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", [info objectForKey:@"title"]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
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
        
        news.title = [info objectForKey:@"title"];
        news.link = [info objectForKey:@"link"];
        news.date = [info objectForKey:@"date"];
        news.category = [info objectForKey:@"category"];
        news.link = [info objectForKey:@"link"];
        news.content = [info objectForKey:@"description"];
        news.author = [info objectForKey:@"author"];
        news.publication = [info objectForKey:@"publication"];
    }
    else
    {
        news = [allNews lastObject];
    }
    
    return news;
}
@end

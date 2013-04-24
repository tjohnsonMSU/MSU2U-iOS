//
//  Podcast.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/23/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Podcast : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * podcast_id;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * author;

@end

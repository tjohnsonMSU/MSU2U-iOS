//
//  News.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/28/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * doc_creator;
@property (nonatomic, retain) NSString * category_1;
@property (nonatomic, retain) NSDate * pub_date;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * publication;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * article_id;
@property (nonatomic, retain) NSString * short_description;
@property (nonatomic, retain) NSString * long_description;
@property (nonatomic, retain) NSDate * last_changed;

@end

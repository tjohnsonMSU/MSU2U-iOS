//
//  News.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/15/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * unique;
@property (nonatomic, retain) NSString * publication;

@end

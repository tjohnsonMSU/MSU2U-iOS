//
//  Event.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * evgameid;
@property (nonatomic, retain) NSString * evlocation;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * category;

@end

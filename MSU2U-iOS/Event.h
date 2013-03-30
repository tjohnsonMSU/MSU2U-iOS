//
//  Event.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/29/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * gameid;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * startdate;
@property (nonatomic, retain) NSDate * enddate;
@property (nonatomic, retain) NSString * teamlogo;
@property (nonatomic, retain) NSString * opponentlogo;
@property (nonatomic, retain) NSString * category;

@end

//
//  Sport.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sport : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * evgameid;
@property (nonatomic, retain) NSString * evlocation;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * steamLogo;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * sopponentlogo;
@property (nonatomic, retain) NSString * sportType;

@end

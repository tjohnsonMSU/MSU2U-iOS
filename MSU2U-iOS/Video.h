//
//  Video.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 4/19/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Video : NSManagedObject

@property (nonatomic, retain) NSDate * upload_date;
@property (nonatomic, retain) NSString * thumbnail_small;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * user_portrait_small;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * video_id;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * user_name;

@end

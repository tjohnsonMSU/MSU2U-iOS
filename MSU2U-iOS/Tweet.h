//
//  Tweet.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/13/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tweet : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * id_str;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profile_background_image_url;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSString * text;

@end

//
//  tweet.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 3/10/13.
//  Copyright (c) 2013 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tweet : NSObject {
    
    NSString *text;
    NSString *name;
    NSString *screen_name;
    NSDate *created_at;
    NSString *location;
    NSString *followers_count;
    NSString *friends_count;
    NSString *profile_image_url;
    NSString *profile_background_image_url_https;
    NSNumber *retweet_count;
    NSNumber *favorited;
}

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * followers_count;
@property (nonatomic, retain) NSString * friends_count;
@property (nonatomic, retain) NSString * profile_image_url;
@property (nonatomic, retain) NSString * profile_background_image_url_https;
@property (nonatomic, retain) NSNumber * retweet_count;
@property (nonatomic, retain) NSNumber * favorited;

@end

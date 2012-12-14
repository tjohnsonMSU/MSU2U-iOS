//
//  imageResize.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 12/13/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageModification : NSObject
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
@end

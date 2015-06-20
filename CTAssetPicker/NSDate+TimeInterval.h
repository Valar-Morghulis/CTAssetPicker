//
//  NSDate+TimeInterval.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(TimeInterval)
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;
@end

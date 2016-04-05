/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

@interface NSDate (Utilities)

+ (NSDate*)dateFromString:(NSString*)string;
+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format;

@end

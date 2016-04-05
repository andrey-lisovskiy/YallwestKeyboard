/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen
*/

#import "NSDate-Utilities.h"

@implementation NSDate (Utilities)

#pragma mark Relative Dates

+ (NSDate*)dateFromString:(NSString*)string {
    if (!string.length)
        return nil;
    
    return [self dateFromString:string format:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}

+ (NSDate*)dateFromString:(NSString*)string format:(NSString*)format {
   static NSDateFormatter* sDateFormatter = nil;
   if (!sDateFormatter) {
      sDateFormatter = [[NSDateFormatter alloc]init];
       NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
       [sDateFormatter setLocale:enUSPOSIXLocale];
   }
   [sDateFormatter setDateFormat:format];
   return [sDateFormatter dateFromString:string];
}

@end

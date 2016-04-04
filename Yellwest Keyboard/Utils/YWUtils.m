//
//  YWUtils.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "YWUtils.h"
#import "NSDate-Utilities.h"

@implementation YWUtils

+ (UIColor *)colorFromHexa:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (NSString*)suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log(num) / log(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

#pragma mark - Relative Date -

+ (NSString *)relativeDateWithInput:(NSString *)strDate
{
    NSString * input = [strDate substringToIndex:strDate.length - 5];
    input = [input stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDate * referenceDate = [NSDate dateFromString:input format:@"yyyy-MM-dd HH:mm:ss"];
    return [YWUtils relativeDateStringFromDate:referenceDate];
}

+ (double)relativeDateNumberWithInput:(NSString *)strDate
{
    NSString * input = [strDate substringToIndex:strDate.length-5];
    input = [input stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * referenceDate = [formatter dateFromString:input];
    NSDate * todayDate = [NSDate date];
    
    double ti = [referenceDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    
    return ti;
}

+ (NSString*)relativeDateStringFromDate:(NSDate*)date
{
    NSDate * todayDate = [NSDate date];
    
    double ti = [date timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    
    double min = 60;
    double hour = min * 60;
    double day = hour * 24;
    double week = day * 7;
    double month = week * 4;
    //double year = month * 12;
    
    if(ti<min)
    {
        return @"Now";
    }
    else if(ti<hour)
    {
        int diff = round(ti/min);
        if(diff==1) return @"1 minute ago";
        else return [NSString stringWithFormat:@"%d minutes ago", diff];
    }
    else if(ti<day)
    {
        int diff = round(ti/hour);
        if(diff==1) return @"1 hour ago";
        else return [NSString stringWithFormat:@"%d hours ago", diff];
    }
    else if(ti<week)
    {
        int diff = round(ti/day);
        if(diff==1) return @"1 day ago";
        else return [NSString stringWithFormat:@"%d days ago", diff];
    }
    else if(ti<month)
    {
        int diff = round(ti/week);
        if(diff==1) return @"1 week ago";
        else return [NSString stringWithFormat:@"%d weeks ago", diff];
    }
    else
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale currentLocale];
        formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMMM dd, yyyy" options:0 locale:[NSLocale currentLocale]];
        
        return [formatter stringFromDate:date];
    }
}

+ (NSString*)parseISO8601Time:(NSString*)duration
{
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    //Get Time part from ISO 8601 formatted duration http://en.wikipedia.org/wiki/ISO_8601#Durations
    if ([duration rangeOfString:@"T"].location == NSNotFound || [duration rangeOfString:@"P"].location == NSNotFound) {
        NSLog(@"Time is not a part from ISO 8601 formatted duration");
        return @"0:00 Error";
    }
    
    duration = [duration substringFromIndex:[duration rangeOfString:@"T"].location];
    
    while ([duration length] > 1) { //only one letter remains after parsing
        duration = [duration substringFromIndex:1];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:duration];
        NSString *durationPart = [[NSString alloc] init];
        [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] intoString:&durationPart];
        
        NSRange rangeOfDurationPart = [duration rangeOfString:durationPart];
        
        if ((rangeOfDurationPart.location + rangeOfDurationPart.length) > duration.length) {
            NSLog(@"Time is not a part from ISO 8601 formatted duration");
            return @"0:00 Error";
        }
        
        duration = [duration substringFromIndex:rangeOfDurationPart.location + rangeOfDurationPart.length];
        
        if ([[duration substringToIndex:1] isEqualToString:@"H"]) {
            hours = [durationPart intValue];
        }
        if ([[duration substringToIndex:1] isEqualToString:@"M"]) {
            minutes = [durationPart intValue];
        }
        if ([[duration substringToIndex:1] isEqualToString:@"S"]) {
            seconds = [durationPart intValue];
        }
    }
    
    if (hours != 0)
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    else
        return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
}

@end

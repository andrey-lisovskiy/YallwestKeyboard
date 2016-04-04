//
//  YWUtils.h
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface YWUtils : NSObject

+ (UIColor *)colorFromHexa:(NSString *)hexString;
+ (NSString *)relativeDateWithInput:(NSString *)strDate;
+ (UIColor *)randomColor;
+ (NSString*)suffixNumber:(NSNumber*)number;

@end

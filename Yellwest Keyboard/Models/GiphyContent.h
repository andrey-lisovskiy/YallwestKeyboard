//
//  GiphyContentModel.h
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiphyContent : NSObject

@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSNumber *thumbnailWidth;
@property (nonatomic, strong) NSNumber *thumbnailHeight;

+ (GiphyContent*)contentWithDictionary:(NSDictionary*)dictionary;

@end
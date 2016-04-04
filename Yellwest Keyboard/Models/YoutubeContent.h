//
//  YoutubeContentModel.h
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YoutubeContent : NSObject

@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *mediaURL;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *relativeTime;
@property (nonatomic, strong) NSString *viewCount;

+ (YoutubeContent*)contentWithDictionary:(NSDictionary*)dictionary;

@end

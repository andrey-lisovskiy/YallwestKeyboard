//
//  YoutubeContentModel.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "YoutubeContent.h"
#import "YWUtils.h"
#import "NSDictionary+Additions.h"

@implementation YoutubeContent

+ (YoutubeContent*)contentWithDictionary:(NSDictionary*)item
{
    YoutubeContent *content = [YoutubeContent new];
    
    NSDictionary *snippet = [item objectForKeyOrNil:@"snippet"];
    NSDictionary *thumbnails = [snippet objectForKeyOrNil:@"thumbnails"];
    NSDictionary *highThumb = [thumbnails objectForKeyOrNil:@"medium"];
    NSString *urlString = [highThumb objectForKeyOrNil:@"url"];
    
    //views count
    NSDictionary *statisticsDictionary = [item objectForKeyOrNil:@"statistics"];
    NSString *viewsCount = [YoutubeContent viewsCountStringFromDictionary:statisticsDictionary];
    
    NSString *videoId = @"";
    if ([[item objectForKeyOrNil:@"id"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *idDictionary = [item objectForKeyOrNil:@"id"];
        videoId = [idDictionary objectForKeyOrNil:@"videoId"];
    } else {
        videoId = [item objectForKeyOrNil:@"id"];
    }
    
    NSString *mediaUrl = [NSString stringWithFormat:@"%@%@", @"https://www.youtube.com/watch?v=", videoId];
    NSString *title = [snippet objectForKeyOrNil:@"title"];
    
    NSString * dateString = [snippet objectForKeyOrNil:@"publishedAt"];
    NSString * relativeTime = [YWUtils relativeDateWithInput:dateString];
    
    content.videoId = videoId;
    content.title = title;
    content.thumbnailURL = urlString;
    content.mediaURL = mediaUrl;
    content.relativeTime = relativeTime;
    content.viewCount = viewsCount;
    
    return content;
}

+ (NSString*)viewsCountStringFromDictionary:(NSDictionary*)dictionary
{
    NSString *viewCount = [dictionary objectForKeyOrNil:@"viewCount"];
    if ([viewCount length]) {
        return [YWUtils suffixNumber:[dictionary objectForKeyOrNil:@"viewCount"]];
    }
    
    return viewCount;
}

@end

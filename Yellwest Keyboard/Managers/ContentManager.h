//
//  YWContentManager.h
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContentManager, YoutubeContent;
typedef void (^ContentManagerCompletionHandler)(ContentManager *manager, NSError *error);
typedef void (^YoutubeQueryViewsCountHandler)(YoutubeContent *content, NSError *error);

@interface ContentManager : NSObject

@property (nonatomic, strong) NSMutableArray *giphyContents;
@property (nonatomic, strong) NSArray *youtubeContents;

+ (ContentManager*)sharedInstance;

- (void)requestGiphyContentsForCompletion:(ContentManagerCompletionHandler)completion;
- (void)requestYoutubeContentsForCompletion:(ContentManagerCompletionHandler)completion;

- (void)getYoutubeViewsCountForContent:(YoutubeContent*)content completion:(YoutubeQueryViewsCountHandler)completion;

@end

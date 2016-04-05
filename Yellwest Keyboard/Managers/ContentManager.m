//
//  YWContentManager.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "ContentManager.h"
#import "YoutubeContent.h"
#import "GiphyContent.h"
#import "Constants.h"
#import "YWUtils.h"

#import "NSDictionary+Additions.h"
#import "AFNetworking.h"

@interface ContentManager ()
{
    NSMutableArray *_giphyContents;
    NSMutableArray *_youtubeContents;
}
@end

@implementation ContentManager

+ (ContentManager*)sharedInstance
{
    static ContentManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ContentManager alloc] init];
        sharedInstance.giphyContents = [NSMutableArray new];
        sharedInstance.youtubeContents = [NSMutableArray new];
    });
    
    return sharedInstance;
}

- (void)requestGiphyContentsForCompletion:(ContentManagerCompletionHandler)completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *queryString = @"http://api.giphy.com/v1/gifs";
    NSDictionary *params = @{@"api_key": kAPIKeyGiphy,
                             @"ids" : @"oPSz3tly3rbJm, iQwmD75S11IpW, XVCOkOhRkYfbq, lNHKK2nbxouIM, UAUwzEt94u9qw, 8WXaPA2QfSKRO, lN6JDeiHedO2A, IG05D5A4jueze, WfRztREO5U0BW, S4Xt9sax17lio, 7MgItY2EUH89a, 6hx72yQS7EC4, r7iGP6Fumq37O, vW8IBI5s8mNDW, 7JOaAdwiGegOQ, xT0BKNIesmncqE2it2, 2OrhXJujkSgHC, iabAesjclrFf2, TxfyhxcHdD0SQ, FNLbDpniXyj8A, viI0Fi9cffWbS, 8ZJwF101l4Fs4, WMK0JozX6kyuk, 115uEgyHXabbK8, D3pnGq0MMzhQY, 14wnivBKrt7FSg, LxepQuu6Sawjm, u3WObbJtkTNYc, UygFLQrmcwDvy, bjwWQpMQSGkHS"};
    
    //Create the get request
    [manager GET:queryString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_giphyContents removeAllObjects];
        
        NSArray *arrayOfGifs = responseObject[@"data"];
        for (NSDictionary *gifInfo in arrayOfGifs) {
            GiphyContent *content = [GiphyContent contentWithDictionary:gifInfo];
            [_giphyContents addObject:content];
        }
        
        completion(self, nil);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(self, error);
    }];
}

- (void)requestYoutubeContentsForCompletion:(ContentManagerCompletionHandler)completion
{
    NSString *url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&channelId=%@&key=%@&order=date&maxResults=50", YALLWEST_CHANNEL_ID, kAPIKeyYoutube];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_youtubeContents removeAllObjects];
        
        NSDictionary *dictionary = (NSDictionary*)responseObject;
        for (NSDictionary *item in dictionary[@"items"]) {
            YoutubeContent *content = [YoutubeContent contentWithDictionary:item];
            [_youtubeContents addObject:content];
        }
        
        completion(self, nil);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(self, error);
    }];
}

- (void)getYoutubeViewsCountForContent:(YoutubeContent*)content completion:(YoutubeQueryViewsCountHandler)completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=statistics&id=%@&key=%@", content.videoId, kAPIKeyYoutube];
    
    [manager GET:urlString
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *dictionary = (NSDictionary*)responseObject;
             NSArray *itemsArray = [dictionary objectForKeyOrNil:@"items"];
             NSNumber *viewsCount = @0;
             if ([itemsArray count]) {
                 NSDictionary *itemDictionary = itemsArray[0];
                 NSDictionary *statistics = [itemDictionary objectForKeyOrNil:@"statistics"];
                 viewsCount = [statistics objectForKeyOrNil:@"viewCount"];
                 
                 @synchronized(content) {
                     content.viewCount = [YWUtils suffixNumber:viewsCount];
                 }
             }
             
             if (completion) {
                 completion(content, nil);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (completion) {
                 completion(content, error);
             }
         }];
}

@end

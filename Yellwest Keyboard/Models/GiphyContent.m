//
//  GiphyContentModel.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "GiphyContent.h"
#import "NSDictionary+Additions.h"

@implementation GiphyContent

+ (GiphyContent*)contentWithDictionary:(NSDictionary*)dictionary
{
    GiphyContent *content = [GiphyContent new];
    
    content.URL = [[[dictionary objectForKeyOrNil:@"images"]
                    objectForKeyOrNil:@"fixed_width"]
                   objectForKeyOrNil:@"url"];
    
    content.thumbnailURL = [[[dictionary objectForKeyOrNil:@"images"]
                             objectForKeyOrNil:@"fixed_width_still"]
                            objectForKeyOrNil:@"url"];
    
    content.thumbnailWidth = @([[[[dictionary objectForKeyOrNil:@"images"]
                                  objectForKeyOrNil:@"fixed_width_still"]
                                 objectForKeyOrNil:@"width"] intValue]);
    
    content.thumbnailHeight = @([[[[dictionary objectForKeyOrNil:@"images"]
                                   objectForKeyOrNil:@"fixed_width_still"]
                                  objectForKeyOrNil:@"height"] intValue]);
    
    return content;
}

@end

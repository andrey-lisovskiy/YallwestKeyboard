//
//  YoutubeCellCollectionViewCell.h
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 12.01.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YoutubeContent;
@interface YoutubeCell : UICollectionViewCell

@property (nonatomic, strong) YoutubeContent *content;

- (void)updateViewCount;

@end

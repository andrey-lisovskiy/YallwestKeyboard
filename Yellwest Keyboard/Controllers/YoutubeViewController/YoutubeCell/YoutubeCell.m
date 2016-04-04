//
//  YoutubeCellCollectionViewCell.m
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 12.01.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "YoutubeCell.h"
#import "YoutubeContent.h"
#import "ContentManager.h"

#import "UIImageView+WebCache.h"

@interface YoutubeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end

@implementation YoutubeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.thumbnailImageView sd_cancelCurrentImageLoad];
}

#pragma mark - Setters/Getters -

- (void)setContent:(YoutubeContent *)content
{
    _content = content;
    [self configureWithContent:_content];
}

#pragma mark - Methods -

- (void)configureWithContent:(YoutubeContent*)content
{
    self.titleLabel.text = content.title;
    [self adjustTitleHeight];
    
    [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:content.thumbnailURL]];
}

- (void)adjustTitleHeight
{
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(self.titleLabel.frame), 55.f);
    
    CGSize expectedLabelSize = [self.titleLabel.text boundingRectWithSize:maximumLabelSize
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName : self.titleLabel.font}
                                                                  context:nil].size;
    
    CGRect newFrame = self.titleLabel.frame;
    newFrame.size.height = roundf(expectedLabelSize.height + .5f);
    self.titleLabel.frame = newFrame;
    
    CGRect newFrame2 = self.subtitleLabel.frame;
    newFrame2.origin.y = roundf(CGRectGetMaxY(newFrame) +.5f);
    self.subtitleLabel.frame = newFrame2;
}

- (void)updateFooterLabel
{
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@ views • %@", _content.viewCount, _content.relativeTime];
}

#pragma mark - Public methods -

- (void)updateViewCount
{
    if ([_content.viewCount length]) {
        [self updateFooterLabel];
    } else {
        __weak typeof(self) weakSelf = self;
        
        [[ContentManager sharedInstance] getYoutubeViewsCountForContent:_content completion:^(YoutubeContent *content, NSError *error) {
            [weakSelf updateFooterLabel];
        }];
    }
    
}

@end

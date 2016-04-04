//
//  EmojiCell.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 01.04.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "EmojiCell.h"

@implementation EmojiCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"EmojiCell" owner:self options:nil];
        self = array[0];
    }
    return self;
}

@end

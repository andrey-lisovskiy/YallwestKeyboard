//
//  TCKGIFCollectionViewCell.h
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 28.12.15.
//  Copyright © 2015 Andrey Lisovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFAnimatedImageView.h"
#import "TCKInfoView.h"

@interface TCKGIFCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet DFAnimatedImageView *gifImageView;
@property (nonatomic, copy) NSString *gifName;

- (void)showInfoViewWithType:(InfoViewType)type cornerRadius:(CGFloat)cornerRadius;
- (BOOL)hasInfoView;

@end

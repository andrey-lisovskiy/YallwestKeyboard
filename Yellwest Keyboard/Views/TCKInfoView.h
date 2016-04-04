//
//  TCKCopiedView.h
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 17.12.15.
//  Copyright © 2015 Andrey Lisovskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    InfoViewTypeCopied,
    InfoViewTypeSaved
} InfoViewType;

@interface TCKInfoView : UIView

+ (void)showInView:(UIView*)view type:(InfoViewType)type cornerRadius:(CGFloat)cornerRadius;

@end

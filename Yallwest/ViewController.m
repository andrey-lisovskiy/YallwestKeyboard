//
//  ViewController.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Methods -

- (void)presentShareController {
    NSString *text = @"You're gonna love this new keyboard!";
    NSURL *url = [NSURL URLWithString:@"http://apple.co/1SC1o3V"];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    
    if ([controller respondsToSelector:@selector(popoverPresentationController)]) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMaxX(self.buttonsView.frame) - CGRectGetWidth(self.buttonsView.frame)/2, (CGRectGetMaxY(self.buttonsView.frame) - CGRectGetHeight(self.buttonsView.frame)/2) - CGRectGetHeight(self.shareButton.frame)/2, 0, 0);
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Actions -

- (IBAction)shareButtonAction:(id)sender {
    [self presentShareController];
}

@end

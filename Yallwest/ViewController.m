//
//  ViewController.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "ViewController.h"

#define KEYBOARD_BUNDLE_ID @"com.kliq.Yallwest.Yellwest-Keyboard"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods -

- (void)presentShareController {
    NSString *text = @"You're gonna love this new keyboard!";
    NSURL *url = [NSURL URLWithString:@"http://www.yallwest.com/"];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)isOpenAccessGranted {
    return ([UIPasteboard generalPasteboard] != nil);
}

- (BOOL)isCustomKeyboardEnabled {
    NSArray *keyboards = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] objectForKey:@"AppleKeyboards"];
    for (NSString *keyboard in keyboards) {
        if ([keyboard isEqualToString:KEYBOARD_BUNDLE_ID])
            return YES;
    }
    
    return NO;
}

#pragma mark - Actions -

- (IBAction)shareButtonAction:(id)sender {
    [self presentShareController];
}

@end

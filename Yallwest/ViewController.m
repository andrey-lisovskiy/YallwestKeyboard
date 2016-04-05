//
//  ViewController.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Methods -

- (void)presentShareController {
    NSString *text = @"You're gonna love this new keyboard!";
    NSURL *url = [NSURL URLWithString:@"http://www.yallwest.com/"];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, url] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Actions -

- (IBAction)shareButtonAction:(id)sender {
    [self presentShareController];
}

@end

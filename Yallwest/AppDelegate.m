//
//  AppDelegate.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self customizeAppearance];
    return YES;
}

#pragma mark - Methods -

- (void)customizeAppearance {
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    UIImage *navBarBgImage = [UIImage imageNamed:@"nav_bar_bg.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarBgImage forBarMetrics:UIBarMetricsDefault];
}

@end

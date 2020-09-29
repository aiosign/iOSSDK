//
//  AppDelegate.m
//  GDSignSDKDome
//
//  Created by ioszhb on 2020/9/29.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end

//
//  AppDelegate.m
//  Yinner
//
//  Created by Maru on 15/5/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "AppDelegate.h"
#import "YKMainViewController.h"
#import "YKLoginViewController.h"
#import "ReuseKey.h"

@interface AppDelegate () <EMChatManagerBuddyDelegate>

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //获取APNS文件的名字
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"easemob-demo#chatdemoui" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //自动获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    //添加代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    

    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    YKMainViewController *mainController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
    self.window.rootViewController = mainController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - EMChatManagerDelegate
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    NSMutableArray *requestArray = [[NSUserDefaults standardUserDefaults] objectForKey:KfriendRequest];
    
    if (!requestArray) {
        
        requestArray = [NSMutableArray array];
    }
    
    //如果其中包含该请求那么就返回
    if ([requestArray containsObject:@{@"username" : username,@"message" : message}]) {
        return;
    }
    
    NSDictionary *dic = @{@"username" : username,@"message" : message};
    
    [requestArray addObject:dic];
    
    [[NSUserDefaults standardUserDefaults] setObject:requestArray forKey:KfriendRequest];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:KNotification_ReloadData object:nil]];
    
    NSLog(@"%@",username);
}

@end

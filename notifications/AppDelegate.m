//
//  AppDelegate.m
//  notifications
//
//  Created by xpression on 10/9/16.
//  Copyright (c) 2016 SZH. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Actions and Category
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    action.identifier = @"Check_Action";
    action.authenticationRequired = NO;
    action.title = @"Check";
    action.destructive = NO;
    action.activationMode = UIUserNotificationActivationModeForeground; // bring app to foreground
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"Clear_Action";
    action2.authenticationRequired = NO;
    action2.title = @"Remove";
    action2.destructive = YES;
    action2.activationMode = UIUserNotificationActivationModeBackground;  // won't bring app to foreground
 
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"Test_Category";
    [category setActions:@[action, action2] forContext:UIUserNotificationActionContextDefault];
    
    // register user notification setting
    UIUserNotificationType type = (UIUserNotificationType)(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:[NSSet setWithObject:category]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    [self renumberBadgesOfPendingNotifications];
    // handle local notifications
    id obj = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if ([obj isKindOfClass:[UILocalNotification class]]) {
        
        UILocalNotification *notification = (UILocalNotification*)obj;
        [self application:application didReceiveLocalNotification:notification];
    } else {
        // cannot be NSDictionary, app will handle notifications one by one when there are multiple ones.
        /*
        if ([obj isKindOfClass:[NSDictionary class]]) {
            ViewController * vc = (ViewController*)self.window.rootViewController;
            if (vc) {
                NSLog(@"is dictionary");
                [vc setLableText:@"multiple notifications"];
            }
        }
        */
        NSLog(@"no local notifications !!!");
    }
    return YES;
}

- (void)renumberBadgesOfPendingNotifications
{
    // clear the badge on the icon
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // first get a copy of all pending notifications (unfortunately you cannot 'modify' a pending notification)
    NSArray *pendingNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // if there are any pending notifications -> adjust their badge number
    NSLog(@"pending notifications is %lu", (unsigned long)pendingNotifications.count);
    if (pendingNotifications.count != 0)
    {
        // clear all pending notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // the for loop will 'restore' the pending notifications, but with corrected badge numbers
        // note : a more advanced method could 'sort' the notifications first !!!
        NSUInteger badgeNbr = 1;
        
        for (UILocalNotification *notification in pendingNotifications)
        {
            // modify the badgeNumber
            notification.applicationIconBadgeNumber = badgeNbr++;
            
            // schedule 'again'
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"notification.alertBody=%@", notification.alertBody);
    ViewController * vc = (ViewController*)self.window.rootViewController;
    [vc setTextViewValue:[NSString stringWithFormat:@"notification.alertBody=%@", notification.alertBody]];
    //application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"handleActionForLocalNotification");
    if ([notification.category isEqualToString:@"Test_Category"]) {
        if ([identifier isEqualToString:@"Check_Action"]) {
            NSLog(@"!!! Wonderful !!!");
        }
    }
    if (completionHandler) {
        completionHandler();
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

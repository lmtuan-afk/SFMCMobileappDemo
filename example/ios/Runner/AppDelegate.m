// AppDelegate.m
//
// Copyright (c) 2024 Salesforce, Inc
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. Redistributions in binary
// form must reproduce the above copyright notice, this list of conditions and
// the following disclaimer in the documentation and/or other materials
// provided with the distribution. Neither the name of the nor the names of
// its contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <MarketingCloudSDK/MarketingCloudSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    // Configure the SFMC SDK with credentials from your dashboard
    PushConfigBuilder *pushConfigBuilder = [[PushConfigBuilder alloc] initWithAppId:@"f57a747e-6049-4a98-9747-fb025d6e8d20"];
    [pushConfigBuilder setAccessToken:@"Fr3jdqbGddFTdbUeZT40HxcT"];
    [pushConfigBuilder setMarketingCloudServerUrl:[NSURL URLWithString:@"https://mc74d-zldsh3xmctth61b74fn3my.device.marketingcloudapis.com/"]];
    
    // TODO: Replace YOUR_MID_HERE with your 7-9 digit MID from the MC Dashboard
    [pushConfigBuilder setMid:@"100006104"]; 
    
    [pushConfigBuilder setAnalyticsEnabled:YES];
    [pushConfigBuilder setInboxEnabled:YES];

    // Initialize the SDK
    [SFMCSdk initializeSdk:[[[SFMCSdkConfigBuilder new] setPushWithConfig:[pushConfigBuilder build] onCompletion:^(SFMCSdkOperationResult result) {
        if (result == SFMCSdkOperationResultSuccess) {
            [self pushSetup];
        } else {
            NSLog(@"SFMC sdk configuration failed.");
        }
    }] build]];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)pushSetup {
    // Set the URLHandlingDelegate to handle CloudPages and deep links
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setURLHandlingDelegate:self];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set the UNUserNotificationCenter delegate
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
        // Register for remote notifications to get the device token
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        // Request authorization for push alerts, sounds, and badges
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
         UNAuthorizationOptionSound |
         UNAuthorizationOptionBadge
         completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (error == nil) {
                if (granted == YES) {
                    NSLog(@"User granted permission");
                }
            }
        }];
    });
}

// Pass the device token to the SFMC SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setDeviceToken:deviceToken];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

// Handle notification responses (user opening the app from a push)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setNotificationResponse:response];
    }];
    if (completionHandler != nil) {
        completionHandler();
    }
}

// Display notifications when the app is in the foreground
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

// Handle remote notification data
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [SFMCSdk requestPushSdk:^(id<PushInterface> _Nonnull mp) {
        [mp setNotificationUserInfo:userInfo];
    }];
    completionHandler(UIBackgroundFetchResultNewData);
}

// URL Handling Implementation
- (void)sfmc_handleURL:(NSURL * _Nonnull)url type:(NSString * _Nonnull)type {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"url %@ opened successfully", url);
            } else {
                NSLog(@"url %@ could not be opened", url);
            }
        }];
    }
}

@end
//
//  AppDelegate.m
//  BitVote
//
//  Created by Yair Szarf on 1/10/15.
//  Copyright (c) 2015 2 Handed Coding. All rights reserved.
//

#import "AppDelegate.h"
#import "BVUser.h"
#import "BVCandidate.h"

#define PARSE_APP_ID @"vdBJnnYkkdrXV4Fo5pbpOB8YB7X7btL9OE6HDga2"
#define PARSE_CLIENT_KEY @"mrWBIasJTTnoB0mjZkcOhpveBbfYIhODKFQr139H"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self registerModelClasses];
    [Parse setApplicationId:PARSE_APP_ID
                  clientKey:PARSE_CLIENT_KEY];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;
}

- (void) registerModelClasses
{
    [BVUser registerSubclass];
    [BVCandidate registerSubclass];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void) populateCandidates
//{
//    NSDictionary * candidates = @{
//                                  @"Main address" : @"1HkV3wxQD1AjEQyXsnUYGp3f28p8Jfc5NV",
//                                  @"PartyPeople" : @"1F3zpKpBEWuCKcerPwcgkBf4uaJBMtLEQd",
//                                  @"blackjincrypto" : @"1JmHqfC35PWxVfvSvXLhaiSXzHvieT17L3",
//                                  @"Wyncode" : @"19VJRhQWw68YULWbDmXGCTvZRtYy1HMAvc",
//                                  @"Kodelia" : @"1C8uGvm49sDZw9FuCqziagSgNyYuU3QBqu",
//                                  @"FrostWire" : @"1PmWPxe2yFkonqSJuTxzVNUTaX6dyj5Mmq",
//                                  @"Prestashop - 42" : @"1if8oU3Du4ivjP8kwDteRJqgKVuFfqPun",
//                                  @"PopCode" : @"1GeWA7no9QvCjayy8PE9o9RKJ3pwzG5RGL",
//                                  @"BitFlo" : @"1NCSBpWbxm88J9sotT2hNTmxyE37pnx14h",
//                                  @"Project ABE" : @"131QaU1BQquiW5HGf1nhMNKh8jtNm64Zxp",
//                                  @"Team Democracy" : @"1MXraDzgVswaU3GFkBNi5tobXSstfC8ZC2",
//                                  @"AudioBits" : @"1CRgtu6gQ3ZUf48j5WASgDwE5ibNd24pYu",
//                                  @"PayByFriend" : @"19i1Ec1eR4SvKo332spj6n7QFQXLBJdwuc",
//                                  @"Team microtip extension" : @"1E6uRFALz6eiD5g7fWMyMb9FYTgvDF846v",
//                                  @"Silver Wind" : @"1DMEGYAwEh2EHu1eBcdoypKTFaon41MmuZ",
//                                  @"BitPlayers" : @"16pMYaFNwM4mYRezkuXcMv5GMESH1aam8q",
//                                  @"BitRocket" : @"1AyidGSyxWEDtwKtHXfuw28RKjt7bGBNve",
//                                  @"Decentral Team" : @"1Bg4q2vdpXobvPRu41rQEYfN5wFiHtuQQD",
//                                  @"blockchain_badges" : @"1N8fQ1D9R4Nv7JQmxPddpHMAnu7DXLKwFE",
//                                  @"Bitcoin Exchange" : @"14QhxwpwCGxya2RhPLSXCLTTdegF54UE3H"
//                                  };
//    for (NSString * key in [candidates allKeys]) {
//        BVCandidate * can = [BVCandidate object];
//        can.fullName = key;
//        can.publicAddress = candidates[key];
//        can.electionID = @"Hackathon";
//        [can save];
//    }
//}

@end

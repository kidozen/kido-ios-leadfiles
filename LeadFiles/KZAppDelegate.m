//
//  KZAppDelegate.m
//  LeadFiles
//
//  Created by Christian Carnero on 4/29/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import "KZAppDelegate.h"
#import "KZShareFileController.h"
#import "DDMenuController.h"
#import "KZSalesForceLeadsController.h"
#import "KZSplashViewController.h"
#include "TargetConditionals.h"

#import "MDXSDK.h"

@interface KZAppDelegate ()
@property (nonatomic, strong) KZSplashViewController * splashViewController;
@end

@implementation KZAppDelegate

@synthesize window = _window;
@synthesize menuController = _menuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _splashViewController = [[KZSplashViewController alloc] init];
    self.window.rootViewController = _splashViewController;
    
    [self.window makeKeyAndVisible];
    [self performSelector:@selector(initializeKidoZen:) withObject:nil afterDelay:0];
    
    return YES;
}
							
-(void)initializeKidoZen:(id) object
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kidozenInitializationErrortHandler:) name:KZOnKidoZenInitializationError object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kidozenShareFileErrortHandler:) name:KZShareFileError object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kidozenErrortHandler:) name:KZPushNotificationError object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kidozenErrortHandler:) name:KZSalesForceError object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kidozenErrortHandler:) name:KZStorageError object:nil ];
    
    
    [self registerDefaultsFromSettingsBundle:@"Root"];
    [[KidoZen sharedApplication] getFilesFromShareFilePath:@"/" withBlock:^(id kidozenResponse) {
        [_splashViewController.startDemo setEnabled:YES];
        NSArray *filtered = [kidozenResponse filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(parentid != %@)", @"-1"]];
        self.shareFileRootContent = [NSMutableArray arrayWithArray:filtered];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

-(void) loadNavigatorsAndViews:(id) object
{
    KZShareFileController *mainController = [[KZShareFileController alloc] initWithNibName:@"KZShareFileController" bundle:nil];;
    [mainController setShareFileFoldersAndFiles:self.shareFileRootContent];
    [mainController setShareFilePath:@"/"];
    self.navigatorController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:self.navigatorController];
    _menuController = rootController;

    KZSalesForceLeadsController *leftController = [[KZSalesForceLeadsController alloc] init];
    rootController.leftViewController = leftController;
    
    self.window.rootViewController = rootController;
}

- (void)registerDefaultsFromSettingsBundle:(NSString *) plistfile
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs synchronize];
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistfile]]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for (NSDictionary *prefSpecification in preferences)
    {
        NSString * type =[prefSpecification objectForKey:@"Type"];
        if (![type isEqualToString:@"PSGroupSpecifier"]){
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if (key)
            {
                id currentObject = [defs objectForKey:key];
                if ([type isEqualToString:@"PSChildPaneSpecifier"]) {
                    NSString * file = [prefSpecification objectForKey:@"File"];
                    [self registerDefaultsFromSettingsBundle:file ];
                }
                else if (currentObject == nil ) // check if value readable in userDefaults
                {
                    id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                    [defaultsToRegister setObject:objectToSet forKey:key];
                }
            }
        }
    }
    [defs registerDefaults:defaultsToRegister];
    [defs synchronize];
}

//event handler when event occurs
-(void) kidozenErrortHandler: (NSNotification *) notification
{
    NSString * message =@"Error, close the app, close the application, check the application settings and try again";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void) kidozenInitializationErrortHandler: (NSNotification *) notification
{
    NSString * message =@"There was an error in the KidoZen initialization and Authentication process\nPlease close the application, check the application settings and try again.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void) kidozenShareFileErrortHandler :(NSNotification *) notification
{
    NSString * message = @"There was an error with the ShareFile operation. Please check the application settings and try again.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[KidoZen sharedApplication] setRemoteNotificationsDeviceToken:token];
}

@end

//
//  KZAppDelegate.h
//  LeadFiles
//
//  Created by Christian Carnero on 4/29/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DDMenuController.h"
#import "KidoZen.h"

@class KZShareFileController;

@interface KZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigatorController;
@property (strong, nonatomic) DDMenuController *menuController;

@property (strong, atomic) NSMutableArray * shareFileRootContent;

-(void) loadNavigatorsAndViews:(id) object;

@end

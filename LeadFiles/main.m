//
//  main.m
//  LeadFiles
//
//  Created by Christian Carnero on 4/29/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KZAppDelegate.h"

#import "MDXSDK.h"

int main(int argc, char *argv[])
{
    // Set the appropriate MDX mode for the app.
    [MDXSDK  CTXMDX_SetAppMode:MDX_APPMODE_GeneralAppStore];

    @autoreleasepool {
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([KZAppDelegate class]));
    }
}

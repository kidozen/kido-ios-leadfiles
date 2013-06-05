//
//  KZLeadSplashViewController.h
//  LeadFiles
//
//  Created by Christian Carnero on 5/6/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZSplashViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *helpWebView;
- (IBAction)startButtonTouchUp:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *startDemo;

@end

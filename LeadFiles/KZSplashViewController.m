//
//  KZLeadSplashViewController.m
//  LeadFiles
//
//  Created by Christian Carnero on 5/6/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import "KZSplashViewController.h"

@interface KZSplashViewController ()

@end

@implementation KZSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.startDemo.enabled = NO;
        [self.startDemo setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [self.startDemo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startDemo.enabled = NO;
    [self.startDemo setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.startDemo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTouchUp:(id)sender {
    [ThisApp loadNavigatorsAndViews:sender];
}


@end

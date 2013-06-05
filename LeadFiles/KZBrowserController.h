//
//  KZBrowserController.h
//  LeadFiles
//
//  Created by Christian Carnero on 5/14/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZBrowserController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate>
{
    NSURLConnection * cnn ;
    NSMutableData *responsedata;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString * fileUrl;
@property (strong, nonatomic) NSURLConnection * connection;

@end

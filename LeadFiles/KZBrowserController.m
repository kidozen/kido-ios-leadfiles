//
//  KZBrowserController.m
//  LeadFiles
//
//  Created by Christian Carnero on 5/14/13.
//  Copyright (c) 2013 KidoZen. All rights reserved.
//

#import "KZBrowserController.h"

@interface KZBrowserController ()

@end

@implementation KZBrowserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        responsedata = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
    
    NSURL *url = [NSURL URLWithString:self.fileUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self startImmediately:YES];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// WebView Delegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Failed to load document"
                                                  message:@"May be your device doesn't have an application to open the selected file type."
                                                 delegate:self
                                        cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [av show];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger cancelIndex = [alertView cancelButtonIndex];
    if (cancelIndex != -1 && cancelIndex == buttonIndex)
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"didFinishLoad");
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"didStartWebView");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSURL *url = [request URL];
//    if ([url isFileURL])
//        return YES;
//    [[UIApplication sharedApplication] openURL:url];
//    return YES;
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    return YES;
}

// URLConnection Delegate
//- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSHTTPURLResponse * res = (NSHTTPURLResponse *) response;
//    NSLog(@"%@ response", res.allHeaderFields);
//    NSLog(@"Did Receive Response %@", response);
//}
//- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
//{
//    [responsedata appendData:data];
//    NSLog(@"Did Receive Data %@", data);
//}
//- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
//{
//    NSLog(@"Did Fail");
//}
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSLog(@"Did Finish");
//}

@end

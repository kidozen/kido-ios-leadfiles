#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>

#import "KZHTTPClient.h"

enum {
	SVHTTPRequestMethodGET = 0,
    SVHTTPRequestMethodPOST,
    SVHTTPRequestMethodPUT,
    SVHTTPRequestMethodDELETE,
    SVHTTPRequestMethodHEAD
};

typedef NSUInteger KZHTTPRequestMethod;


@interface KZHTTPRequest : NSOperation

+ (KZHTTPRequest*)GET:(NSString*)address parameters:(NSDictionary*)parameters completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError *error))block;
+ (KZHTTPRequest*)GET:(NSString*)address parameters:(NSDictionary*)parameters saveToPath:(NSString*)savePath progress:(void (^)(float progress))progressBlock completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError *error))completionBlock;

+ (KZHTTPRequest*)POST:(NSString*)address parameters:(NSDictionary*)parameters completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError *error))block;
+ (KZHTTPRequest*)PUT:(NSString*)address parameters:(NSDictionary*)parameters completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError *error))block;
+ (KZHTTPRequest*)DELETE:(NSString*)address parameters:(NSDictionary*)parameters completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError *error))block;

+ (KZHTTPRequest*)HEAD:(NSString*)address parameters:(NSDictionary*)parameters completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError *error))block;

- (KZHTTPRequest*)initWithAddress:(NSString*)urlString 
                                  method:(KZHTTPRequestMethod)method 
                              parameters:(NSDictionary*)parameters 
                              completion:(void (^)(id response, NSHTTPURLResponse *urlResponse, NSError* error))completionBlock;

@property (nonatomic, readwrite) BOOL bypassSSLValidation;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, readwrite) BOOL sendParametersAsJSON;
@property (nonatomic, readwrite) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, strong) NSInputStream  *bodyStream;

@property (nonatomic, readwrite) NSDictionary *headers;

@end


// the following methods are only to be accessed from SVHTTPRequest.m and SVHTTPClient.m

@protocol KZHTTPRequestPrivateMethods <NSObject>

@property (nonatomic, strong) NSString *requestPath;

- (KZHTTPRequest*)initWithAddress:(NSString*)urlString 
                                  method:(KZHTTPRequestMethod)method 
                              parameters:(NSDictionary*)parameters 
                              saveToPath:(NSString*)savePath
                                progress:(void (^)(float))progressBlock
                              completion:(void (^)(id, NSHTTPURLResponse*, NSError*))completionBlock;

- (void)signRequestWithUsername:(NSString*)username password:(NSString*)password;

@end
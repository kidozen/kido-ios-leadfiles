//
//  KZApplication.h
//  KZApplication
//
//  Created on April 2013
//  Copyright 2013 KidoZen All rights reserved.
//

#import "KZBaseService.h"
#import "KZNotification.h"
#import "KZQueue.h"
#import "KZStorage.h"
#import "KZConfiguration.h"
#import "KZMail.h"
#import "KZSMSSender.h"
#import "KZLogging.h"
#import "KZService.h"

#if TARGET_OS_IPHONE
#import "KZPubSubChannel.h"
#endif
#import "KZAuthentication.h"
#import "KZWRAPv09IdentityProvider.h"
#import "KZHTTPRequest.h"


typedef void (^AuthCompletionBlock)(id);
typedef void (^TokenExpiresBlock)(id);

/**
 *
 * Main KidoZen application object
 *
 */
@interface KZApplication : KZBaseService <KZAuthentication>
{
    id<KZIdentityProvider>  ip ;
    NSString *_tennantMarketPlace;
    NSString *_applicationName;
    NSString *_notificationUrl;

    NSMutableDictionary * _queues;
    NSMutableDictionary * _configurations;
    NSMutableDictionary * _storages;
    NSMutableDictionary * _smssenders;
    NSMutableDictionary * _channels;
    NSMutableDictionary * _files;
    NSMutableDictionary * _services;
    
    __block NSTimer* tokenExpirationTimer ;
}

/**
 * Constructor
 *
 * @param tenantMarketPlace The url of the KidoZen marketplace
 * @param applicationName The application name
 * @param callback The ServiceEventListener callback with the operation results
 */
-(id) initWithTennantMarketPlace:(NSString *) tennantMarketPlace applicationName:(NSString *) applicationName andCallback:(void (^)(KZResponse *))callback;

/**
 * Constructor
 *
 * @param tenantMarketPlace The url of the KidoZen marketplace
 * @param application The application name
 * @param bypassSSLVerification Allows to bypass the SSL validation, use it only for development purposes
 * @param callback The ServiceEventListener callback with the operation results
 */
-(id) initWithTennantMarketPlace:(NSString *) tennantMarketPlace applicationName:(NSString *) applicationName bypassSSLValidation:(BOOL) bypassSSL andCallback:(void (^)(KZResponse *))callback;

@property (nonatomic, strong) NSMutableDictionary * identityProviders ;
@property (nonatomic, strong) NSDictionary * configuration ;
@property (nonatomic, strong) NSDictionary * securityConfiguration ;
@property (atomic) BOOL bypassSSLValidation ;

@property (nonatomic, strong) NSString * lastProviderKey;
@property (nonatomic, strong) NSString * lastUserName;
@property (nonatomic, strong) NSString * lastPassword;

@property (nonatomic, copy) AuthCompletionBlock authCompletionBlock;
@property (nonatomic, copy) TokenExpiresBlock tokenExpiresBlock;
@property (copy, nonatomic) void (^onInitializationComplete) (KZResponse *) ;

@property (strong, nonatomic) KZMail * mail;
@property (strong, nonatomic) KZLogging * log;
@property (strong, nonatomic) KZHTTPClient * defaultClient;

/**
 * Push notification service main entry point
 *
 * @return The Push notification object that allows to interact with the Apple Push Notification Services (APNS)
 */
@property (strong, nonatomic) KZNotification * pushNotifications;
/**
 * Creates a new Queue object
 *
 * @param name The name that references the Queue instance
 * @return a new Queue object
 */
-(KZQueue *) QueueWithName:(NSString *) name;
/**
 * Creates a new Storage object
 *
 * @param name The name that references the Storage instance
 * @return a new Storage object
 */
-(KZStorage *) StorageWithName:(NSString *) name;
/**
 * Creates a new Configuration object
 *
 * @param name The name that references the Configuration instance
 * @return a new Configuration object
 */
-(KZConfiguration *) ConfigurationWithName:(NSString *) name;
/**
 * Creates a new SMSSender object
 *
 * @param number The phone number to send messages.
 * @return a new SMSSender object
 */
-(KZSMSSender *) SMSSenderWithNumber:(NSString *) number;
#if TARGET_OS_IPHONE
/**
 * Creates a new PubSubChannel object
 *
 * @param name The name that references the channel instance
 * @return A new PubSubChannel object
 */
-(KZPubSubChannel *) PubSubChannelWithName:(NSString *) name;
#endif
/**
 * Sends an EMail
 *
 * @param to Destination email address
 * @param from Source email address
 * @param subject The email subject
 * @param htmlBody The email body in HTML format
 * @param textBody The email body
 * @param callback The callback with the result of the service call
 * @throws Exception
 */
-(void) sendMailTo:(NSString *)to from:(NSString *) from withSubject:(NSString *) subject andHtmlBody:(NSString *) htmlBody andTextBody:(NSString *)textBody  completion:(void (^)(KZResponse *))block;
/**
 * Creates a new entry in the KZApplication log
 *
 * @param message a NSDictionary object with the message to write
 * @param level The log level: Verbose, Information, Warning, Error, Critical
 * @throws Exception
 */
-(void) writeLog:(id) message withLevel:(LogLevel) level completion:(void (^)(KZResponse *))block;
/**
 * Clears the KZApplication log
 *
 * @param callback The callback with the result of the service call */
-(void) clearLog:(void (^)(KZResponse *))block;

/**
 * Creates a new entry in the KZApplication log
 *
 * @param callback The callback with the result of the service call
 */
-(void) allLogMessages:(void (^)(KZResponse *))block;

/**
 * Creates a new LOBService object
 *
 * @param name the service name.
 * @return a new LOBService object
 */
-(KZService *) LOBServiceWithName:(NSString *) name;

@end

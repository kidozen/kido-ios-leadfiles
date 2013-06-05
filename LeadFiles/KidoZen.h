#import <Foundation/Foundation.h>
#import "KZApplication.h"

FOUNDATION_EXPORT NSString *const KZOnKidoZenInitializationError;
FOUNDATION_EXPORT NSString *const KZShareFileError;
FOUNDATION_EXPORT NSString *const KZPushNotificationError;
FOUNDATION_EXPORT NSString *const KZSalesForceError;
FOUNDATION_EXPORT NSString *const KZStorageError;
FOUNDATION_EXPORT NSString *const KZEmailError;

FOUNDATION_EXPORT NSString *const KZ_PROVIDER_KEY;
FOUNDATION_EXPORT NSString *const KZ_SALESFORCE_SERVICEID;
FOUNDATION_EXPORT NSString *const KZ_SHAREFILE_SERVICEID;
FOUNDATION_EXPORT NSString *const KZ_STORAGEID;
FOUNDATION_EXPORT NSString *const KZ_CHANNEL;

FOUNDATION_EXPORT NSString *const KZ_SALESFORCE_QUERY_METHODID;
FOUNDATION_EXPORT NSString *const KZ_SALESFORCE_CREATE_METHODID;
FOUNDATION_EXPORT NSString *const KZ_SALESFORCE_COMUNITY_ID;

FOUNDATION_EXPORT NSString *const KZ_SHAREFILE_GETAUTHID_METHODID;
FOUNDATION_EXPORT NSString *const KZ_SHAREFILE_FILEGET_METHODID;
FOUNDATION_EXPORT NSString *const KZ_SHAREFILE_FILELINK_METHODID;
FOUNDATION_EXPORT NSString *const KZ_SHAREFILE_FOLDERLIST_METHODID;




typedef void (^queryDictionaryOperationBlock)(id kidozenResponse); //NSDictionary
typedef void (^queryArrayOperationBlock)(id kidozenResponse); //NSArray
typedef void (^operationResponseBlock)(id message);
typedef void (^initializationResponseBlock)(id kidozenResponse);
typedef void (^errorBlock)(NSError * err);

@interface KidoZen : NSObject
{

}

@property (strong, nonatomic) KZApplication * kido;

@property (strong, nonatomic) KZStorage * storage;
@property (strong, nonatomic) KZService * salesforce;
@property (strong, nonatomic) KZService * sharefile;

@property (strong, nonatomic) errorBlock errorBlock;

@property (strong, nonatomic) NSString * remoteNotificationsDeviceToken;

@property (strong, nonatomic) NSUserDefaults *settings ;



+ (KidoZen*)sharedApplication;

-(void) initApplicationAndAuthenticate;

//salesforce
-(void) getLeadsFromSalesforce:(queryArrayOperationBlock) response;

-(void) getLeadFromSalesforce:(NSString *) lead withBlock:(queryDictionaryOperationBlock) response ;

-(void) createIdeaForFile:(NSString *)fileUrl andLead:(NSString *) lead   withBlock:(operationResponseBlock) response ;

// fileshare
-(void) getDetails:(NSString *) file withBlock:(queryDictionaryOperationBlock) response;

-(void) getFilesFromShareFilePath:(NSString *) path withBlock:(queryArrayOperationBlock) response;

-(void) getFileLinkUsingFileId:(NSString *) file andPath:(NSString *) path withBlock:(operationResponseBlock) response;

//storage
-(void) assignFile:(NSString *)file toLead:(NSString *)lead withBlock:(operationResponseBlock) block ;

-(void) getFilesForLead:(NSString *)lead withBlock:(queryArrayOperationBlock ) response;

-(void) getFileOwners:(NSString *)file withBlock:(queryArrayOperationBlock ) response;

//Email
-(void) sendToEmail:(NSString *)mail fileUrl:(NSString *)file withBlock:(operationResponseBlock) block ;

@end

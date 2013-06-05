#import <Foundation/Foundation.h>
@class KZApplication;
/**
 * Service Event information. This class contains the result of a service invocation
 *
 * @author kidozen
 * @version 1.00, April 2013
 *
 */
@interface KZResponse : NSObject
{
};
-(id) initWithResponse:(id) response urlResponse:(NSHTTPURLResponse *) urlresponse andError:(NSError *) error;
/**
 * The service response. It could be a NSDictionary, an NSString or any other object
 */
@property (nonatomic, strong) id response;
/**
 * The underlying NSHTTPURLResponse object
 */
@property (nonatomic, strong) NSHTTPURLResponse * urlResponse;
/**
 * The last NSError is there was one
 */
@property (nonatomic, strong) NSError * error;
/**
 * The associated KZApplication
 */
@property (nonatomic, strong) KZApplication * application;
@property (nonatomic, strong) id source;
@end;

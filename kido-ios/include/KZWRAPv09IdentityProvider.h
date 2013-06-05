#import "KZIdentityProvider.h"
#import "KZHTTPClient.h"
/**
 * WRAP V 09 Identity Provider
 *
 * @author KidoZen
 * @version 1.00, April 2013
 */
@interface KZWRAPv09IdentityProvider : NSObject <KZIdentityProvider>
{
    NSString * _wrapName, *_wrapPassword, *_wrapScope;
}
@property (atomic) BOOL bypassSSLValidation ;
@property (nonatomic, strong) NSString * token;
@end

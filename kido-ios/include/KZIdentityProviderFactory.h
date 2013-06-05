#import <Foundation/Foundation.h>
#import "KZIdentityProvider.h"

@interface KZIdentityProviderFactory : NSObject
+(id<KZIdentityProvider>) createProvider:(NSString *) type bypassSSL:(BOOL) bypassSSL;
@end

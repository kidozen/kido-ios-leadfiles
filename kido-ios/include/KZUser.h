#import <Foundation/Foundation.h>
#import "NSString+Utilities.h"
/**
 * The kidozen user identity
 *
 * @author KidoZen
 * @version 1.00, April 2013
 *
 */
@interface KZUser : NSObject
{
    NSString * _kzToken;
}
-(id) initWithToken:(NSString *) token;
/**
 * Checks if the user belongs to the role
 * @param role
 * @return
 */
-(BOOL*) isInRole:(NSString *) role;
/**
 * The claims of this user
 */
@property (nonatomic, strong) NSMutableDictionary * claims;
/**
 * The Roles of this user
 */
@property (nonatomic, strong) NSArray * roles;
/**
 * The expiration in miliseconds
 */
@property (nonatomic) int expiresOn;
/**
 * The current user name
 */
@property (nonatomic, strong) NSString * user;
/**
 * The password
 */
@property (nonatomic, strong) NSString * pass;

@end

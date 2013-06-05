#import <Foundation/Foundation.h>

typedef void (^RequestTokenCompletionBlock)(NSString * token, NSError * error);

/**
 * Identity Provider interface
 *
 * Implement this interface in order to create customs identity providers
 * Kidozen implements a template method pattern to call the methods in the following order:
 * 1-Initialize
 * 2-BeforeRequestToken
 * 3-RequestToken
 * 4-AfterRequestToken
 *
 * @author kidozen
 * @version 1.00, April 2013
 *
 */

@protocol KZIdentityProvider <NSObject>
/**
 * Use it to pass some configuration data to use later in your provider
 *
 * @param configuration
 */
-(void) configure:(id) configuration;
/**
 * Initialization step
 *
 * @param username The user name of the user to be authenticate
 * @param password The password for the user
 * @param scope The identity scope
 */
-(void) initializeWithUserName:(NSString *)user password:(NSString *) andPassword andScope:(NSString *) scope;
/**
 * Implement this method to execute actions before the token request to the Identity Provider
 * @param params NSDictionary with data to use
 */
-(void) beforeRequestToken:(NSDictionary *) params;
/**
 * This method executes a request to the Identity Provider
 *
 * @param identityProviderUrl The identity provider endpoint
 * @param action
 */
-(void) requestToken:(NSString *) identityProviderUrl completion:(RequestTokenCompletionBlock)block;
/**
 * The following method is invoked after the token request to the Identity Provider
 *
 * @param params
 */
-(void) afterRequestToken:(NSDictionary *) params;

@end

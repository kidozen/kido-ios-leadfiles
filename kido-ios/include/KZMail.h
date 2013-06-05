#import "KZBaseService.h"
/**
 * Mail service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */
@interface KZMail : KZBaseService
/**
 * @param mail a NSDictionary with the information of the Email message to send. It must contain the following Keys: "to", "from", "subject", "htmlBody" and "textBody"
 * @param block The callback with the result of the service call
 */
-(void) send:(id)email completion:(void (^)(KZResponse *))block;
@end

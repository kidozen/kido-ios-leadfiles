#import "KZBaseService.h"
/**
 * Push notifications service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */
@interface KZNotification : KZBaseService
{
    NSString * deviceMacAddress;
}
/**
 * Subscribe the device to the channel
 *
 * @param deviceToken The Apple Push Notification Service ID associated with your application. For more information check this link {@link http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/ApplePushService/ApplePushService.html}
 * @param channel The name of the channel to push and receive messages
 * @param block The callback with the result of the service call
 */
-(void) subscribeDeviceWithToken:(NSString *)deviceToken toChannel:(NSString *) channel completion:(void (^)(KZResponse *))block;
/**
 * Retrieves all the subscriptions for the current device and subscription
 *
 * @param block The callback with the result of the service call
 */
-(void) getSubscriptions:(void (^)(KZResponse *))block;
/**
 * Unsubscribes from the channel
 *
 * @param deviceToken The Apple Push Notification Service ID associated with your application. For more information check this link {@link http://developer.apple.com/library/mac/#documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/ApplePushService/ApplePushService.html}
 * @param channel The name of the channel to push and receive messages
 * @param block The callback with the result of the service call
 */
-(void) unSubscribeDeviceUsingToken:(NSString *)deviceToken fromChannel:(NSString *) channel completion:(void (^)(KZResponse *))block;
/**
 * Push a message into the specified channel
 *
 * @param channel The name of the channel to push the message
 * @param notification The message to push in the channel
 * @param block The callback with the result of the service call
 */
-(void) pushNotification:(NSDictionary *) notification InChannel:(NSString *) channel completion:(void (^)(KZResponse *))block;

@end

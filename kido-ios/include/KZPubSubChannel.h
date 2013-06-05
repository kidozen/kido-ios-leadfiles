#import "KZBaseService.h"
#import "SRWebSocket.h"
/**
 * Publish and subscribe service interface
 *
 * @author kidozen
 * @version 1.00, April 2013
 */

typedef void (^WebSocketEventBlock)(id);

@interface KZPubSubChannel : KZBaseService <SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
}
@property (nonatomic, copy) WebSocketEventBlock webSocketCompletionEventBlock;
@property (retain, nonatomic) NSString * wsEndpoint;
@property (retain, nonatomic) NSString * channelName;

-(id)initWithEndpoint:(NSString *)endpoint wsEndpoint:(NSString *) wsEndpoint andName:(NSString *)name ;
/**
 * Publish a message into the channel
 *
 * @param block The message (NSDictionary) to publish
 * @param callback The callback with the result of the service call
 */
-(void) publish:(id)object completion:(void (^)(KZResponse *))block;
/**
 * Subscribe to the channel. Start receiving messages
 *
 * @param completionEventBlock The block with the message from the channel
 */
-(void) subscribe:(WebSocketEventBlock) completionEventBlock;
/**
 * Unsubscribe from the channel.Stops receiving messages
 */
-(void) unsubscribe:(WebSocketEventBlock) completionEventBlock;
@end


#import "KZBaseService.h"

@interface KZService : KZBaseService

-(void) invokeMethod:(NSString *) method withData:(id)data completion:(void (^)(KZResponse *))block;
//
//-(void) invokeMethod:(NSString *) method withData:(id)data andConfiguration:(NSDictionary *) configuration completion:(void (^)(KZResponse *))block;

@end

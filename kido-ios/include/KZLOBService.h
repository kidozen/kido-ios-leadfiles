
#import "KZBaseService.h"

@interface KZLOBService : KZBaseService

-(void) invokeMethod:(NSString *) method withData:(id)data completion:(void (^)(KZResponse *))block;

@end

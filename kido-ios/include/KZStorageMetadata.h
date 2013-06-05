#import <Foundation/Foundation.h>

@interface KZStorageMetadata : NSObject
{
    NSMutableDictionary * _serialized;
    NSMutableDictionary * _deserialized;
    NSMutableDictionary * _metadata;
}


@property (nonatomic, strong) NSString * _id;
@property (nonatomic, strong) NSString * createdBy;
@property (nonatomic, strong) NSDate * createdOn;
@property (nonatomic) BOOL isPrivate;
@property (nonatomic) NSInteger sync;
@property (nonatomic, strong) NSString * updatedBy;
@property (nonatomic, strong) NSDate * updatedOn;

@property (nonatomic, strong) NSString * createdOnAsString;
@property (nonatomic, strong) NSString * updatedOnAsString;

- (id) initWithDictionary:(NSDictionary *) dictionary;
- (NSDictionary *) serialize;
- (NSDictionary *) deserialize;
@end

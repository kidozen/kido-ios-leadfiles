#import <Foundation/Foundation.h>

@interface Query : NSObject
{
    NSMutableDictionary * _dictionary;
}
@property (nonatomic, strong) NSMutableDictionary *baseDictionary;

-(id) initWithName:(NSString *) name andObject:(id) object;
+(Query *) EqualsTo:(NSString *) name Object:(id)value;
+(Query *) ExistsName:(NSString *) name;
+(Query *) NonExistsName:(NSString *) name;
+(Query *) All:(NSString *)name allValues:(NSArray *) array;
+(Query *) ElementMatch:(NSString *)name withQuery:(Query *) query;
+(Query *) GratherThan:(NSString *) name Object:(id) value;
+(Query *) GratherThanOrEquals:(NSString *) name Object:(id) value;
+(Query *) LessThan:(NSString *) name Object:(id) value;
+(Query *) LessThanOrEquals:(NSString *) name Object:(id) value;
+(Query *) NotEquals:(NSString *) name Object:(id)value;
+(Query *) In:(NSString *)name allValues:(NSArray *) array;
+(Query *) NotIn:(NSString *)name allValues:(NSArray *) array;
+(Query *) Matches:(NSString *) name Object:(id)value;
+(Query *) Mod:(NSString *)name withModulus:(long)modulus andValue:(long) value;
+(Query *) And:(NSArray *) queries;
+(Query *) Or:(NSArray *) queries;

+(Query *) Near:(NSString *) name x:(double)x y:(double)y spherical:(bool) spherical;
+(Query *) Near:(NSString *) name x:(double)x y:(double)y maxDistance:(double) maxdistance spherical:(bool) spherical;
@end

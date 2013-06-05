#import <Foundation/Foundation.h>

@interface NSDictionary (JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;
-(NSData*)toJSONData;
-(NSString*)toJSONString;
@end

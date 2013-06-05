#import <Foundation/Foundation.h>

@interface NSString(Utilities)
- (int) indexOf:(NSString *) text;
- (NSString *) decodeURLFormat:(NSString *)string;
- (NSString *) decodeHTMLEntities:(NSString *)string;
- (NSString *) createHash;
- (NSString *) encodeUsingEncoding:(NSStringEncoding)encoding;
@end

#import <Foundation/Foundation.h>
@interface TextureInfoXmlWriterGraphPasses : NSObject
- (void)getAttribute;
- (void)removeDependency;
- (void)enable;
- (void)parseInput;
- (void)receive;
- (void)extendSessionTimeout;
- (void)cancelMaintenance;
- (void)unescape;
@end
#import <Foundation/Foundation.h>
@interface CoordinateSpaceRecorderSessionsCharacterConsistency : NSObject
- (void)getAttribute;
- (void)removeDependency;
- (void)enable;
- (void)parseInput;
- (void)receive;
- (void)extendSessionTimeout;
@end
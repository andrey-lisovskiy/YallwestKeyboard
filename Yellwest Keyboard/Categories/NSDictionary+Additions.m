#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (id)objectForKeyOrNil:(id)aKey {
    id obj = [self objectForKey:aKey];
    return obj == (id)[NSNull null] ? nil : obj;
}

@end

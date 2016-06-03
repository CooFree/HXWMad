//
//  JsonModelBase.h
//  JsonModelBase
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//

@interface JsonModelBase : NSObject <NSCoding>

//遇到数组，数组内元素%@_class
+ (id)objectFromDictionary:(NSDictionary*)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)toDictionary;

@end

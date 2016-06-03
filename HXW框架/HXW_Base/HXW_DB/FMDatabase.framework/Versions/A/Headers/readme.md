ios平台下的数据库管理库
需系统库libsqlite3.0.dylib支持


通过数据模型对数据库进行增删改查操作，数据模型内数据类型支持：
1、基本类型：int float double long char bool等
2、objectice-c类型：NSString, NSNumber, NSData, NSDate, NSImage, NSArray, NSDictinary, NSDecimalNumber
NSMutableData, NSMutableArray, NSMutableDictinary, NSSet, NSMutableSet, NSMutableString, LKModelBase子类
=======================================================================================================
支持创建多个数据库文件，所有配置通过“DBConfig.plist”来配置。
支持主键，如果是联合主键的话每个主键之间需用逗号分割。

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>dbName1.db</key>
	<array>
		<dict>
			<key>tableName</key>
			<string>Test</string>
			<key>modelName</key>
			<string>TestModel</string>
			<key>primaryKey</key>
			<string>key1,key2</string>
		</dict>
	</array>
</dict>
</plist>
=======================================================================================================

数据模型类似如下
@interface TestModel:LKModelBase
@property(retain,nonatomic)NSString *Bid;
@property(retain,nonatomic)NSString *StoreName;
@property(retain,nonatomic)NSString *Longitude;
@property(retain,nonatomic)NSString *Latitude;
@property(assign,nonatomic)float mytest;
@property(retain,nonatomic)NSNumber* number;
@property(retain,nonatomic)NSDate* date;
@property(retain,nonatomic)NSArray* array;
@property(retain,nonatomic)NSDictionary* dict;
@end

@implementation TestModel
@synthesize Bid;
@synthesize StoreName;
@synthesize Longitude;
@synthesize Latitude;
@synthesize mytest;
@synthesize number;
@synthesize date;
@synthesize array, dict;


-(void)dealloc {
    self.Bid = nil;
    self.StoreName = nil;
    self.Latitude = nil;
    self.Longitude = nil;
    self.number = nil;
    self.date = nil;
    self.array = nil;
    self.dict = nil;
    [super dealloc];
}
@end

=======================================================================================================
数据库操作如下
- (IBAction)Btn_AddData:(id)sender {
    TestModel *model=[[[TestModel alloc]init]autorelease];
    model.Bid=@"1";
    model.StoreName=@"测试";
    model.Latitude=@"11";
    model.Longitude=@"22";
    model.mytest = .111;
    model.number = @1009;
    model.date = [NSDate date];
    model.array = @[@"1234", @"5678"];
    model.dict = @{@"jkk":@"kjliwiwo", @"kjj":@10};
    [[DataFactory shardFactory] insertToDB:model];
}
//也可以删除全部数据,也可以根据条件删除，自己看工厂的里面的方法
- (IBAction)Btn_DeleteData:(id)sender {
    TestModel *model=[[[TestModel alloc]init]autorelease];
    model.Bid=@"1";
    model.StoreName=@"测试";
    model.Latitude=@"11";
    model.Longitude=@"22";
    model.mytest = .112;
    model.number = @(101);
    model.date = [NSDate date];
    [[DataFactory shardFactory] deleteToDB:model];
}

- (IBAction)Btn_Update:(id)sender {
    TestModel *model=[[[TestModel alloc]init]autorelease];
    model.Bid=@"1";
    model.StoreName=@"测试";
    model.Latitude=@"22222";
    model.Longitude=@"22222";
    model.mytest = .113;
    model.number = @(102);
    model.date = [NSDate date];
    [[DataFactory shardFactory] updateToDB:model];
}

- (IBAction)Btn_Select:(id)sender {
    [[DataFactory shardFactory] searchWhere:@{@"Bid":@(1)}
                                    orderBy:nil
                                     offset:0
                                      count:100
                                      Class:[TestModel class]
                                   callback:^(NSArray *result) {
        NSLog(@"%@",result);
    }];
}

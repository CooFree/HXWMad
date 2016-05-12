//
//  HYBNetworking.m
//  AFNetworkingDemo
//
//  Created by huangyibiao on 15/11/15.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "HYBNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"

// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define HYBAppLog(s, ... ) NSLog( @"[%@：in line: %d]-->%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define HYBAppLog(s, ... )
#endif

//这边static静态变量，可以对HYBNetworking全局设置，和单例的效果类似
static NSString *sg_privateNetworkBaseUrl = nil;
static BOOL sg_isEnableInterfaceDebug = NO;
static BOOL sg_shouldAutoEncode = NO;
static NSDictionary *sg_httpHeaders = nil;
static HYBResponseType sg_responseType = kHYBResponseTypeJSON;
static HYBRequestType  sg_requestType  = kHYBRequestTypeJSON;

@implementation HYBNetworking

+ (void)updateBaseUrl:(NSString *)baseUrl {
  sg_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
  return sg_privateNetworkBaseUrl;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug {
  sg_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug {
  return sg_isEnableInterfaceDebug;
}

+ (void)configResponseType:(HYBResponseType)responseType {
  sg_responseType = responseType;
}

+ (void)configRequestType:(HYBRequestType)requestType {
  sg_requestType = requestType;
}

+ (void)shouldAutoEncodeUrl:(BOOL)shouldAutoEncode {
  sg_shouldAutoEncode = shouldAutoEncode;
}

+ (BOOL)shouldEncode {
  return sg_shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
  sg_httpHeaders = httpHeaders;
}

+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", status);
    }];
}

+ (HYBURLSessionTask *)getWithUrl:(NSString *)url
                          success:(HYBResponseSuccess)success
                             fail:(HYBResponseFail)fail {
  return [self getWithUrl:url params:nil success:success fail:fail];
}

+ (HYBURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(HYBResponseSuccess)success
                             fail:(HYBResponseFail)fail {
  return [self getWithUrl:url params:params progress:nil success:success fail:fail];
}

+ (HYBURLSessionTask *)getWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                         progress:(HYBGetProgress)progress
                          success:(HYBResponseSuccess)success
                             fail:(HYBResponseFail)fail {
  return [self _requestWithUrl:url
                     httpMedth:1
                        params:params
                      progress:progress
                       success:success
                          fail:fail];
}

+ (HYBURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                           success:(HYBResponseSuccess)success
                              fail:(HYBResponseFail)fail {
  return [self postWithUrl:url params:params progress:nil success:success fail:fail];
}

+ (HYBURLSessionTask *)postWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                          progress:(HYBPostProgress)progress
                           success:(HYBResponseSuccess)success
                              fail:(HYBResponseFail)fail {
  return [self _requestWithUrl:url
                     httpMedth:2
                        params:params
                      progress:progress
                       success:success
                          fail:fail];
}

//get ： 1/post ： 2请求
/*
 get/post方法在AFURLSessionManager中都会走NSURLSessionDataTask
 get方式以显式提交表单，可以在URL（地址栏）看见我们传的参数
 post方式是隐式传值，不可见。
 */
+ (HYBURLSessionTask *)_requestWithUrl:(NSString *)url
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                              progress:(HYBDownloadProgress)progress
                               success:(HYBResponseSuccess)success
                                  fail:(HYBResponseFail)fail {
  AFHTTPSessionManager *manager = [self manager];
  
  if ([self baseUrl] == nil) {
    if ([NSURL URLWithString:url] == nil) {
      HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  } else {
    if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
      HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  }
  
  if ([self shouldEncode]) {
    url = [self encodeUrl:url];
  }
  
  HYBURLSessionTask *session = nil;
  
  if (httpMethod == 1) {
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
      if (progress) {
        progress(downloadProgress,downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
      }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      [self successResponse:responseObject callback:success];
      
      if ([self isDebug]) {
        [self logWithSuccessResponse:responseObject
                                 url:task.response.URL.absoluteString
                              params:params];
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (fail) {
        fail(error);
      }
      
      if ([self isDebug]) {
        [self logWithFailError:error url:task.response.URL.absoluteString params:params];
      }
    }];
  } else if (httpMethod == 2) {
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
      if (progress) {
        progress(downloadProgress,downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
      }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      [self successResponse:responseObject callback:success];
      
      if ([self isDebug]) {
        [self logWithSuccessResponse:responseObject
                                 url:task.response.URL.absoluteString
                              params:params];
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (fail) {
        fail(error);
      }
      
      if ([self isDebug]) {
        [self logWithFailError:error url:task.response.URL.absoluteString params:params];
      }
    }];
  }
  
  return session;
}

//Multipart/form-data其实就是浏览器用表单上传文件的方式。最常见的情境是：在写邮件时，向邮件后添加附件，附件通常使用表单添加，也就是用multipart/form-data格式上传到服务器。
//http://blog.csdn.net/yankai0219/article/details/8159701
+ (HYBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(HYBUploadProgress)progress
                                 success:(HYBResponseSuccess)success
                                    fail:(HYBResponseFail)fail {
    if ([NSURL URLWithString:url] == nil&&![self shouldEncode]) {
        HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
  
  NSURL *uploadURL = nil;
  if ([self baseUrl] == nil) {
    uploadURL = [NSURL URLWithString:url];
  } else {
    uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
  }
  
  AFHTTPSessionManager *manager = [self manager];
  NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    NSURL *filePath = [NSURL fileURLWithPath:uploadingFile];
  HYBURLSessionUploadTask *session = [manager uploadTaskWithRequest:request fromFile:filePath progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progress) {
      progress(uploadProgress,uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    }
  } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    if (error) {
      if (fail) {
        fail(error);
      }
      
      if ([self isDebug]) {
        [self logWithFailError:error url:response.URL.absoluteString params:nil];
      }
    } else {
        if (success) {
            [self successResponse:responseObject callback:success];
        }
      if ([self isDebug]) {
        [self logWithSuccessResponse:responseObject
                                 url:response.URL.absoluteString
                              params:nil];
      }
    }
  }];
    [session resume];
  return session;
}


+ (HYBURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                              progress:(HYBUploadProgress)progress
                               success:(HYBResponseSuccess)success
                                  fail:(HYBResponseFail)fail {
    if ([NSURL URLWithString:url] == nil) {
        HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
  
  if ([self shouldEncode]) {
    url = [self encodeUrl:url];
  }
    NSURL *downLoadURL = nil;
    if ([self baseUrl] == nil) {
        downLoadURL = [NSURL URLWithString:url];
    } else {
        downLoadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }
  
  AFHTTPSessionManager *manager = [self manager];
    //Multipart/form-data其实就是浏览器用表单上传文件的方式。最常见的情境是：在写邮件时，向邮件后添加附件，附件通常使用表单添加，也就是用multipart/form-data格式上传到服务器。
    //http://blog.csdn.net/yankai0219/article/details/8159701

  HYBURLSessionTask *session = [manager POST:downLoadURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
      /*
       UIImageJPEGRepresentation方法在耗时上比较少 而UIImagePNGRepresentation耗时操作时间比较长
       使用UIImagePNGRepresentation取得照片时候可能会造成卡顿的现象
       在Iphone上有两种读取图片数据的简单方法: UIImageJPEGRepresentation和UIImagePNGRepresentation.
       
       UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数.而UIImagePNGRepresentation只需要图片引用作为参数.通过在实际使用过程中,比较发现: UIImagePNGRepresentation(UIImage* image) 要比UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量大很多.譬如,同样是读取摄像头拍摄的同样景色的照片, UIImagePNGRepresentation()返回的数据量大小为199K ,而 UIImageJPEGRepresentation(UIImage* image, 1.0)返回的数据量大小只为140KB,比前者少了50多KB.如果对图片的清晰度要求不高,还可以通过设置 UIImageJPEGRepresentation函数的第二个参数,大幅度降低图片数据量.譬如,刚才拍摄的图片, 通过调用UIImageJPEGRepresentation(UIImage* image, 1.0)读取数据时,返回的数据大小为140KB,但更改压缩系数后,通过调用UIImageJPEGRepresentation(UIImage* image, 0.5)读取数据时,返回的数据大小只有11KB多,大大压缩了图片的数据量 ,而且从视角角度看,图片的质量并没有明显的降低.因此,在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小.
       */
    
    NSString *imageFileName = filename;
    if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = @"yyyyMMddHHmmss";
      NSString *str = [formatter stringFromDate:[NSDate date]];
      imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
    }
    
    // 上传图片，以文件流的格式
    [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
  } progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progress) {
      progress(uploadProgress,uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    }
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [self successResponse:responseObject callback:success];
    
    if ([self isDebug]) {
      [self logWithSuccessResponse:responseObject
                               url:task.response.URL.absoluteString
                            params:parameters];
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    if (fail) {
      fail(error);
    }
    
    if ([self isDebug]) {
      [self logWithFailError:error url:task.response.URL.absoluteString params:nil];
    }
  }];
  return session;
}

+ (HYBURLSessionDownloadTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(HYBDownloadProgress)progressBlock
                               success:(HYBResponseSuccess)success
                               failure:(HYBResponseFail)failure {
    if ([NSURL URLWithString:url] == nil) {
        HYBAppLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    NSURL *downLoadURL = nil;
    if ([self baseUrl] == nil) {
        downLoadURL = [NSURL URLWithString:url];
    } else {
        downLoadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
    }

   NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:downLoadURL];
  AFHTTPSessionManager *manager = [self manager];
    //此处NSURLSessionDownloadTask用这个返回获取task任务后可以执行取消操作
    HYBURLSessionDownloadTask *session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress,downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
    }destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //1:内部生成地址
        //临时文件
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        NSURL *pathURL = [documentsDirectoryURL URLByAppendingPathComponent:saveToPath];
//        [[NSFileManager defaultManager] createDirectoryAtURL:pathURL withIntermediateDirectories:YES attributes:nil error:nil];
//
//        return [pathURL URLByAppendingPathComponent:[response suggestedFilename]];
        //2:外部传入地址
        //suggestedFilename文件名
        // URLWithString返回的是网络的URL,如果使用本地URL,需要使用fileURLWithPath
        return [[NSURL fileURLWithPath:saveToPath] URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else
        {
            if (success) {
                success(filePath);
            }
        }
        HYBAppLog(@"File downloaded to: %@＝＝＝＝%@", filePath,error);
    }];
  [session resume];
  return session;
}

#pragma mark - Private
+ (AFHTTPSessionManager *)manager {
  // 开启状态栏转圈圈
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
  AFHTTPSessionManager *manager = nil;
    //默认会话
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];//default磁盘缓存内存缓存都有
    //设置缓存策略  http://www.bkjia.com/IOSjc/1042429.html
    NSURLCache *urlCache = [[NSURLCache alloc]initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:0 * 1024 * 1024 diskPath:nil];//内存缓存4M硬盘缓存20M
    [NSURLCache setSharedURLCache:urlCache];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    //设置请求超时时间为5秒
    configuration.timeoutIntervalForRequest = 5;
  if ([self baseUrl] != nil) {
      //创建会话
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]] sessionConfiguration:configuration];
  } else {
    manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
  }
  //设置请求格式
  switch (sg_requestType) {
    case kHYBRequestTypeJSON: {
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
      [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];//指定客户端能够接收的内容类型
      [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      break;//请求的与实体对应的MIME信息
    }
    case kHYBRequestTypePlainText: {
      manager.requestSerializer = [AFHTTPRequestSerializer serializer];
      break;
    }
    default: {
      break;
    }
  }
  
 //设置返回格式
  switch (sg_responseType) {
    case kHYBResponseTypeJSON: {
      manager.responseSerializer = [AFJSONResponseSerializer serializer];
      break;
    }
    case kHYBResponseTypeXML: {
      manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
      break;
    }
    case kHYBResponseTypeData: {
      manager.responseSerializer = [AFHTTPResponseSerializer serializer];
      break;
    }
    default: {
      break;
    }
  }
  
  manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
  
  
  for (NSString *key in sg_httpHeaders.allKeys) {
    if (sg_httpHeaders[key] != nil) {
      [manager.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
    }
  }
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                            @"text/html",
                                                                            @"text/json",
                                                                            @"text/plain",
                                                                            @"text/javascript",
                                                                            @"text/xml",
                                                                            @"image/*"]];
  
  // 设置允许同时最大并发数量，过大容易出问题
  manager.operationQueue.maxConcurrentOperationCount = 3;
  return manager;
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
  HYBAppLog(@"\nabsoluteUrl: %@\n params:%@\n response:%@\n\n",
            [self generateGETAbsoluteURL:url params:params],
            params,
            [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(NSDictionary *)params {
  HYBAppLog(@"\nabsoluteUrl: %@\n params:%@\n errorInfos:%@\n\n",
            [self generateGETAbsoluteURL:url params:params],
            params,
            [error localizedDescription]);
}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params {
  if (params.count == 0) {
    return url;
  }
  
  NSString *queries = @"";
  for (NSString *key in params) {
    id value = [params objectForKey:key];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
      continue;
    } else if ([value isKindOfClass:[NSArray class]]) {
      continue;
    } else if ([value isKindOfClass:[NSSet class]]) {
      continue;
    } else {
      queries = [NSString stringWithFormat:@"%@%@=%@&",
                 (queries.length == 0 ? @"&" : queries),
                 key,
                 value];
    }
  }
  
  if (queries.length > 1) {
    queries = [queries substringToIndex:queries.length - 1];
  }
  
  if (([url rangeOfString:@"http://"].location != NSNotFound
      || [url rangeOfString:@"https://"].location != NSNotFound)
      && queries.length > 1) {
    if ([url rangeOfString:@"?"].location != NSNotFound
        || [url rangeOfString:@"#"].location != NSNotFound) {
      url = [NSString stringWithFormat:@"%@%@", url, queries];
    } else {
      queries = [queries substringFromIndex:1];
      url = [NSString stringWithFormat:@"%@?%@", url, queries];
    }
  }
  
  return url.length == 0 ? queries : url;
}


+ (NSString *)encodeUrl:(NSString *)url {
  return [self hyb_URLEncode:url];
}

+ (id)tryToParseData:(id)responseData {
  if ([responseData isKindOfClass:[NSData class]]) {
    // 尝试解析成JSON
    if (responseData == nil) {
      return responseData;
    } else {
      NSError *error = nil;
      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
      
      if (error != nil) {
        return responseData;
      } else {
        return response;
      }
    }
  } else {
    return responseData;
  }
}

+ (void)successResponse:(id)responseData callback:(HYBResponseSuccess)success {
  if (success) {
    success([self tryToParseData:responseData]);
  }
}

+ (NSString *)hyb_URLEncode:(NSString *)url {
  NSString *newString =
  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                            (CFStringRef)url,
                                                            NULL,
                                                            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
  if (newString) {
    return newString;
  }
  
  return url;
}

@end

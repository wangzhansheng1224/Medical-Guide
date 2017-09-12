//
//  WZSRequestHttp.h
//  YiYao
//
//  Created by wzs on 16/6/17.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    GET,
    POST
}NetRequestType;
typedef void(^HttpBlock)(NSData *data,NSError *error);
@interface WZSRequestHttp : NSObject
+ (void)requestData:(NetRequestType)type Url:(NSString *)url parameter:(NSString *)para andHttpBlock:(HttpBlock)httpRequestBlock;
@end

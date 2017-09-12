//
//  WZSRequestHttp.m
//  YiYao
//
//  Created by wzs on 16/6/17.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSRequestHttp.h"

@implementation WZSRequestHttp
+ (void)requestData:(NetRequestType)type Url:(NSString *)url parameter:(NSString *)para andHttpBlock:(HttpBlock)httpRequestBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (type==GET) {
        [manager GET:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            httpRequestBlock(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            httpRequestBlock(nil,error);
        }];
    }else{
        [manager POST:url parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            httpRequestBlock(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            httpRequestBlock(nil,error);
        }];
    }
}
@end

//
//  WebService.m
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//

#import "WebService.h"

@implementation WebService
+(void)executequery:(NSString *)strurl strpremeter:(NSString *)premeter withblock:(void (^)(NSData *, NSError *))block
{
    //Se crea la sesión.
    NSURLSessionConfiguration *defaultconfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];//New Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultconfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];//Queue is Strong and retrieve data FIFO
    
    NSURL *urlrequest = [NSURL URLWithString:strurl];
    NSMutableURLRequest*mutablerequest = [NSMutableURLRequest requestWithURL:urlrequest];
    
    NSString * parm = premeter;//Method y Body
    [mutablerequest setHTTPMethod:@"GET"];//Se define el método, en este caso será GET.
    [mutablerequest setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];//Se codifica la info en UTF8
    NSURLSessionDataTask * task = [session dataTaskWithRequest:mutablerequest completionHandler:^(NSData *  data, NSURLResponse * response, NSError *  error) {
        if (data!=nil)
        {
            NSLog(@"Response %@", data);
            block(data,error);//Data is NSDATA and Error is NSERROR
        }
        else
        {
            NSLog(@"error");
            block(nil,error);
        }
    }];
    [task resume];
    
    
}

@end

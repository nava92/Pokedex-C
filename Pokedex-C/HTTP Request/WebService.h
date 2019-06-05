//
//  WebService.h
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

//Se añade la función a nuestro header.
+(void)executequery:(NSString *)strurl strpremeter:(NSString *)premeter withblock:(void(^)(NSData *, NSError*))block;


@end

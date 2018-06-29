//
//  TraverseCoreOBJC.h
//  TraverseFunctions
//
//  Created by Noah_Shan on 2018/6/26.
//  Copyright © 2018 Inspur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface IIPitchCoreOBJC:NSObject


- (void)containsObjectForKey:(void(^)(NSMutableArray *arr))block;

@end

NS_ASSUME_NONNULL_END

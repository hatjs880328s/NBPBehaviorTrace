//
//  TraverseCoreOBJC.m
//  TraverseFunctions
//
//  Created by Noah_Shan on 2018/6/26.
//  Copyright © 2018 Inspur. All rights reserved.
//

#import "IIPitchCoreOBJC.h"

@implementation IIPitchCoreOBJC:NSObject


- (void)containsObjectForKey:(void(^)(NSMutableArray *arr))block {
    if (!block) return;
    //__weak typeof(self) _self = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *rush = [self ClassGetSubclasses];
        block(rush);
    });
}

- (NSMutableArray *) ClassGetSubclasses {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    int numClasses = 0, newNumClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    while (numClasses < newNumClasses) {
        numClasses = newNumClasses;
        classes = (Class *)realloc(classes, sizeof(Class) * numClasses);
        newNumClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            const char *className = class_getName(classes[i]);
            NSString *str = [NSString stringWithFormat:@"%s", className];
            [arr addObject:str];
        }
    }
    free(classes);
    return arr;
}

@end

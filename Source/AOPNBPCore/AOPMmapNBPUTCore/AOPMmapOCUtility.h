//
//  AOPMmapOCUtility.h
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AOPMmapOCUtility : NSObject

int MapFile( NSString * inPathName, void ** outDataPtr, size_t * outDataLength );


/**
 write str data to file with mmap-tec

 @param fileName custom file name [UUID]
 @param content real str info
 */
+ (void)writeData:(NSString *)fileName fileContent: (NSString *)content ;


/**
 get user behavior trace info by file name

 @param fileName filename
 @return str value
 */
// - (NSString *)getStrInfoByFileName:(NSString *)fileName ;

@end






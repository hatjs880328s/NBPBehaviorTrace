//
//  AOPMmapOCUtility.h
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AOPMmapOCUtility : NSObject

int MapFile( char * inPathName, void ** outDataPtr, size_t * outDataLength );


- (void)writeData:(NSString *)fileName fileContent: (NSString *)content ;

@end






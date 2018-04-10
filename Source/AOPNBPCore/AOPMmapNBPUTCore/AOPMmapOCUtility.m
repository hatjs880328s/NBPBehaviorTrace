//
//  AOPMmapOCUtility.m
//  source
//
//  Created by Noah_Shan on 2018/4/8.
//  Copyright © 2018年 Inspur. All rights reserved.
//

#import "AOPMmapOCUtility.h"
#import <sys/mman.h>
#import <sys/stat.h>



@implementation AOPMmapOCUtility

/// this time 's content -length
static u_long memCacheSize = 0 ;

/// this time 's content -info
static const char *contents = "" ;

/// mmapfile memory start address
static void * startMMAPFile;

/// mmapfile old content info length
static u_long nowContentLength = 0;

/// page - size
static u_long pageSize = 4 * 1024;


/**
 write str data to file with mmap-tec
 
 @param fileName custom file name [UUID]
 @param content real str info
 */
+ (void)writeData:(NSString *)fileName fileContent: (NSString *)content {
    contents = [content cStringUsingEncoding:NSUTF8StringEncoding];
    memCacheSize = content.length;
    if ((nowContentLength + memCacheSize > pageSize) || nowContentLength == 0) {
        NSString *routePath = [NSString stringWithFormat:@"%@",fileName];
        NSString *dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AOPNBPUTFile" ];
        NSString *filePath = [[dirPath stringByAppendingPathComponent:routePath] stringByAppendingPathExtension:@"txt"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        munmap(startMMAPFile, pageSize);
        nowContentLength = content.length;
        writeFileWithFileName(filePath);
    }else{
        memcpy(startMMAPFile + nowContentLength, contents, memCacheSize);
        nowContentLength += memCacheSize;
    }
}

void writeFileWithFileName( NSString * inPathName){
    size_t dataLength;
    void * dataPtr;
    void *start;
    if( MapFile( inPathName, &dataPtr, &dataLength ) == 0 ){
        start = dataPtr;
        // save mmap memory start address
        startMMAPFile = dataPtr;
        //[last number] is memoryAddress offset size
        dataPtr = dataPtr;
        //[last number] is counts of your Str length [strcpy]
        memcpy(dataPtr, contents, memCacheSize);
        // Unmap files: [last number] is all of your memory length [invoking the -munmap- function release the memory]
        //munmap(start, memCacheSize);
    }
}

int MapFile( NSString * inPathName, void ** outDataPtr, size_t * outDataLength )
{
    int outError;
    int fileDescriptor;
    struct stat statInfo;
    outError = 0;
    *outDataPtr = NULL;
    *outDataLength = 0;
    fileDescriptor = open(inPathName.UTF8String, O_RDWR, 0 );
    if( fileDescriptor < 0 ){
        outError = errno;
    }else{
        if( fstat( fileDescriptor, &statInfo ) != 0 ){
            outError = errno;
        }else{
            ftruncate(fileDescriptor, statInfo.st_size + pageSize);
            fsync(fileDescriptor);
            *outDataPtr = mmap(NULL,
                               statInfo.st_size + pageSize,
                               PROT_READ|PROT_WRITE,
                               MAP_FILE|MAP_SHARED,
                               fileDescriptor,
                               0);
            if( *outDataPtr == MAP_FAILED ){
                outError = errno;
            }else{
                *outDataLength = statInfo.st_size;
            }
        }
        close( fileDescriptor );
    }
    return outError;
}

@end

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

u_long memCacheSize = 0 ;
const char *contents = "" ;

/**
 write str data to file with mmap-tec
 
 @param fileName custom file name [UUID]
 @param content real str info
 */
- (void)writeData:(NSString *)fileName fileContent: (NSString *)content {
    NSString *routePath = [NSString stringWithFormat:@"%@",fileName];
    NSString *dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"AOPNBPUTFile" ];
    NSString *filePath = [[dirPath stringByAppendingPathComponent:routePath] stringByAppendingPathExtension:@"txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //create txt file
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    //global-parameters set value
    contents = [content cStringUsingEncoding:NSUTF8StringEncoding];
    memCacheSize = content.length;
    //write file
    writeFileWithFileName(filePath);
}


void writeFileWithFileName( NSString * inPathName){
    size_t dataLength;
    void * dataPtr;
    void *start;
    if( MapFile( inPathName, &dataPtr, &dataLength ) == 0 ){
        start = dataPtr;
        //[last number] is memoryAddress offset size
        dataPtr = dataPtr;
        //[last number] is counts of your Str length [strcpy]
        memcpy(dataPtr, contents, memCacheSize);
        // Unmap files: [last number] is all of your memory length [invoking the -munmap- function release the memory]
        munmap(start, memCacheSize);
    }
}

int MapFile( NSString * inPathName, void ** outDataPtr, size_t * outDataLength )
{
    int outError;
    int fileDescriptor;
    struct stat statInfo;
    // Return safe values on error.
    outError = 0;
    *outDataPtr = NULL;
    *outDataLength = 0;
    // Open the file.
    fileDescriptor = open(inPathName.UTF8String, O_RDWR, 0 );
    if( fileDescriptor < 0 ){
        outError = errno;
    }else{
        // We now know the file exists. Retrieve the file size.
        if( fstat( fileDescriptor, &statInfo ) != 0 ){
            outError = errno;
        }else{
            ftruncate(fileDescriptor, statInfo.st_size + memCacheSize);
            fsync(fileDescriptor);
            *outDataPtr = mmap(NULL,
                               statInfo.st_size + memCacheSize,
                               PROT_READ|PROT_WRITE,
                               MAP_FILE|MAP_SHARED,
                               fileDescriptor,
                               0);
            if( *outDataPtr == MAP_FAILED ){
                outError = errno;
            }else{
                // On success, return the size of the mapped file.
                *outDataLength = statInfo.st_size;
            }
        }
        // Now close the file. The kernel doesn’t use our file descriptor.
        close( fileDescriptor );
    }
    return outError;
}

@end

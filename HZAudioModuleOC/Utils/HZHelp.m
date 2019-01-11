//
//  HZHelp.m
//  HZAudioModuleOC
//
//  Created by MaHaoZhe on 2019/1/9.
//  Copyright © 2019 HachiTech. All rights reserved.
//

#import "HZHelp.h"

@implementation HZHelp

+ (NSURL *)getRecordSavePathWithRecordName:(NSString *)RName{
    
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataFilePath = [urlStr stringByAppendingPathComponent:@"Record"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    urlStr = [urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"Record/%@.caf",RName]];
    NSString* encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    
    return url;
}


+ (NSArray<NSString *> *)getAllRecordName{
    
    NSString *basePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Record"];
    
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *directoryEnumerator = [fileManger enumeratorAtPath:basePath];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSString *file;
    
    while (file = [directoryEnumerator nextObject]) {
        if ([[file pathExtension] isEqualToString:@"caf"]) {
            [tempArray addObject:[file stringByDeletingPathExtension]];
        }
    }
    
    NSArray *fileNameArr = [NSArray arrayWithArray:tempArray];
    
    fileNameArr = nil;
    
    return fileNameArr;
}

@end

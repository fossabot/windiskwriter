//
//  DiskWriter.m
//  windiskwriter
//
//  Created by Macintosh on 26.01.2023.
//  Copyright © 2023 TechUnRestricted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDIUtil.h"
#import "DiskWriter.h"
#import "DAWrapper.h"
#import "DebugSystem.h"
#import "../Extensions/NSString+Common.h"

@implementation DiskWriter {
    DAWrapper *destinationDeviceDAWrapper;
    
    NSString *_mountedWindowsISO;
    NSString *_destinationDevice;
    //struct DiskInfo windowsImageDiskInfo;
}

- (NSString *)getMountedWindowsISO {
    return _mountedWindowsISO;
}

- (struct DiskInfo)getDestinationDiskInfo {
    return [destinationDeviceDAWrapper getDiskInfo];
}

- (void)initWindowsSourceMountPath: (NSString *)isoPath {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    BOOL isDirectory;
    BOOL exists = [fileManager fileExistsAtPath:isoPath isDirectory:&isDirectory];
    
    if (!exists) {
        DebugLog(@"File [directory] \"%@\" doesn't exist.", isoPath);
        return;
    }
    
    if (isDirectory) {
        DebugLog(@"The type of the passed \"%@\" is defined as: Directory.", isoPath);
        _mountedWindowsISO = isoPath;
        return;
    }
    
    DebugLog(@"The type of the passed \"%@\" is defined as: File.", isoPath);
    if (![[isoPath lowercaseString] hasSuffix:@".iso"]) {
        DebugLog(@"This file does not have an .iso extension.");
        return;
    }
    
    HDIUtil *hdiutil = [[HDIUtil alloc] initWithImagePath:isoPath];
    if([hdiutil attachImageWithArguments:@[@"-readonly", @"-noverify", @"-noautofsck", @"-noautoopen"]]) {
        _mountedWindowsISO = [hdiutil getMountPoint];
    }
}

- (void)initDestinationDevice: (NSString *)destinationDevice {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDirectory;
    BOOL exists = [fileManager fileExistsAtPath:destinationDevice isDirectory:&isDirectory];
    
    if (!exists) {
        DebugLog(@"The given Destination path does not exist.");
        return;
    }
    
    if ([destinationDevice hasOneOfThePrefixes:@[
        @"disk", @"/dev/disk",
        @"rdisk", @"/dev/rdisk"
    ]]) {
        DebugLog(@"Received device destination path was defined as BSD Name.");
        destinationDeviceDAWrapper = [[DAWrapper alloc] initWithBSDName:destinationDevice];
    }
    else if ([destinationDevice hasPrefix:@"/Volumes/"]) {
        DebugLog(@"Received device destination path was defined as Mounted Volume.");
        if (@available(macOS 10.7, *)) {
            destinationDeviceDAWrapper = [[DAWrapper alloc] initWithVolumePath:destinationDevice];
        } else {
            // TODO: Fix Mac OS X 10.6 Snow Leopard support
            DebugLog(@"Can't load Destination device info from Mounted Volume. Prevented Unsupported API Call."
                     //"Security measures are ignored. Assume that the user entered everything correctly."
            );
        }
    }
    
    if ([destinationDeviceDAWrapper getDiskInfo].BSDName == NULL) {
        DebugLog(@"The specified destination device is invalid.");
    }
}

- (instancetype)initWithWindowsISO: (NSString *)windowsISO
                 destinationDevice: (NSString *)destinationDevice {
    [self initWindowsSourceMountPath:windowsISO];
    [self initDestinationDevice:destinationDevice];
    
    return self;
}

@end
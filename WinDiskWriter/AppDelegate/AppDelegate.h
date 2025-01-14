//
//  AppDelegate.h
//  WinDiskWriter GUI
//
//  Created by Macintosh on 13.06.2023.
//  Copyright © 2023 TechUnRestricted. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readwrite, nonatomic) BOOL enabledUIState;
@property (readwrite, nonatomic) BOOL isScheduledForStop;

@end

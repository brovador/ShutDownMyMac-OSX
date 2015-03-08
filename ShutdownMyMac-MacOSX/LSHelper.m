//
//  LSHelper.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import "LSHelper.h"

@implementation LSHelper

+ (BOOL)isLoginItemEnabledForAppPath:(NSString*)appPath
{
    BOOL result = NO;
    UInt32 seedValue;
    CFURLRef thePath = NULL;
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(loginItems, &seedValue);
    
    for (id item in (__bridge NSArray *)loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        thePath = LSSharedFileListItemCopyResolvedURL(itemRef, 0, NULL);
        
        if ([[(__bridge NSURL*)thePath path] hasPrefix:appPath]) {
            result = YES;
            break;
        } else {
            result = NO;
        }
        
        if (thePath != NULL) {
            CFRelease(thePath);
        }
    }
    
    if (loginItemsArray != NULL) {
        CFRelease(loginItemsArray);
    }
    
    if (loginItems != NULL) {
        CFRelease(loginItems);
    }
    
    return result;
}


+ (void)enableLoginItem:(BOOL)enable withAppPath:(NSString*)appPath
{
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (enable) {
        [self enableLoginItemWithLoginItemsReference:loginItems ForPath:appPath];
    } else {
        [self disableLoginItemWithLoginItemsReference:loginItems ForPath:appPath];
    }
    
    CFRelease(loginItems);
}


+ (void)enableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(NSString *)appPath
{
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(theLoginItemsRefs, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
    
    if (item) {
        CFRelease(item);
    }
}


+ (void)disableLoginItemWithLoginItemsReference:(LSSharedFileListRef )theLoginItemsRefs ForPath:(NSString *)appPath
{
    UInt32 seedValue;
    CFURLRef itemURLRef = NULL;
    CFArrayRef loginItemsArray = LSSharedFileListCopySnapshot(theLoginItemsRefs, &seedValue);
    
    for (id item in (__bridge NSArray *)loginItemsArray) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
        itemURLRef = LSSharedFileListItemCopyResolvedURL(itemRef, 0, NULL);
        
        if ([[(__bridge NSURL*)itemURLRef path] hasPrefix:appPath]) {
            LSSharedFileListItemRemove(theLoginItemsRefs, itemRef);
        }
        
        if (itemURLRef != NULL) {
            CFRelease(itemURLRef);
        }
    }
    
    if (loginItemsArray != NULL) {
        CFRelease(loginItemsArray);
    }
}


@end

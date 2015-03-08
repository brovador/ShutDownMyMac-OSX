//
//  LSHelper.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 8/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSHelper : NSObject

+ (BOOL)isLoginItemEnabledForAppPath:(NSString*)appPath;
+ (void)enableLoginItem:(BOOL)enable withAppPath:(NSString*)appPath;

@end

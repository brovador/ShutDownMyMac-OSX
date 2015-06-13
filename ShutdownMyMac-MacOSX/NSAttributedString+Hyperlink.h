//
//  NSAttributedString+Hyperlink.h
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 15/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (Hyperlink)

+(instancetype)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;

@end

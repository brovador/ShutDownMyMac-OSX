//
//  NSAttributedString+Hyperlink.m
//  ShutdownMyMac-MacOSX
//
//  Created by Jesús on 15/3/15.
//  Copyright (c) 2015 Jesús. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)

+(instancetype)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    
    [attrString endEditing];
    
    return attrString;
}
@end


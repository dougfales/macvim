//
//  MVPWelcomeTitleView.m
//  MacVim
//
//  Created by Doug on 12/19/17.
//

#import "MVPWelcomeTitleView.h"

@implementation MVPWelcomeTitleView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path appendBezierPathWithRect:dirtyRect];
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:0.669 green:0.816 blue:0.615 alpha:0.0], 0.0,
                            [NSColor colorWithCalibratedRed:0.938 green:0.963 blue:0.934 alpha:1.00], 1.0,
                            nil];
    [gradient drawInBezierPath:path angle:300];
    [gradient release];
}

@end

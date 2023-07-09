//
//  FrameLayoutBase.m
//  WinDiskWriter GUI
//
//  Created by Macintosh on 14.06.2023.
//  Copyright © 2023 TechUnRestricted. All rights reserved.
//

#import "FrameLayoutBase.h"
#import "FrameLayoutElement.h"

@interface FrameLayoutBase ()

@end

@implementation FrameLayoutBase

NSString * const overrideMethodString = @"You must override %@ in a subclass";

- (void)commonInit {
    self.layoutElementsArray = [[NSMutableArray alloc] init];
    self.sortedElementsArray = [[NSMutableArray alloc] init];
    
    _spacing = 0;
    _viewsWidthTotal = 0;
    _viewsHeightTotal = 0;
    
    _verticalAlignment = FrameLayoutVerticalCenter;
    _horizontalAlignment = FrameLayoutHorizontalLeft;
}

- (instancetype)init {
    self = [super init];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    [self commonInit];
    
    return self;
}

- (void)setSpacing:(CGFloat)padding {
    _spacing = padding;
    
    [self setNeedsDisplay: YES];
}

- (void)setVerticalAlignment:(FrameLayoutVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    
    [self setNeedsDisplay: YES];
}

- (void)setHorizontalAlignment:(FrameLayoutHorizontalAlignment)horizontalAlignment {
    _horizontalAlignment = horizontalAlignment;
    
    [self setNeedsDisplay: YES];
}

- (void)addView: (NSView * _Nonnull)nsView {
    [self addView: nsView
         minWidth: 0
         maxWidth: INFINITY
        minHeight: 0
        maxHeight: INFINITY];
}

- (void)addView: (NSView * _Nonnull)nsView
       minWidth: (CGFloat)minWidth
       maxWidth: (CGFloat)maxWidth
      minHeight: (CGFloat)minHeight
      maxHeight: (CGFloat)maxHeight {
    
    assert(maxWidth >= minWidth);
    assert(maxHeight >= minHeight);
    
    FrameLayoutElement *layoutElement = [[FrameLayoutElement alloc] initWithNSView:nsView];
    
    [layoutElement setMinWidth:minWidth];
    [layoutElement setMaxWidth:maxWidth];
    
    [layoutElement setMinHeight:minWidth];
    [layoutElement setMaxHeight:maxHeight];
    
    [self appendLayoutElement:layoutElement];
    
    assert(self.layoutElementsArray.count == self.sortedElementsArray.count);
    
    [self addSubview: layoutElement.nsView];
}

- (void)addView: (NSView * _Nonnull)nsView
          width: (CGFloat)width
         height: (CGFloat)height {
    
    [self addView: nsView
         minWidth: width
         maxWidth: width
        minHeight: height
        maxHeight: height];
}

- (NSUInteger)sortedIndexForValue:(CGFloat)value {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:overrideMethodString, NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
    return 0;
}


- (void)appendLayoutElement:(FrameLayoutElement *)element {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:overrideMethodString, NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (void)updateComputedElementsDimensions {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:overrideMethodString, NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (BOOL)isFlipped {
    return YES;
}

- (void)changeFramePropertiesWithLastXPosition: (CGFloat *)lastXPosition
                                 lastYPosition: (CGFloat *)lastYPosition
                                     viewFrame: (CGRect *)viewFrame
                                   currentView: (FrameLayoutElement *)currentView
                                        isLast: (BOOL)isLast {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:overrideMethodString, NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (void)drawRect:(NSRect)dirtyRect {
    //[super drawRect:dirtyRect];
    [self updateComputedElementsDimensions];
    
    NSInteger elementsCount = self.layoutElementsArray.count;
    
    CGFloat lastYPosition = NAN;
    CGFloat lastXPosition = NAN;
    
    for (NSInteger i = 0; i < elementsCount; i++) {
        FrameLayoutElement *currentLayoutElement = [self.layoutElementsArray objectAtIndex:i];
        
        CGRect viewFrame = CGRectZero;
        
        BOOL isLastElement = !(i < elementsCount - 1);
        
        [self changeFramePropertiesWithLastXPosition: &lastXPosition
                                       lastYPosition: &lastYPosition
                                           viewFrame: &viewFrame
                                         currentView: currentLayoutElement
                                              isLast: isLastElement];
        
        [currentLayoutElement.nsView setFrame:viewFrame];
    }
}


@end
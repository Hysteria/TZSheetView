//
//  TZSheetView.m
//  atlantis
//
//  Created by Zhou Hangqing on 13-1-24.
//  Copyright (c) 2013年 QomoCorp co.Ltd. All rights reserved.
//

#import "TZSheetView.h"
#import "TTTAttributedLabel.h"
#import "ColorUtils.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#define kEntryComponentTagIncre 111

@interface TZSheetEntry ()

@end

@implementation TZSheetEntry

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        
#if DEBUG_ENVIROMENT
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:1.0];
        [self.layer setCornerRadius:3.0];
    
#endif
        _alignment = TZSheetContentAlignmentCenter;
        _contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _contentSpacing = 0;
        _textColor = [UIColor blackColor];
        
        _font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = [self frame];
    
    _contentFrame = CGRectMake(_contentEdgeInsets.left, _contentEdgeInsets.top, frame.size.width - _contentEdgeInsets.left - _contentEdgeInsets.right, frame.size.height - _contentEdgeInsets.top - _contentEdgeInsets.bottom);
    
    if (_configText != nil) {
        [self parseConfigText:_configText];
    }
    
    CGFloat componentsWidth = 0.0;
    for (int i = 0; i < _componentCount; i++) {
        UIView *view = [self viewWithTag:i * kEntryComponentTagIncre + 1];
        assert([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]);
        CGRect viewFrame = [view frame];
        componentsWidth += viewFrame.size.width;
    }
    componentsWidth += (_componentCount - 1) * _contentSpacing;
    
    CGFloat originX = _contentFrame.origin.x;
    CGFloat originY = _contentFrame.origin.y;
    switch (_alignment) {
        case TZSheetContentAlignmentLeftTop:
        case TZSheetContentAlignmentLeftCenter:
        case TZSheetContentAlignmentLeftBottom:
            
            break;
        case TZSheetContentAlignmentCenterTop:
        case TZSheetContentAlignmentCenter:
        case TZSheetContentAlignmentCenterBottom:
            originX = frame.size.width/2 - componentsWidth/2;
            break;
        case TZSheetContentAlignmentRightTop:
        case TZSheetContentAlignmentRightCenter:
        case TZSheetContentAlignmentRightBottom:
            originX = frame.size.width - componentsWidth;
            break;
        default:
            break;
    }
    
    for (int i = 0; i < _componentCount; i++) {
        UIView *view = [self viewWithTag:i*kEntryComponentTagIncre+1];
        assert([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]);
        CGRect viewFrame = [view frame];
        
        switch (_alignment) {
            case TZSheetContentAlignmentLeftTop:
            case TZSheetContentAlignmentCenterTop:
            case TZSheetContentAlignmentRightTop:
                break;
            case TZSheetContentAlignmentLeftCenter:
            case TZSheetContentAlignmentCenter:
            case TZSheetContentAlignmentRightCenter:
                originY = frame.size.height/2 - viewFrame.size.height/2;
                break;
            case TZSheetContentAlignmentLeftBottom:
            case TZSheetContentAlignmentCenterBottom:
            case TZSheetContentAlignmentRightBottom:
                originY = frame.size.height - viewFrame.size.height;
            default:
                break;
        }

        viewFrame.origin = CGPointMake(originX, originY);
        [view setFrame:viewFrame];
        originX += viewFrame.size.width + _contentSpacing;
    }
}

#pragma mark - Setter and getter


- (void)setFont:(UIFont *)font
{
    _font = font;

    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            [label setFont:font];
        }
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            [label setTextColor:textColor];
        }
    }
}

- (void)setAlignment:(TZSheetContentAlignment)alignment
{
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)setConfigText:(NSString *)configText
{
    _configText = configText;
    
    [self parseConfigText:_configText];
}

- (void)parseConfigText:(NSString *)text
{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    NSArray *componentTexts = [text componentsSeparatedByString:SEPARATOR];
    _componentCount = [componentTexts count];
    for (int i = 0; i < _componentCount; i++) {
        NSString *componentText = [componentTexts objectAtIndex:i];
        int index = [self isTextStandForImage:componentText];
        if (index != -1) {
            NSString *iconName = [componentText substringFromIndex:index+1];
            iconName = [NSString stringWithFormat:@"%@.png", iconName];
//#if QCImageManagerUsed
//            UIImage *iconImage = [QCImageManager imageNamed:iconName];
//#elif 
            UIImage *iconImage = [UIImage imageNamed:iconName];
//#endif
            UIImageView *icon = [[UIImageView alloc] initWithImage:iconImage];
            [icon setTag:i*kEntryComponentTagIncre+1];
            [self addSubview:icon];
            
        } else {
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            [label setFont:_font];
            [label setTextColor:_textColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            // Parse color configs
            [label setText:componentText afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
                
                __block NSRange lastColorRange;
                __block UIColor *lastColor = nil;
                NSMutableArray *rangesToMove = [NSMutableArray array];
                NSRegularExpression *regexp = ParenthesisRegularExpression();
                [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                    
                    NSMutableString *colorString = [NSMutableString stringWithString:[[mutableAttributedString string] substringWithRange:result.range]];
                    
                    [colorString deleteCharactersInRange:NSMakeRange(0, 1)];
                    [colorString deleteCharactersInRange:NSMakeRange(colorString.length-1, 1)];
             
                    UIColor *color;
                    if ([colorString hasPrefix:Color_INDICATOR]) {
                        color = [UIColor colorWithString:colorString];
                        
                    } else {
                        NSString *colorSELName = [NSString stringWithFormat:@"%@Color", colorString];
                        SEL selector = NSSelectorFromString(colorSELName);
                        if ([[UIColor class] respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            color = (UIColor *)[[UIColor class] performSelector:selector];
#pragma diagnostic pop
                        }
                    }

                    if (color) {
//                        if (lastColor) {
                            NSRange colorRange = NSMakeRange(NSMaxRange(result.range), NSMaxRange(stringRange) - NSMaxRange(result.range));
                            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:colorRange];
                            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[color CGColor] range:colorRange];
                            
//                            [rangesToMove addObject:[NSValue valueWithRange:lastColorRange]];
                            [mutableAttributedString deleteCharactersInRange:result.range];
//                        }
                        
//                        lastColor = color;
//                        lastColorRange = result.range;
                    }
                   
                }];
                
//                for (NSValue *v in rangesToMove) {
//                    NSRange range = [v rangeValue];
//                    [mutableAttributedString deleteCharactersInRange:range];
//                }
                
                return mutableAttributedString;
            }];
            
            [label sizeToFit];
            
            if (label.frame.size.width > _contentFrame.size.width) {
                if (_contentShouldAutoBreakline) {
                    [label setFrame:CGRectMake(0, 0, _contentFrame.size.width, 0)];
                    [label setNumberOfLines:0];
                    [label sizeToFit];
                }
            }
            
            [label setTextColor:_textColor];
            [label setTag:i*kEntryComponentTagIncre+1];
        
            [self addSubview:label];
        }
    }
}

- (int)isTextStandForImage:(NSString *)text
{
    int len = text.length;
    for (int i = 0; i < len; i++) {
        unichar c = [text characterAtIndex:i];
        if (c == ICON_INDICATOR) {
            return i;
        }
    }
    return -1;
}

//static inline NSRegularExpression * ColorRegularExpression() {
//    static NSRegularExpression *_colorRRegularExpression = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _colorRRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\{[^}]*\}" options:NSRegularExpressionCaseInsensitive error:nil];
//    });
//    
//    return _colorRRegularExpression;
//}

static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}

@end

@implementation TZSheetView

- (void)dealloc
{
    [self unregisterFromKVO];
}

- (void)initialize
{
    [self registerForKVO];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    _contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _entryEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _size = CGSizeMake(0, 0);
    _entrySize = CGSizeMake(0, 0);
    _rowSpace = 0.0f;
    _columnSpace = 0.0f;
    
    _contentAlignment = TZSheetContentAlignmentCenter;
    _horizontalHeaderAlignment = TZSheetContentAlignmentCenter;
    _verticalHeaderAlignment = TZSheetContentAlignmentCenter;
    _needHorizontalHeader = NO;
    _needVerticalHeader = NO;

    _contentFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _headerFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _contentTextColor = [UIColor whiteColor];
    _headerTextColor = [UIColor whiteColor];
    
    _sheetEntries = [[NSMutableArray alloc] init];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_backgroundView];
    _horizontalHeaderBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_horizontalHeaderBackgroundView];
    _verticalHeaderBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_verticalHeaderBackgroundView];
    
}


- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    
    }
    return self;
}


- (void)layoutSubviews
{
    [self reloadData];
    
    [_backgroundView setFrame:[self frame]];
    
    [_horizontalHeaderBackgroundView setFrame:CGRectMake(0, 0, _size.width * _entrySize.width, _entrySize.height)];
    [_verticalHeaderBackgroundView setFrame:CGRectMake(0, 0, _entrySize.width, _size.height * _entrySize.height)];

}

- (void)reloadData
{
    NSAssert([_dataSource respondsToSelector:@selector(sizeOfSheetView:)], @"DataSource must respond to method sizeOfSheetView:");
    CGSize sheetSize = [_dataSource sizeOfSheetView:self];
    
    int sheetWidth = _needVerticalHeader ? sheetSize.width + 1: sheetSize.width;
    int sheetHeight = _needHorizontalHeader ? sheetSize.height + 1: sheetSize.height;
    
    CGFloat entryWidth = (self.frame.size.width - _contentEdgeInsets.left - _contentEdgeInsets.right - (sheetSize.width - 1) * _columnSpace) / sheetWidth;
    CGFloat entryHeight = (self.frame.size.height - _contentEdgeInsets.top - _contentEdgeInsets.bottom - (sheetSize.height - 1) * _rowSpace) / sheetHeight;

    _size = CGSizeMake(sheetWidth, sheetHeight);
    
    for (int row = 0; row < sheetHeight; row++) {
        for (int column = 0; column < sheetWidth; column++) {
            int index = sheetWidth * row + column;
            CGRect entryFrame = CGRectMake(self.entryEdgeInsets.left + column * (entryWidth + self.columnSpace), self.entryEdgeInsets.top + row * (entryHeight + self.rowSpace), entryWidth, entryHeight);
            TZSheetEntry *entry;
            if (index < [_sheetEntries count]) {
                entry = [_sheetEntries objectAtIndex:index];
                [entry setFrame:entryFrame];
            } else {
                entry = [[TZSheetEntry alloc] initWithFrame:entryFrame];
                [self addSubview:entry];
                [_sheetEntries addObject:entry];
            }

            [entry setAlignment:_contentAlignment];
            [entry setContentEdgeInsets:_entryEdgeInsets];
            [entry setFont:_contentFont];
            
            NSUInteger realRow = _needHorizontalHeader ? row - 1 : row;
            NSUInteger realColumn = _needVerticalHeader ? column - 1 : column;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:realRow andColumn:realColumn];
            [entry setIndexPath:indexPath];
            
            if ([_dataSource respondsToSelector:@selector(sheetView:textColorForEntryAtIndexPath:)]) {
                _contentTextColor = [_dataSource sheetView:self textColorForEntryAtIndexPath:indexPath];
            }
            
            [entry setTextColor:_contentTextColor];

            if ([_dataSource respondsToSelector:@selector(sheetView:configTextForEntryAtIndexPath:)]) {
                NSString *configText = [_dataSource sheetView:self configTextForEntryAtIndexPath:indexPath];
                if (configText.length != 0) {
                    [entry setConfigText:configText];
                }
            }

        }
    }
}

#pragma mark - Setter and getter

- (void)setContentShouldAutoBreakline:(BOOL)contentShouldAutoBreakline
{
    _contentShouldAutoBreakline = contentShouldAutoBreakline;
    
    [self setNeedsLayout];
}

- (void)setContentAlignment:(TZSheetContentAlignment)contentAlignment
{
    _contentAlignment = contentAlignment;
    for (int i = 0; i < [_sheetEntries count]; i++) {
        TZSheetEntry *entry = [_sheetEntries objectAtIndex:i];
        [entry setAlignment:_contentAlignment];
    }
}

- (void)setHorizontalHeaderAlignment:(TZSheetContentAlignment)horizontalHeaderAlignment
{
    _horizontalHeaderAlignment = horizontalHeaderAlignment;
    
    for (TZSheetEntry *entry in _sheetEntries) {
        if ([entry indexPath].row == -1) {
            [entry setAlignment:_horizontalHeaderAlignment];
        }
       
    }
}

- (void)setVerticalHeaderAlignment:(TZSheetContentAlignment)verticalHeaderAlignment
{
    _verticalHeaderAlignment = verticalHeaderAlignment;
    
    for (TZSheetEntry *entry in _sheetEntries) {
        if ([entry indexPath].column == -1) {
            [entry setAlignment:_verticalHeaderAlignment];
        }
        
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [_backgroundView setImage:_backgroundImage];
}

- (void)setHorizontalHeaderBackgroundImage:(UIImage *)horizontalHeaderBackgroundImage
{
    _horizontalHeaderBackgroundImage = horizontalHeaderBackgroundImage;
    [_horizontalHeaderBackgroundView setImage:_horizontalHeaderBackgroundImage];
    [self insertSubview:_horizontalHeaderBackgroundView aboveSubview:_verticalHeaderBackgroundView];
}

- (void)setVerticalHeaderBackgroundImage:(UIImage *)verticalHeaderBackgroundImage
{
    _verticalHeaderBackgroundImage = verticalHeaderBackgroundImage;
    [_verticalHeaderBackgroundView setImage:_verticalHeaderBackgroundImage];
    [self insertSubview:_verticalHeaderBackgroundView aboveSubview:_horizontalHeaderBackgroundView];
}

#pragma mark - Entry Accessor

- (TZSheetEntry *)entryForIndexPath:(NSIndexPath *)indexPath
{
    return [self entryAtRow:indexPath.row andColumn:indexPath.column];
}

- (TZSheetEntry *)entryAtRow:(NSInteger)row andColumn:(NSInteger)column
{
    NSAssert1(column < _size.width && column >= -1, @"column must be greater or equal to -1, lesser than %.0f", _size.width);
    NSAssert1(row < _size.height && row >= -1, @"row must be greater or equal to -1, lesser than %.0f", _size.height);
    row = _needHorizontalHeader ? row - 1 : row;
    column = _needVerticalHeader ? column - 1 : column;

    int index = _size.width * row + column;
    TZSheetEntry *entry = nil;
    if (index < _sheetEntries.count) {
        entry = [_sheetEntries objectAtIndex:index];
    }
    return entry;
}


#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"size", @"entrySize", @"rowSpace", @"columnSpace", @"contentFont", @"headerFont", @"needHorizontalHeader", @"needVerticalHeader", @"contentEdgeInsets", @"entryEdgeInsets", @"headerTextColor", @"contentTextColor", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
    [self updateUIForKeypath:keyPath];
	
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"size"] || [keyPath isEqualToString:@"entrySize"] || [keyPath isEqualToString:@"rowSpace"] || [keyPath isEqualToString:@"columnSpace"] || [keyPath isEqualToString:@"needHorizontalHeader"] || [keyPath isEqualToString:@"needVerticalHeader"] ||[keyPath isEqualToString:@"contentEdgeInsets"] ||[keyPath isEqualToString:@"entryEdgeInsets"] ||[keyPath isEqualToString:@"headerFont"] ||[keyPath isEqualToString:@"contentFont"] ||[keyPath isEqualToString:@"headerTextColor"] ||[keyPath isEqualToString:@"contentTextColor"])
    {
        [self setNeedsLayout];
    }
}

#pragma mark - Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.userInteractionEnabled) {
        UITouch *touch = [touches anyObject];
        CGPoint loc = [touch locationInView:self];
        for (TZSheetEntry *entry in _sheetEntries) {
            if (CGRectContainsPoint(entry.frame, loc)) {
                if ([_delegate respondsToSelector:@selector(sheetView:didSelectedEntryAtIndexPath:)]) {
                    [_delegate sheetView:self didSelectedEntryAtIndexPath:entry.indexPath];
                    
                }
                
            }
        }
    } else {
        return [super touchesEnded:touches withEvent:event];
    }
}


@end

@implementation NSIndexPath (TZSheetView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)row andColumn:(NSInteger)column
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:column];
    
    return indexPath;
}

- (NSInteger)column
{
    return self.section;
}

@end

#pragma mark - Deprecated

@implementation TZSheetView (Deprecated)

- (void)setConfigTextsForHorizontalHeader:(NSArray *)configTexts
{
    if (!_needHorizontalHeader) {
        return;
    }
    return [self setConfigTexts:configTexts atRow:0];
}

- (void)setConfigTextsForVerticalHeader:(NSArray *)configTexts
{
    if (!_needVerticalHeader) {
        return;
    }
    return [self setConfigTexts:configTexts atColumn:0];
}

- (void)setConfigTexts:(NSArray *)configTexts atRow:(NSInteger)row
{
    assert(row < _size.height);
    NSUInteger columnCount = [configTexts count];
    for (NSUInteger column = 0; column < columnCount; column++) {
        NSString *configText = [configTexts objectAtIndex:row];
        [self setConfigTextForEntry:configText atRow:row andColumn:column];
    }
}

- (void)setConfigTexts:(NSArray *)configTexts atColumn:(NSInteger)column
{
    assert(column < _size.width);
    NSUInteger rowCount = [configTexts count];
    for (NSUInteger row = 0; row < rowCount; row++) {
        NSString *configText = [configTexts objectAtIndex:row];
        [self setConfigTextForEntry:configText atRow:row andColumn:column];
    }
}

- (void)setConfigTextForEntry:(NSString *)configText atRow:(NSInteger)row andColumn:(NSInteger)column
{
    int index = _size.width * row + column;
    TZSheetEntry *entry;
    if (index < [_sheetEntries count]) {
        entry = [_sheetEntries objectAtIndex:index];
    } else {
        CGRect entryFrame = CGRectMake(column * _size.width, row * _size.height, _size.width, _size.height);
        entry = [[TZSheetEntry alloc] initWithFrame:entryFrame];
        [self addSubview:entry];
        [_sheetEntries addObject:entry];
    }
    
    if (entry) {
        [entry setConfigText:configText];
    }
}

@end

//
//  TZSheetView.h
//  atlantis
//
//  Created by Zhou Hangqing on 13-1-24.
//  Copyright (c) 2013年 QomoCorp co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QCImageManagerUsed      0
// Set the helper char to parse config text here
#define SEPARATOR               @"|"
#define ICON_INDICATOR          '@'
#define Color_INDICATOR         @"#"

// Color key
#define kColorNameBlack                 @"black"        // 0.0 white
#define kColorNameDarkGray              @"darkGray"     // 0.333 white
#define kColorNameLightGray             @"lightGray"    // 0.667 white
#define kColorNameWhite                 @"white"        // 1.0 white
#define kColorNameGray                  @"gray"         // 0.5 white
#define kColorNameRed                   @"red"          // 1.0, 0.0, 0.0 RGB
#define kColorNameGreen                 @"green"        // 0.0, 1.0, 0.0 RGB
#define kColorNameBlue                  @"blue"         // 0.0, 0.0, 1.0 RGB
#define kColorNameCyan                  @"cyan"         // 0.0, 1.0, 1.0 RGB
#define kColorNameYellow                @"yellow"       // 1.0, 1.0, 0.0 RGB
#define kColorNameMagenta               @"magenta"      // 1.0, 0.0, 1.0 RGB
#define kColorNameOrange                @"orange"       // 1.0, 0.5, 0.0 RGB
#define kColorNamePurple                @"purple"       // 0.5, 0.0, 0.5 RGB
#define kColorNameBrown                 @"brown"        // 0.6, 0.4, 0.2 RGB

// Config text Example

// @"@icon_gold|{red}what{green]the{blue}fuck{#ff00ff}!!!"

typedef enum {
    TZSheetContentAlignmentLeftTop = 0,
    TZSheetContentAlignmentLeftCenter,
    TZSheetContentAlignmentLeftBottom,
    TZSheetContentAlignmentCenterTop,
    TZSheetContentAlignmentCenter,
    TZSheetContentAlignmentCenterBottom,
    TZSheetContentAlignmentRightTop,
    TZSheetContentAlignmentRightCenter,
    TZSheetContentAlignmentRightBottom
} TZSheetContentAlignment;

@interface TZSheetEntry : UIView
{
    CGRect _contentFrame;
    int _componentCount;
}

@property (nonatomic, copy) NSString *configText; // config texts will be rendered as UILabel and UIImageView
@property (nonatomic, assign) TZSheetContentAlignment alignment; // default is TZSheetContentAlignmentCenter
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; // default is {2, 2, 2, 2}
@property (nonatomic, assign) CGFloat contentSpacing; // defalut is 10

@property (nonatomic, strong) UIFont *font; // default is system font With labelFontSize

@property (nonatomic, strong) UIColor *textColor; // default is black
@property (nonatomic, strong) NSIndexPath *indexPath; // coordinate in sheet view
@property (nonatomic, assign) BOOL contentShouldAutoBreakline;

@end

@class TZSheetView;

@protocol TZSheetViewDataSource <NSObject>

@required
// size determins how many rows and columns sheet view has
- (CGSize)sizeOfSheetView:(TZSheetView *)sheetView;
// sheet view may be constructed from labels parsed by config text or concrete UIControls. AND the horizontal header entrys have index path with row = -1, while the vertical header entries have index path with column = -1;
- (NSString *)sheetView:(TZSheetView *)sheetView configTextForEntryAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (UIColor *)sheetView:(TZSheetView *)sheetView textColorForEntryAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol TZSheetViewDelegate <NSObject>

@optional
- (void)sheetView:(TZSheetView *)sheet didSelectedEntryAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TZSheetView : UIView
{
    TZSheetContentAlignment _contentHorizontalAlignment;
    TZSheetContentAlignment _horizontalHeaderAlignment;
    TZSheetContentAlignment _verticalHeaderAlignment;
    NSMutableArray *_horizontalHearders;
    NSMutableArray *_verticalHeaders;
    NSMutableArray *_sheetEntries; // this is a 2d array
    UIImageView *_backgroundView;
    UIImageView *_horizontalHeaderBackgroundView;
    UIImageView *_verticalHeaderBackgroundView;
    
}
@property (nonatomic, weak) id<TZSheetViewDataSource> dataSource;
@property (nonatomic, weak) id<TZSheetViewDelegate> delegate;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize entrySize;
@property (nonatomic, assign) CGFloat rowSpace;
@property (nonatomic, assign) CGFloat columnSpace;
@property (nonatomic, assign) CGFloat componentSpace;
@property (nonatomic, strong) UIFont *headerFont;
@property (nonatomic, strong) UIColor *headerTextColor;
@property (nonatomic, strong) UIFont *contentFont;
@property (nonatomic, strong) UIColor *contentTextColor;
@property (nonatomic, assign) BOOL needHorizontalHeader; // default is NO, set YES there will be one more row entrys for headers
@property (nonatomic, assign) BOOL needVerticalHeader; // default is NO, set YES there will be one more column entrys for headers
@property (nonatomic, assign) TZSheetContentAlignment contentAlignment;
@property (nonatomic, assign) TZSheetContentAlignment horizontalHeaderAlignment;
@property (nonatomic, assign) TZSheetContentAlignment verticalHeaderAlignment;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; // default is {0, 0, 0, 0}
@property (nonatomic, assign) UIEdgeInsets entryEdgeInsets; // default is {0, 0, 0, 0}

@property (nonatomic, strong) UIImage *backgroundImage;

// If you setVerticalHeaderBackgroundImage later, then verticalHeaderBackgroundView will be upon horizontalHeaderBackgroundView, vice versa.
@property (nonatomic, strong) UIImage *horizontalHeaderBackgroundImage; 
@property (nonatomic, strong) UIImage *verticalHeaderBackgroundImage;

@property (nonatomic, assign) BOOL contentShouldAutoBreakline;

- (void)reloadData;

// These methods can only be invoked after reloadData being called
- (TZSheetEntry *)entryForIndexPath:(NSIndexPath *)indexPath;
- (TZSheetEntry *)entryAtRow:(NSInteger)row andColumn:(NSInteger)column;

@end

@interface TZSheetView (Deprecated)

// Config texts will be rendered as UILabel and UIImageView
// The format of config text is described in README.MD
// Old stype config text setter which are deprecated, and these can only be called after layoutOfSubviews of TZSheetView 
- (void)setConfigTextsForHorizontalHeader:(NSArray *)configTexts;
- (void)setConfigTextsForVerticalHeader:(NSArray *)configTexts;
- (void)setConfigTexts:(NSArray *)configTexts atRow:(NSInteger)row;
- (void)setConfigTexts:(NSArray *)configTexts atColumn:(NSInteger)column;
- (void)setConfigTextForEntry:(NSString *)configText atRow:(NSInteger)row andColumn:(NSInteger)column;

@end

@interface NSIndexPath (TZSheetView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)row andColumn:(NSInteger)column;

@property(nonatomic,readonly) NSInteger column;

@end


//
//  TZSheetView.h
//  atlantis
//
//  Created by Zhou Hangqing on 13-1-24.
//  Copyright (c) 2013年 QomoCorp co.Ltd. All rights reserved.
//



// Enable debug model to draw entry frame of sheet view
#define DEBUG_ENVIROMENT        0 
// Set the helper char to parse config text here
#define SEPARATOR               '|'
#define ICON_INDICATOR          '@'
#define UIView_INDICATOR        '*'

#import <UIKit/UIKit.h>

typedef enum {
    TZSheetViewTextAlignmentLeft = 0, // contents left aligned
    TZSheetViewTextAlignmentCenter, // contents center aligned
    TZSheetViewTextAlignmentRight, // contents right aligned
} TZSheetViewTextAlignment;



@interface TZSheetEntry : UIView
{
    CGRect _contentFrame;
    int _componentCount;
}

@property (nonatomic, copy) NSString *configText; // config texts will be rendered as UILabel and UIImageView
@property (nonatomic, assign) TZSheetViewTextAlignment alignment; // default is QCSheetContentAlignmentCenter;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; // default is {2, 2, 2, 2} on iPad, half on iPhone
@property (nonatomic, assign) CGFloat contentSpacing; // defalut is 10 on iPad, half on iPhone

@property (nonatomic, strong) UIFont *font; // default is system font of 12

@property (nonatomic, strong) UIColor *textColor; // default is black
@property (nonatomic, strong) NSIndexPath *indexPath; // coordinate in sheet view
@end

@class TZSheetView;

@protocol TZSheetViewDataSource <NSObject>

@required
// size determins how many rows and columns sheet view has
- (CGSize)sizeOfSheetView:(TZSheetView *)sheetView;
// sheet view may be constructed from labels parsed by config text or concrete UIControls. AND the horizontal header entrys have index path with row = -1, while the vertical header entries have index path with column = -1;
- (NSString *)sheetView:(TZSheetView *)sheetView configTextForEntryAtIndexPath:(NSIndexPath *)indexPath;

- (UIColor *)sheetView:(TZSheetView *)sheetView textColorForEntryAtIndexPath:(NSIndexPath *)indexPath;
- (TZSheetViewTextAlignment)sheetView:(TZSheetView *)sheetView textAlignmentForEntryAtIndexPath:(NSIndexPath *)indexPath;
@optional

@end

@protocol TZSheetViewDelegate <NSObject>

@optional
- (void)sheetView:(TZSheetView *)sheet didSelectedEntryAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TZSheetView : UIView
{
    TZSheetViewTextAlignment _contentAlignment;
    TZSheetViewTextAlignment _horizontalHeaderAlignment;
    TZSheetViewTextAlignment _verticalHeaderAlignment;
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
@property (nonatomic, assign) CGFloat componentSpace; // default is 10 on iPad
@property (nonatomic, strong) UIFont *headerFont;
@property (nonatomic, strong) UIColor *headerTextColor;
@property (nonatomic, strong) UIFont *contentFont;
@property (nonatomic, strong) UIColor *contentTextColor;
@property (nonatomic, assign) BOOL needHorizontalHeader; // default is NO, set YES there will be one more row entrys for headers
@property (nonatomic, assign) BOOL needVerticalHeader; // default is NO, set YES there will be one more column entrys for headers
@property (nonatomic, assign) TZSheetViewTextAlignment contentAlignment; // Default is QCSheetContentAlignmentLeft
@property (nonatomic, assign) TZSheetViewTextAlignment horizontalHeaderAlignment; // This property determine the content alignment of horizontal header. Default is QCSheetContentAlignmentCenter
@property (nonatomic, assign) TZSheetViewTextAlignment verticalHeaderAlignment; // This property determine the content alignment of vertical header. Default is QCSheetContentAlignmentCenter QCSheetContentAlignmentCenter
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; // default is {0, 0, 0, 0} on iPad
@property (nonatomic, assign) UIEdgeInsets entryEdgeInsets; // default is {2, 2, 2, 2} on iPad

@property (nonatomic, strong) UIImage *backgroundImage;

// If you setVerticalHeaderBackgroundImage later, then verticalHeaderBackgroundView will be upon horizontalHeaderBackgroundView, vice versa.
@property (nonatomic, strong) UIImage *horizontalHeaderBackgroundImage; 
@property (nonatomic, strong) UIImage *verticalHeaderBackgroundImage;

- (void)reloadData;

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


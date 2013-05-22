//
//  TZSheetViewDemoViewController.h
//  TZSheetViewDemo
//
//  Created by Zhou Hangqing on 13-5-6.
//  Copyright (c) 2013年 Zhou Hangqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZSheetView.h"


@interface TZSheetViewController : UIViewController <TZSheetViewDataSource, TZSheetViewDelegate>

@property (nonatomic, strong) TZSheetView *sheetView1;
@property (nonatomic, strong) TZSheetView *sheetView2;
@property (nonatomic, strong) TZSheetView *sheetView3;
@property (nonatomic, strong) TZSheetView *sheetView4;
@property (nonatomic, strong) NSArray *configTexts1;


@end

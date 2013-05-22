//
//  TZSheetViewDemoViewController.m
//  TZSheetViewDemo
//
//  Created by Zhou Hangqing on 13-5-6.
//  Copyright (c) 2013年 Zhou Hangqing. All rights reserved.
//

#import "TZSheetViewController.h"


@interface TZSheetViewController ()

@end

@implementation TZSheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.configTexts1 = [NSArray arrayWithObjects:@"i have 999|@icon_gold|gold", @"u have 999|@icon_gem|gems", @"there is|@icon_iron|iron resource", @"he wants to eat|@icon_food", nil];
        
            }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    
    self.sheetView1 = [[TZSheetView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.1)];
    [self.view addSubview:self.sheetView1];
    [self.sheetView1 setDelegate:self];
    [self.sheetView1 setDataSource:self];
//    [self.sheetView1 setContentTextColor:[UIColor lightTextColor]];
    
    self.sheetView2 = [[TZSheetView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.2, self.view.frame.size.width, self.view.frame.size.height * 0.1)];
    [self.view addSubview:self.sheetView2];
    [self.sheetView2 setDelegate:self];
    [self.sheetView2 setDataSource:self];
//    [self.sheetView2 setContentTextColor:[UIColor lightTextColor]];
    
    self.sheetView3 = [[TZSheetView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.4, self.view.frame.size.width, self.view.frame.size.height * 0.2)];
    [self.view addSubview:self.sheetView3];
    [self.sheetView3 setDelegate:self];
    [self.sheetView3 setDataSource:self];
    
    self.sheetView4 = [[TZSheetView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.6, self.view.frame.size.width, self.view.frame.size.height * 0.2)];
    [self.view addSubview:self.sheetView4];
    [self.sheetView4 setDelegate:self];
    [self.sheetView4 setDataSource:self];
    [self.sheetView4 setNeedHorizontalHeader:YES];
    [self.sheetView4 setNeedVerticalHeader:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:button];
    [button setFrame:CGRectMake(self.view.frame.size.width * 0.5 - 50, self.view.frame.size.height * 0.9, 100, 30)];
    [button setTitle:@"Deprecated" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTest) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTest
{
    [self testForDeprecatedMethods];
}

- (void)testForDeprecatedMethods
{
    [self.sheetView1 setConfigTextForEntry:@"Test set entry" atRow:0 andColumn:0];
    [self.sheetView1 setConfigTexts:[NSArray arrayWithObjects:@"Test set column 0", @"Test set column 0" ,nil] atColumn:0];
    [self.sheetView2 setConfigTexts:[NSArray arrayWithObjects:@"Test set row 0", @"Test set row 0" ,nil] atRow:0];
    
    [self.sheetView3 setConfigTexts:[NSArray arrayWithObjects:@"Test set row 1", @"Test set row 1" ,nil] atRow:1];
    [self.sheetView3 setConfigTexts:[NSArray arrayWithObjects:@"Test set column 1", @"Test set column 1" ,nil] atColumn:1];
    
    [self.sheetView4 setConfigTextsForHorizontalHeader:[NSArray arrayWithObjects:@"hh0", @"hh1", @"hh2" ,nil]];
    [self.sheetView4 setConfigTextsForVerticalHeader:[NSArray arrayWithObjects:@"vh0", @"vh1", @"vh2",nil]];
}

- (CGSize)sizeOfSheetView:(TZSheetView *)sheetView
{
    if ([sheetView isEqual:self.sheetView1]) {
        return CGSizeMake(1, 2);
    } else if ([sheetView isEqual:self.sheetView2]) {
        return CGSizeMake(2, 1);
    } else {
        return CGSizeMake(2, 2);
    }
}

- (NSString *)sheetView:(TZSheetView *)sheetView configTextForEntryAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.sheetView2 isEqual:sheetView]) {
        int index = indexPath.row;
        NSString *configText = [self.configTexts1 objectAtIndex:index];
        return configText;
    } else if ([self.sheetView1 isEqual:sheetView]) {
        int index = 2 + indexPath.column;
        NSString *configText = [self.configTexts1 objectAtIndex:index];
        return configText;
    } else if ([self.sheetView3 isEqual:sheetView]){
        int index = indexPath.row * indexPath.column ;
        NSString *configText = [self.configTexts1 objectAtIndex:index];
        return configText;
    } else {
        if (indexPath.row == -1) {
            return @"horizontal header";
        } else if (indexPath.column == -1) {
            return @"vertical header";
        } else {
            return @"SheetView with headers";
        }
    }
}

- (UIColor *)sheetView:(TZSheetView *)sheetView textColorForEntryAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.column == 0) {
        return [UIColor redColor];
    } else if (indexPath.row == 0 && indexPath.column == 1) {
        return [UIColor yellowColor];
    } else if (indexPath.row == 1 && indexPath.column == 0) {
        return [UIColor orangeColor];
    } else if (indexPath.row == 1 && indexPath.column == 1) {
        return [UIColor cyanColor];
    } else {
        return [UIColor purpleColor];
    }
}

- (void)sheetView:(TZSheetView *)sheet didSelectedEntryAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"QCSheetView did selected entry at row:%d and column:%d", indexPath.row, indexPath.column);
}


@end

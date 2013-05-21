TZSheetView
===========

TZSheetView is a collection view to help you format your game/app information.And it's implemented through UITableView style.

##Usage##

###Property `configText` is foramtted as belows:###

 *Need iron:|@icon_iron|100k*
  
 - '|' means separator, each part separated would be text of UILabel.
 - '@' means icon indicator, followed by icon file name, then rendered as UIImageView with height of the entry.
 - '*' means UIKit class indicator, followed by a class name, could be your customized class(waiting to implement)

###Align and size###

- Sheet
    - with size (3,3)
    - needHorizontalHeader = YES
    - horizontalHeaderAlignment = QCSheetContentAlignmentCenter
    - needVerticalHeader = YES
    - verticalHeaderAlignment = QCSheetContentAlignmentCenter
- Entry (can be accessed from `- (QCSheetEntry *)entryAtRow:(NSUInteger)row andColumn:(NSUInteger)column` or `- (QCSheetEntry *)entryForIndexPath:(NSIndexPath *)indexPath`)
    - column 1. contentAlgnment = QCSheetContentAlignmentLeft
    - column 2. contentAlgnment = QCSheetContentAlignmentCenter
    - column 3. contentAlgnment = QCSheetContentAlignmentRight
- Preview

Blank (-1,-1)            |   Horizontal Header 1   |      Horizontal Header 2    |   Horizontal Header 3
:---------------: | :---------------------- | :-------------------------: | -----------------------:
Vertical Header 1 | AlignLeft (x:0,y:0)     |    AlignCenter (x:1,y:0)    |    (x:2,y:0) AlignRight
Vertical Header 2 | AlignLeft (x:0,y:1)     |    AlignCenter (x:1,y:1)    |    (x:2,y:1) AlignRight
Vertical Header 3 | AlignLeft (x:0,y:2)     |    AlignCenter (x:1,y:2)    |    (x:2,y:2) AlignRight


TZSheetView
===========

TZSheetView is a collection view to help you format your game/app information.And it's implemented similar to UITableView.

##Usage##

TZSheetView can be easily used similar to the way you use UITableView. 

#### Confirm the Size
	- (CGSize)sizeOfSheetView:(TZSheetView *)sheetView;
#### Return the 'configText' of sheet entry
	- (NSString *)sheetView:(TZSheetView *)sheetView configTextForEntryAtIndexPath:(NSIndexPath *)indexPath;

####Each sheet entry's `configText` is foramtted as belows:###

*Need iron:|@icon_iron|100k*
  
- '|' means separator, each part separated would be text of UILabel.
- '@' means icon indicator, followed by icon file name, then rendered as UIImageView with height of the entry.

##See more in the codes.
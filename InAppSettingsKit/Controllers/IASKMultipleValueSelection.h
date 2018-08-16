#import <KitBridge/KitBridge.h>

@class IASKSpecifier;
@protocol IASKSettingsStore;

/// Encapsulates the selection among multiple values.
/// This is used for PSMultiValueSpecifier and PSRadioGroupSpecifier
@interface IASKMultipleValueSelection : NSObject

@property (nonatomic, assign) ILTableView *tableView;
@property (nonatomic, retain) IASKSpecifier *specifier;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy, readonly) NSIndexPath *checkedItem;
@property (nonatomic, strong) id<IASKSettingsStore> settingsStore;

- (id)initWithSettingsStore:(id<IASKSettingsStore>)settingsStore;
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateSelectionInCell:(ILTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end

#import "IASKMultipleValueSelection.h"

#import "IASKSettingsStore.h"
#import "IASKSettingsStoreUserDefaults.h"
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"

@implementation IASKMultipleValueSelection {
    NSInteger _checkedIndex;
}

@synthesize settingsStore = _settingsStore;

- (id)initWithSettingsStore:(id<IASKSettingsStore>)settingsStore {
    if ((self = [super init])) {
        self.settingsStore = settingsStore;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)setSpecifier:(IASKSpecifier *)specifier {
    _specifier = specifier;
    [self updateCheckedItem];
}

- (NSIndexPath *)checkedItem {
#if IL_UI_KIT
    return [NSIndexPath indexPathForRow:_checkedIndex inSection:_section];;
#else
    return nil;
#endif
}

- (void)updateCheckedItem {
    // Find the currently checked item
    id value = [self.settingsStore objectForKey:[_specifier key]];
    if (!value) {
        value = [_specifier defaultValue];
    }
    _checkedIndex = [[_specifier multipleValues] indexOfObject:value];
}

- (id<IASKSettingsStore>)settingsStore {
    if (_settingsStore == nil) {
        self.settingsStore = [[IASKSettingsStoreUserDefaults alloc] init];
    }
    return _settingsStore;
}

- (void)setSettingsStore:(id<IASKSettingsStore>)settingsStore {
	if ([_settingsStore isKindOfClass:IASKSettingsStoreUserDefaults.class]) {
		IASKSettingsStoreUserDefaults *udSettingsStore = (id)_settingsStore;
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:udSettingsStore.defaults];
	}
	
	_settingsStore = settingsStore;
	
	if ([settingsStore isKindOfClass:IASKSettingsStoreUserDefaults.class]) {
		IASKSettingsStoreUserDefaults *udSettingsStore = (id)settingsStore;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(userDefaultsDidChange)
													 name:NSUserDefaultsDidChangeNotification
												   object:udSettingsStore.defaults];
	}
}

#pragma mark - selection

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
#if IL_UI_KIT

    if (indexPath == self.checkedItem) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    NSArray *values = [_specifier multipleValues];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self deselectCell:[self.tableView cellForRowAtIndexPath:self.checkedItem]];
    [self selectCell:[self.tableView cellForRowAtIndexPath:indexPath]];
    _checkedIndex = indexPath.row;

    [self.settingsStore setObject:[values objectAtIndex:indexPath.row] forKey:[_specifier key]];
    [self.settingsStore synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged
                                                        object:self
                                                      userInfo:@{
                                                          _specifier.key: values[indexPath.row]
                                                      }];
#endif
}

- (void)updateSelectionInCell:(ILTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.checkedItem]) {
        [self selectCell:cell];
    } else {
        [self deselectCell:cell];
    }
}

- (void)selectCell:(ILTableViewCell *)cell {
#if IL_UI_KIT
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    IASK_IF_PRE_IOS7([[cell textLabel] setTextColor:kIASKgrayBlueColor];);
#endif
}

- (void)deselectCell:(ILTableViewCell *)cell {
#if IL_UI_KIT
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    IASK_IF_PRE_IOS7([[cell textLabel] setTextColor:[UIColor darkTextColor]];);
#endif
}

#pragma mark Notifications

- (void)userDefaultsDidChange {
    NSIndexPath *oldCheckedItem = self.checkedItem;
    if (_specifier) {
        [self updateCheckedItem];
    }

    // only reload the table if it had changed; prevents animation cancellation
    if (![self.checkedItem isEqual:oldCheckedItem]) {
        [self.tableView reloadData];
    }
}

@end

//
//  FavTableViewController.h
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * favNombrePokemon;

@property (nonatomic, assign) BOOL isSomethingEnabled;

@property (weak, nonatomic) IBOutlet UITableView *favTableView;

@property (nonatomic, strong) NSArray * names;

@end

NS_ASSUME_NONNULL_END

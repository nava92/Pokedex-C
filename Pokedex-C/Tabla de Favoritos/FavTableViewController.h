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

//Se declara como data source y delegate a este view controller de nuestro TableView de detalles.

@interface FavTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


//Declaración de variables y conexión de Outlets.

@property (nonatomic, strong) NSMutableArray * favNombrePokemon;

@property (nonatomic, assign) BOOL isSomethingEnabled;

@property (weak, nonatomic) IBOutlet UITableView *favTableView;

@property (nonatomic, strong) NSArray * names;

@end

NS_ASSUME_NONNULL_END

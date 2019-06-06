//
//  ViewController.h
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

//Se cambia el NSLog habitual ya que esta limitado a los carácteres máximos del sistema (1024), Al ser JSON tan extensos se debió hacer esto, ya que de lo contrario no descargaba la información comleta en algunos casos.
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


//Se declara como data source y delegate a este view controller de nuestro TableView de detalles.

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

//Declaración de variables y conexión de Outlets.

@property (weak, nonatomic) IBOutlet UITextField *nombrePokemonTxtField;

@property (weak, nonatomic) IBOutlet UITextField *numeroPokemonTxtField;


- (IBAction)searchButton:(UIButton *)sender;



- (IBAction)favoriteButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButtonOutlet;



@property (weak, nonatomic) IBOutlet UILabel *nameL;


@property (weak, nonatomic) IBOutlet UIImageView *pokemonImage;



@property (strong, nonatomic) NSDictionary *tableViewData;

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetalles;




@property (strong, nonatomic) NSMutableDictionary *maindic;

@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, strong) NSMutableArray *values;

@property (nonatomic, strong) NSMutableArray *nombrePokemon;



@property (nonatomic, strong) NSMutableArray *abilitesArray;

@property (nonatomic, strong) NSMutableArray *formsArray;

@property (nonatomic, strong) NSMutableArray *gameIndicesArray;

@property (nonatomic, strong) NSMutableArray *heldItemsArray;

@property (nonatomic, strong) NSMutableArray *movesArray;

@property (nonatomic, strong) NSMutableArray *speciesArray;

@property (nonatomic, strong) NSMutableArray *statsArray;

@property (nonatomic, strong) NSMutableArray *typesArray;


@end


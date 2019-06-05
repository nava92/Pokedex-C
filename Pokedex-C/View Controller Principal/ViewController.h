//
//  ViewController.h
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);



@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nombrePokemonTxtField;

@property (weak, nonatomic) IBOutlet UITextField *numeroPokemonTxtField;



- (IBAction)searchButton:(UIButton *)sender;

- (IBAction)favoriteButton:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *nameL;


@property (weak, nonatomic) IBOutlet UIImageView *pokemonImage;



@property (strong, nonatomic) NSDictionary *tableViewData;

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetalles;




@property (strong, nonatomic) NSMutableDictionary *maindic;

@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, strong) NSMutableArray *values;

@property (nonatomic, strong) NSMutableArray *valuesID;

@property (nonatomic, strong) NSMutableArray *nombrePokemon;


@end


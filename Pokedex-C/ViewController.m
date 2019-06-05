//
//  ViewController.m
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//
//https://pokeapi.co/api/v2/pokemon/ditto

#import "ViewController.h"
#import "WebService.h"
#import "FavTableViewController.h"


#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


@interface ViewController ()
{
    NSString *mainstr;
    //NSDictionary *maindic;
    
    NSMutableArray *nameShowingLabel;
    NSArray *imageToShow;
    
    NSArray *abilities;
    NSArray *game_indices;
    
    
}



@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.keys = [[NSMutableArray alloc] init];
    
    self.values = [[NSMutableArray alloc] init];
    
    self.valuesID = [[NSMutableArray alloc] init];
    
    self.nombrePokemon = [[NSMutableArray alloc] init];
    
    /*NSMutableArray *temp2MutableArray = [[NSMutableArray alloc] initWithObjects:@"3", @"3", nil];
     
     [[NSUserDefaults standardUserDefaults] setObject:temp2MutableArray forKey:@"mySampleArray"];
     [[NSUserDefaults standardUserDefaults] synchronize];*/
    
}



- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing: TRUE];
}


- (IBAction)searchButton:(id)sender {
}

- (IBAction)favoriteButton:(id)sender {
}

- (IBAction)searchButton:(UIButton *)sender {
    if (_nombrePokemonTxtField.text.length == 0) {
        [self requestdataWithNumber];
        
    }
    if (_numeroPokemonTxtField.text.length == 0) {
        [self requestdataWithName];
        
    }
}

- (IBAction)favoriteButton:(UIButton *)sender {
    //FavTableViewController *viewControllerB = [[FavTableViewController alloc] initWithNibName:@"FavTableViewController" bundle:nil];
    //viewControllerB.favNombrePokemon = _nombrePokemon;
    //[self pushViewController:viewControllerB animated: YES];
    NSMutableArray *temp2MutableArray = [[NSMutableArray alloc] initWithObjects:[nameShowingLabel componentsJoinedByString:@", "], nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:temp2MutableArray forKey:@"mySampleArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"NombreFav = %@", nameShowingLabel)
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showFavsSegue"]){
        FavTableViewController *controller = (FavTableViewController *)segue.destinationViewController;
        controller.favNombrePokemon = nameShowingLabel;
        FavTableViewController *viewControllerB = [[FavTableViewController alloc] initWithNibName:@"FavTableViewController" bundle:nil];
        viewControllerB.favNombrePokemon = nameShowingLabel;
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 17;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.keys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = [[_maindic allKeys] objectAtIndex:section];
    return title;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell_id = @"myCell";
    UITableViewCell *cell = [_tableViewDetalles dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.keys objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setText:[self.values objectAtIndex:indexPath.row]];
    
    return cell;
}




-(void)requestdataWithName  //Función para recibir JSON si el usuario ingresa el Nombre del Pokemon
{
    mainstr = [NSString stringWithFormat:@"https://pokeapi.co/api/v2/pokemon/%@",_nombrePokemonTxtField.text];
    NSString * dbstr = [NSString stringWithFormat:@"Name=%@&Number=%@",_nombrePokemonTxtField.text,_numeroPokemonTxtField.text];
    [WebService executequery:mainstr strpremeter:dbstr withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"Data: %@", dbdata);
        if (dbdata!=nil)
        {
            _maindic = [NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Response Data: %@", self->_maindic);
            
            self->nameShowingLabel = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            self->_nombrePokemon = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            
            self->imageToShow = [[self->_maindic objectForKey:@"sprites"]valueForKey:@"front_default"];
            
            self->abilities = [self->_maindic objectForKey:@"abilities"];
            
            self->_nameL.text = [self->_nombrePokemon componentsJoinedByString:@", "];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self->imageToShow]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_pokemonImage setImage:[UIImage imageWithData:data]];
            });
            
            NSLog(@"NAME = %@",self->_nombrePokemon);
            NSLog(@"IMAGEB = %@", self->imageToShow);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewDetalles reloadData];
            });
        }
    }];
}

-(void)requestdataWithNumber //Función para recibir JSON si el usuario ingresa el Número del Pokemon
{
    mainstr = [NSString stringWithFormat:@"https://pokeapi.co/api/v2/pokemon/%@",_numeroPokemonTxtField.text];
    NSString * dbstr = [NSString stringWithFormat:@"%@",_numeroPokemonTxtField.text];
    [WebService executequery:mainstr strpremeter:dbstr withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"Data: %@", dbdata);
        if (dbdata!=nil)
        {
            _maindic = [NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Response Data: %@", self->_maindic);
            
            self->nameShowingLabel = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            self->imageToShow = [[self->_maindic objectForKey:@"sprites"]valueForKey:@"front_default"];
            
            
            
            self->_valuesID = [self->_maindic objectForKey:@"abilities"];
            self->game_indices = [self->_maindic objectForKey:@"game_indices"];
            
            
            
            self->_keys = [NSArray arrayWithArray:[self->_maindic allKeys]];
            self->_values = [NSArray arrayWithArray:[self->_maindic allValues]];
            
            /*for (NSDictionary *dict in dbdata) {
             [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
             NSArray *valueArray = (NSArray *)obj;
             
             for (NSDictionary * namesDict in valueArray) {
             [self->_values addObject:namesDict[@"name"]];
             }
             }];
             }*/
            
            
            self->_nameL.text = [self->nameShowingLabel componentsJoinedByString:@", "];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self->imageToShow]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_pokemonImage setImage:[UIImage imageWithData:data]];
            });
            
            NSLog(@"NAME = %@",self->nameShowingLabel);
            NSLog(@"IMAGEB = %@", self->imageToShow);
            NSLog(@"ABILITIES = %@", self->abilities);
            NSLog(@"GAME = %@", self->game_indices);
            
            
            //testTable = @[self->nameShowingLabel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewDetalles reloadData];
            });
            
            
            
        }
    }];
    
    
}
/*
 #pragma mark - Table view data source
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return [self.tableViewData count];
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 id sectionInfo= [self.tableViewData objectForKey:[NSString stringWithFormat:@"Section%ld", section +1]];
 return [(NSArray *)sectionInfo count];
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier =@"cellDetalles";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 id section = [self.tableViewData objectForKey:[NSString stringWithFormat:@"Section%ld", indexPath.section +1]];
 NSString *rowLabel = [section objectAtIndex:indexPath.row];
 cell.textLabel.text = rowLabel;
 
 return cell;
 
 }
 
 - (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 switch (section) {
 case 0:
 return @"Section1";
 break;
 
 default:
 return nil;
 break;
 }
 }
 
 
 */




@end

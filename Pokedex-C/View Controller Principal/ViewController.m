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
#import "AppDelegate.h"

//Se cambia el NSLog habitual ya que esta limitado a los carácteres máximos del sistema (1024), Al ser JSON tan extensos se debió hacer esto, ya que de lo contrario no descargaba la información comleta en algunos casos.

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


@interface ViewController ()
{
    //Se declaran las variables que van a contener los contenidos de nuestro JSON.
    NSString *mainstr;
    
    NSMutableArray *nameShowingLabel;
    NSArray *imageToShow;
    

    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSArray *dictionaries;
}
@end


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Se inicializan las variables que van a contener la información de nuestro JSON.
    self.keys = [[NSMutableArray alloc] init];
    
    self.values = [[NSMutableArray alloc] init];
    
    self.valuesID = [[NSMutableArray alloc] init];
    
    self.nombrePokemon = [[NSMutableArray alloc] init];
    
    
    
    //Para el uso de Core Data se define el contexto.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
}


//Función para "esconder" el teclado cuando el usuario toque en alguna parte de la pantalla.
- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing: TRUE];
}


//Botón para realizar la búsqueda del pokemon
- (IBAction)searchButton:(UIButton *)sender {
    
    //Se llama a la función en dado caso de que el usuario haya preferido buscar el pokemon por número.
    if (_nombrePokemonTxtField.text.length == 0) {
        [self requestdataWithNumber];
        
        
    //Se llama a la función en dado caso de que el usuario haya preferido buscar el pokemon por nombre.
    }
    if (_numeroPokemonTxtField.text.length == 0) {
        [self requestdataWithName];
        
    }
}

//Botón para guardar como favorito.
- (IBAction)favoriteButton:(UIButton *)sender {
    
    //Inicialización de la entidad y atributos en Core Data en donde se guardarán los datos
    NSManagedObject *entityObj = [NSEntityDescription insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:context];
    [entityObj setValue:self.nameL.text forKey:@"nombre"];
    
    NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Pokemon"];
    NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    NSLog(@"El nuevo pokemon favorito es: %@",[results valueForKey:@"nombre"]);
    
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
            
            
            
            self->_keys = [NSArray arrayWithArray:[self->_maindic allKeys]];
            self->_values = [NSArray arrayWithArray:[self->_maindic allValues]];
            
            
            
            
            self->_nameL.text = [self->nameShowingLabel componentsJoinedByString:@", "];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self->imageToShow]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_pokemonImage setImage:[UIImage imageWithData:data]];
            });
            
            NSLog(@"NAME = %@",self->nameShowingLabel);
            NSLog(@"IMAGE URL = %@", self->imageToShow);
            
            
            //Se actualiza el TableView con los datos de nuestro JSON dando los detalles del pokemon encontrado
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewDetalles reloadData];
            });
            
            
            
        }
    }];
    
    
}


@end

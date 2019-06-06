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
    
    
    self.nombrePokemon = [[NSMutableArray alloc] init];
    
    
    //Arrays que contienen info de las categorías del JSON.
    self.abilitesArray = [[NSMutableArray alloc] init];
    
    self.formsArray = [[NSMutableArray alloc] init];
    
    self.gameIndicesArray = [[NSMutableArray alloc] init];

    self.heldItemsArray = [[NSMutableArray alloc] init];

    self.movesArray = [[NSMutableArray alloc] init];

    self.speciesArray = [[NSMutableArray alloc] init];

    self.statsArray = [[NSMutableArray alloc] init];

    self.typesArray = [[NSMutableArray alloc] init];

    
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
    _favoriteButtonOutlet.hidden = NO;
}

//Botón para guardar como favorito.
- (IBAction)favoriteButton:(UIButton *)sender {
    
    //Inicialización de la entidad y atributos en Core Data en donde se guardarán los datos
    NSManagedObject *entityObj = [NSEntityDescription insertNewObjectForEntityForName:@"Pokemon" inManagedObjectContext:context];
    [entityObj setValue:self.nameL.text forKey:@"nombre"];
}


//Método para darle propiedades al TableView correspondiente a la información del pokemon encontrado.

//Se definen 8 secciones ya que son los headers de nuestro JSON en APIPokemon.
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}

//El numero de renglones en cada sección va a ser igual a la cantidad de keys dadas por el JSON.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return [self.abilitesArray count];
            break;
            
        case 1:
            return [self.formsArray count];
            break;
            
        case 2:
            return [self.gameIndicesArray count];
            break;
            
        case 3:
            return [self.heldItemsArray count];
            break;
            
        case 4:
            return [self.movesArray count];
            break;
            
        case 5:
            return [self.speciesArray count];
            break;
            
        case 6:
            return [self.statsArray count];
            break;
            
        case 7:
            return [self.typesArray count];
            break;
            
        default:
            return [self.typesArray count];
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Abilities";
            break;
            
        case 1:
            return @"Forms";
            break;
            
        case 2:
            return @"Game Indices";
            break;
            
        case 3:
            return @"Held Items";
            break;
            
        case 4:
            return @"Moves";
            break;
        
        case 5:
            return @"Species";
            break;
            
        case 6:
            return @"Stats";
            break;
            
        case 7:
            return @"Types";
            break;
            
        default:
            return @"Pokemon extra Data";
            break;
    }
}


//Se define el diseño de las celdas en la tabla.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell_id = @"myCell";
    UITableViewCell *cell = [_tableViewDetalles dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.abilitesArray objectAtIndex:indexPath.row]];
            break;
            
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.formsArray objectAtIndex:indexPath.row]];
            break;
            
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.gameIndicesArray objectAtIndex:indexPath.row]];
            break;
            
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.heldItemsArray objectAtIndex:indexPath.row]];
            break;
            
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.movesArray objectAtIndex:indexPath.row]];
            break;
            
        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.speciesArray objectAtIndex:indexPath.row]];
            break;
            
        case 6:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.statsArray objectAtIndex:indexPath.row]];
            break;
            
        case 7:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.typesArray objectAtIndex:indexPath.row]];
            break;
            
        default:
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.abilitesArray objectAtIndex:indexPath.row]];
            break;
    }
    

    //[cell.detailTextLabel setText:[self.values objectAtIndex:indexPath.row]];
    
    return cell;
}



//Función para realizar la búsqueda dado el nombre del pokemon.
-(void)requestdataWithName
{
    //Se realiza la conección a la API.
    mainstr = [NSString stringWithFormat:@"https://pokeapi.co/api/v2/pokemon/%@",_nombrePokemonTxtField.text];
    NSString * dbstr = [NSString stringWithFormat:@"Name=%@&Number=%@",_nombrePokemonTxtField.text,_numeroPokemonTxtField.text];
    
    //Se recibe la información y se imprime en consola.
    [WebService executequery:mainstr strpremeter:dbstr withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"Data: %@", dbdata);
        
        //Se verifica que no haya algún error en la descarga.
        if (dbdata!=nil)
        {
            //Se guarda la informacion en un diccionario (maindic).
            _maindic = [NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Response Data: %@", self->_maindic);
            
            //Del diccionario extraemos llaves que nos ayudaran en la presentación ante el usuario, como el nombre del pokemon y su imagen.
            
            self->nameShowingLabel = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            self->imageToShow = [[self->_maindic objectForKey:@"sprites"]valueForKey:@"front_default"];
            
            
            
            //Se llenan nuestros arrays con las keys del diccionario.
            self->_abilitesArray = [[[self->_maindic objectForKey:@"abilities"]valueForKey:@"ability"]valueForKey:@"name"];
            
            self->_formsArray = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            
            self->_gameIndicesArray = [[[self->_maindic objectForKey:@"game_indices"]valueForKey:@"version"]valueForKey:@"name"];
            
            self->_heldItemsArray = [[[self->_maindic objectForKey:@"held_items"]valueForKey:@"item"]valueForKey:@"name"];
            
            self->_movesArray = [[[self->_maindic objectForKey:@"moves"]valueForKey:@"move"]valueForKey:@"name"];
            
            self->_speciesArray = [[self->_maindic valueForKey:@"forms"]valueForKey:@"name"];
            
            self->_statsArray = [[[self->_maindic objectForKey:@"stats"]valueForKey:@"stat"]valueForKey:@"name"];
            
            self->_typesArray = [[[self->_maindic objectForKey:@"types"]valueForKey:@"type"]valueForKey:@"name"];
            
            
            //Se toman todos los valores del diccionario para llenar nuestra TableView.
            self->_keys = [NSArray arrayWithArray:[self->_maindic allKeys]];
            self->_values = [NSArray arrayWithArray:[self->_maindic allValues]];
            
            
            //Se asigna el nombre del pokemon buscado en un label (nameL).
            self->_nameL.text = [self->nameShowingLabel componentsJoinedByString:@", "];
            
            //Se descarga y se asigna la imagen del pokemon.
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self->imageToShow]];
            
            //Se actualiza nuesto TableView asincronamente.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_pokemonImage setImage:[UIImage imageWithData:data]];
            });
            
            //Se imprime en consola las propiedades a desplegar al usuario, solo para verificar que no haya algún error.
            NSLog(@"NAME = %@",self->nameShowingLabel);
            NSLog(@"IMAGE URL = %@", self->imageToShow);
            
            
            //Se actualiza el TableView con los datos de nuestro JSON dando los detalles del pokemon encontrado
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewDetalles reloadData];
            });
        }
    }];
}

-(void)requestdataWithNumber //Función para recibir JSON si el usuario ingresa el Número del Pokemon
{
    
    //Se realiza la conección a la API.
    mainstr = [NSString stringWithFormat:@"https://pokeapi.co/api/v2/pokemon/%@",_numeroPokemonTxtField.text];
    NSString * dbstr = [NSString stringWithFormat:@"%@",_numeroPokemonTxtField.text];
    
    //Se recibe la información y se imprime en consola.
    [WebService executequery:mainstr strpremeter:dbstr withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"Data: %@", dbdata);
        
        //Se verifica que no haya algún error en la descarga.
        if (dbdata!=nil)
        {
            //Se guarda la informacion en un diccionario (maindic).
            _maindic = [NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Response Data: %@", self->_maindic);
            
            //Del diccionario extraemos llaves que nos ayudaran en la presentación ante el usuario, como el nombre del pokemon y su imagen.
            
            self->nameShowingLabel = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            self->imageToShow = [[self->_maindic objectForKey:@"sprites"]valueForKey:@"front_default"];
            
            
            
            //Se llenan nuestros arrays con las keys del diccionario.
            self->_abilitesArray = [[[self->_maindic objectForKey:@"abilities"]valueForKey:@"ability"]valueForKey:@"name"];
            
            self->_formsArray = [[self->_maindic objectForKey:@"forms"]valueForKey:@"name"];
            
            self->_gameIndicesArray = [[[self->_maindic objectForKey:@"game_indices"]valueForKey:@"version"]valueForKey:@"name"];
            
            self->_heldItemsArray = [[[self->_maindic objectForKey:@"held_items"]valueForKey:@"item"]valueForKey:@"name"];
            
            self->_movesArray = [[[self->_maindic objectForKey:@"moves"]valueForKey:@"move"]valueForKey:@"name"];
            
            self->_speciesArray = [[self->_maindic valueForKey:@"forms"]valueForKey:@"name"];
            
            self->_statsArray = [[[self->_maindic objectForKey:@"stats"]valueForKey:@"stat"]valueForKey:@"name"];
            
            self->_typesArray = [[[self->_maindic objectForKey:@"types"]valueForKey:@"type"]valueForKey:@"name"];
            
            
            
            //Se toman todos los valores del diccionario para llenar nuestra TableView.
            self->_keys = [NSArray arrayWithArray:[self->_maindic allKeys]];
            self->_values = [NSArray arrayWithArray:[self->_maindic allValues]];
            
            
            //Se asigna el nombre del pokemon buscado en un label (nameL).
            self->_nameL.text = [self->nameShowingLabel componentsJoinedByString:@", "];
            
            //Se descarga y se asigna la imagen del pokemon.
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self->imageToShow]];
            
            //Se actualiza nuesto TableView asincronamente.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_pokemonImage setImage:[UIImage imageWithData:data]];
            });
            
            //Se imprime en consola las propiedades a desplegar al usuario, solo para verificar que no haya algún error.
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

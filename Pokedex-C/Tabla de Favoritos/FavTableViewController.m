//
//  FavTableViewController.m
//  Pokedex-C
//
//  Created by Eduardo Navarrete Carmona on 6/5/19.
//  Copyright © 2019 Eduardo Navarrete Carmona. All rights reserved.
//

#import "FavTableViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"


@interface FavTableViewController ()
{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSArray *dictionaries;
}


@end



@implementation FavTableViewController

//Se declara el contexto en el cual será manejada nuestra base de datos.
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

@class ViewController;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Se inicializa el Array que contendrá los datos guardados en nuestra base de datos.
    self.names = [[NSArray alloc] init];

    
    //Para el uso de Core Data se define el contexto.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    
    //Función de leer la base de datos y regresar los valores almacenados en ella. Los valores se regresan a un Array (names)
    NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Pokemon"];
    NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    self.names = [results valueForKey:@"nombre"];

    
    //Se imprime en consola para validar información.
    NSLog(@"Pokemones favoritos: %@", _names);
    
    [self.favTableView reloadData];
    
}



//Método para darle propiedades al TableView correspondiente a la información de core data.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.names count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    //Se configuran las celdas de nuestro tableView.
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [_names objectAtIndex:indexPath.row]]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [device valueForKey:@"city" ]];
    //[cell.detailTextLabel setText:[device valueForKey:@"country"]];
    
    return cell;
}

//Se definen las celdas como editables al regresar el valor booleano como true o YES en este caso.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.names objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
       
        //Método para eliminar celda y borrar dato de la base de datos.
        
        //[self.names removeObjectAtIndex:indexPath.row];
        //[self.favTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

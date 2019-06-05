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

//@property (strong) NSArray *names;

@end



@implementation FavTableViewController

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
    
    //NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Data"];
    //NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    //self.names = [results valueForKey:@"name"];
    
    // Log data
    
    //NSLog(@"name is %@",[results valueForKey:@"name"]);
    //NSLog(@"name is %@", _names);
    
    //[self.favTableView reloadData];
    
    // Fetch the devices from persistent data store
    //NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Data"];
    //self.names = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    //Load Data
    //NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Data"];
    //NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    //self.names = results;
    
//NSLog(@"BUENO %@",[results valueForKey:@"city"]);
    //[self.favTableView reloadData];
    //Load Data
    //NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Data"];
    //NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    //self.names = [results valueForKey:@"city"];
    
    // Log data
    
    //NSLog(@"name is %@",[results valueForKey:@"name"]);
    //NSLog(@"name is %@", _names);

    
    
}

@class ViewController;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.names = [[NSArray alloc] init];

    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    //self.favNombrePokemon = [[NSMutableArray alloc] init];
    
    //NSArray *tempArray2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"mySampleArray"];
    //NSMutableArray *tempArray2 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mySampleArray"] mutableCopy];
    
    //NSMutableArray *temp2MutableArray = [[NSMutableArray alloc] initWithArray:tempArray2];
    
    //self.favNombrePokemon = tempArray2;
    
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        //[self.favTableView reloadData];
    //});
    
    //NSLog(@"NombreFavo = %@", _favNombrePokemon)
    
    //appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //context = appDelegate.persistentContainer.viewContext;
    
    NSFetchRequest *requestExamLocation = [NSFetchRequest fetchRequestWithEntityName:@"Pokemon"];
    NSArray *results = [context executeFetchRequest:requestExamLocation error:nil];
    self.names = [results valueForKey:@"nombre"];
    
    // Log data
    
    //NSLog(@"name is %@",[results valueForKey:@"name"]);
    NSLog(@"Pokemones favoritos: %@", _names);
    
    [self.favTableView reloadData];
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.names count];
}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cell_id = @"favCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSLog(@"NO HAY DATOS");
        
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[self.favNombrePokemon objectAtIndex:indexPath.row]];
    //[cell.detailTextLabel setText:[self.favNombrePokemon objectAtIndex:indexPath.row]];
    
    return cell;
    
    
    NSLog(@"NombreFav = %@", _favNombrePokemon)
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //NSManagedObject *device = [_names objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [_names objectAtIndex:indexPath.row]]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [device valueForKey:@"city" ]];
    //[cell.detailTextLabel setText:[device valueForKey:@"country"]];
    
    return cell;
}


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
        
         //Remove device from table view
        //[self.names removeObjectAtIndex:indexPath.row];
        //[self.favTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

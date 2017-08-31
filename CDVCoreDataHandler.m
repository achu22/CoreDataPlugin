//
//  CDVCoreDataHandler.m
//  CoredataPlugin
//
//  Created by Alugaddala, Ashish Kumar [GCB-OT] on 8/25/17.
//
//

#import "CDVCoreDataHandler.h"
#import "AppDelegate.h"
#import "NamesListViewController.h"

@implementation CDVCoreDataHandler
    
- (void) valuesFromWeb:(CDVInvokedUrlCommand *)command {
    NSString* firstname = [[command arguments] firstObject];
    NSString* lastname = [[command arguments] lastObject];
    NSLog(@"valuesFromWeb: %@ %@",firstname,lastname);
    [self storeValuesToCoreDataWithFirstName:firstname andLastName:lastname];
}
    
- (void) fetchValuesFromCoredata:(CDVInvokedUrlCommand *)command {
    NSLog(@"fetchValuesFromCoredata");
    [self fetchValuesAndDisplay];
}

- (void) clearDataStore:(CDVInvokedUrlCommand *)command {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Info"]];
        NSError *error = nil;
        if(![context executeRequest:deleteRequest error:&error]) {
            NSLog(@"Delete Failed %@ %@", error, [error localizedDescription]);
        }
        
        if(![context save:&error]) {
            NSLog(@"Save Failed after clear! %@ %@", error, [error localizedDescription]);
        }
    });
}

- (void) fetchValuesAndDisplay {
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Info" inManagedObjectContext:context]];
    NSArray *namesList = [context executeFetchRequest:request error:nil];
    
    for (id field in namesList) {
        NSLog(@"%@ %@", [field valueForKey:@"firstname"], [field valueForKey:@"lastname"]);
    }
    if (namesList.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NamesListViewController *namesListVc = [[NamesListViewController alloc] initWithNibName:@"NamesListViewController" bundle:[NSBundle mainBundle]];
            namesListVc.namesListArray = [[NSMutableArray alloc] initWithArray:namesList];
            [self.viewController presentViewController:namesListVc animated:true completion:nil];
        });
    }
    else {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Empty Data Store"
                                                                      message:@"Data store is empty. Please enter first name, last name and submit and try to fetch again"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
        [alert addAction:okayButton];
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }
}
    
- (void) storeValuesToCoreDataWithFirstName:(NSString *) firstname andLastName:(NSString *) lastname {

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        //Custom NSManagedObjectContext for concurrency
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        context.persistentStoreCoordinator = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.persistentStoreCoordinator;
        //((AppDelegate *)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        
        NSManagedObject *info = [NSEntityDescription insertNewObjectForEntityForName:@"Info" inManagedObjectContext:context];
        
        [info setValue:firstname forKey:@"firstname"];
        [info setValue:lastname forKey:@"lastname"];
        
        // Save the context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
        }
        
    });
}
    

@end

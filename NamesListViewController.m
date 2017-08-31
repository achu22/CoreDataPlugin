//
//  NamesListViewController.m
//  CoredovaPlugin
//
//  Created by Alugaddala, Ashish Kumar [GCB-OT] on 8/29/17.
//
//

#import "NamesListViewController.h"
#import "AppDelegate.h"

@interface NamesListViewController ()

@end

@implementation NamesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _namesListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[[_namesListArray objectAtIndex:indexPath.row] valueForKey:@"firstname"], [[_namesListArray objectAtIndex:indexPath.row] valueForKey:@"lastname"]];
    
    return cell;
}
- (IBAction)dismissNamesListVc:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clearDataStore:(id)sender {
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_namesListArray removeAllObjects];
            [_namesListTableView reloadData];
        });
    });
}


@end

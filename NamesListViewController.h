//
//  NamesListViewController.h
//  CoredovaPlugin
//
//  Created by Alugaddala, Ashish Kumar [GCB-OT] on 8/29/17.
//
//

#import <UIKit/UIKit.h>
#import "CDVCoreDataHandler.h"

@interface NamesListViewController : UIViewController<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *namesListTableView;

@property(nonatomic,strong) NSMutableArray *namesListArray;

@property(nonatomic,weak) CDVCoreDataHandler *coredataHandler;
    
@end

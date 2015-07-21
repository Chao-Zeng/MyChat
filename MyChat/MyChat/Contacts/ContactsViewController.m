//
//  ContactsViewController.m
//  MyChat
//
//  Created by Charles on 15/5/28.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddContactsViewController.h"
#import "EditContactsViewController.h"
#import "PersonInfo.h"

@interface ContactsViewController ()

@property UITableView *tableView;
@property NSFetchedResultsController *fetchedResultsController;
@property NSManagedObjectContext *managedObjectContext;
@property UISearchBar *searchBar;

- (id)init;
- (void)presentAddContactsViewController;
- (void)getContactsInfo;
- (void)searchContactsWithKeyText:(NSString *)keyText;
@end

@implementation ContactsViewController

@synthesize tableView = _tableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

//==================methods implementation===================================
-(id)init
{
    if(self = [super init])
    {
        self.title = @"Contacts";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:nil selectedImage:nil];
        [self getContactsInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentAddContactsViewController)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 44.0f)];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.placeholder = @"search name";
    self.tableView.tableHeaderView = self.searchBar;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)getContactsInfo{
    id delegate = [[UIApplication sharedApplication] delegate];
    //获取托管对象上下文
    self.managedObjectContext = [delegate managedObjectContext];
    //请求对象
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersonInfo"];
    //排序对象
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"initialOfName"
                                                                                   cacheName:@"PersonInfo"];
    //设置数据变化通知的代理为自己
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if(!success){
        NSLog(@"NSFetchedResultsController error:%@" , error);
    }
}

- (void)presentAddContactsViewController{
    AddContactsViewController *addContactsViewController = [[AddContactsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:addContactsViewController animated:YES];
}

- (void)searchContactsWithKeyText:(NSString *)keyText{
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", keyText];
    [self.fetchedResultsController.fetchRequest setPredicate:searchPredicate];
    
    //delete cache
    [NSFetchedResultsController deleteCacheWithName:@"PersonInfo"];
    
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if(!success){
        NSLog(@"NSFetchedResultsController error:%@" , error);
        return;
    }
    
    [self.tableView reloadData];
}

//===========UITableViewDataSource protocol============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellReuseIdentifier = @"cellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    
    PersonInfo *personInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = personInfo.name;
    cell.imageView.image = [UIImage imageWithContentsOfFile:personInfo.headPortrait];
    //cell.imageView.contentMode = UIViewContentModeScaleToFill;
        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    } else
        return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        PersonInfo *personInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:personInfo];
        
        NSError *error;
        [self.managedObjectContext save:&error];
        if(error){
            NSLog(@"删除联系人%@失败:%@", personInfo.name, error);
        }
    }
}


//===========UITableViewDelegate protocol==============
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonInfo *personInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EditContactsViewController *editContactsViewController = [[EditContactsViewController alloc] initWithPersonInfo:personInfo];
    
    [self.navigationController pushViewController:editContactsViewController animated:YES];
}


//===========NSFetchedResultsControllerDelegate========
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

//数据变化引起分区的变化时调用
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

//增,删,改,移动 后执行
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
//                    atIndexPath:indexPath];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

//=====================UISearchBarDelegate protocol========================

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchContactsWithKeyText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = nil;
    [self.fetchedResultsController.fetchRequest setPredicate:nil];
    
    //delete cache
    [NSFetchedResultsController deleteCacheWithName:@"PersonInfo"];
    
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if(!success){
        NSLog(@"NSFetchedResultsController error:%@" , error);
        return;
    }
    
    [self.tableView reloadData];
}

@end

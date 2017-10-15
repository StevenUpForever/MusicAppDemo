//
//  CommentTableViewController.m
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/18.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CoreDataProcess.h"
#import "LikeEntity.h"
#import "DetailEntity.h"
#import "CommentsTableViewCell.h"
#import "WriteCommentsViewController.h"

@interface CommentTableViewController ()<NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"commentTableView"]];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comments" forIndexPath:indexPath];
    DetailEntity  *detailEntity  = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.detailComment.text = detailEntity.comments;
    cell.detailImage.image = [UIImage imageWithData:detailEntity.imageData];
    cell.detailImage.layer.cornerRadius = CGRectGetWidth(cell.detailImage.frame)/2.0f;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - fetch coreData

- (NSFetchRequest *)entrylistFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"DetailEntity"];
    fetchRequest.sortDescriptors =@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return fetchRequest;
}


- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    CoreDataProcess *coreDataProcess = [CoreDataProcess defaultStack];
    NSFetchRequest *fetchRequest = [self entrylistFetchRequest];
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataProcess.managedObjectContext sectionNameKeyPath:@"section" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailEntity *detailEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CoreDataProcess *core = [CoreDataProcess defaultStack];
    [core.managedObjectContext deleteObject:detailEntity];
    [core saveContext];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch (type){
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"modify"])
    {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        WriteCommentsViewController *comment = segue.destinationViewController;
        comment.detailEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
}

@end

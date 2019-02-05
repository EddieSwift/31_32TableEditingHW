//
//  EGBViewController.m
//  31_32TableEditingHW
//
//  Created by Eduard Galchenko on 2/2/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBViewController.h"
#import "EGBStudent.h"
#import "EGBGroup.h"

@interface EGBViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groupsArray;

@end

@implementation EGBViewController

- (void) loadView {
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    self.tableView.editing = NO;
    
    self.tableView.allowsSelectionDuringEditing = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.groupsArray = [NSMutableArray array];
    
    for (int i = 0; i < arc4random() % 6 + 5; i++) {
        
        EGBGroup *group = [[EGBGroup alloc] init];
        group.name = [NSString stringWithFormat:@"Group #%d", i];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int j = 0; j < arc4random() % 11 + 15; j++) {
            
            [array addObject:[EGBStudent randomStudent]];
        }
        
        group.students = array;
        
        [self.groupsArray addObject:group];
    }
    
    [self.tableView reloadData];
    
    self.navigationItem.title = @"Students";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(actionAddSection:)];
    
    self.navigationItem.leftBarButtonItem = addButton;
}

#pragma mark - Actions

- (void) actionAddSection:(UIBarButtonItem*) sender {
    
    EGBGroup *group = [[EGBGroup alloc] init];
    
    NSUInteger groupCount = [self.groupsArray count];
    
    group.name = [NSString stringWithFormat:@"Group #%ld", groupCount];
    
    group.students = @[[EGBStudent randomStudent], [EGBStudent randomStudent]];
    
    NSInteger newSectionIndex = 0;
    
    [self.groupsArray insertObject:group atIndex:newSectionIndex];
    
    [self.tableView beginUpdates];
    
    NSIndexSet *insertSection = [NSIndexSet indexSetWithIndex:newSectionIndex];
    
    UITableViewRowAnimation animation = UITableViewRowAnimationFade;
    
    if ([self.groupsArray count] > 1) {
        
        animation = [self.groupsArray count] % 2 ?UITableViewRowAnimationAutomatic : UITableViewRowAnimationRight;
    }
    
    
    [self.tableView insertSections:insertSection
                  withRowAnimation: animation];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
    
}

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    
    //    self.navigationItem.rightBarButtonItem = editButton;
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groupsArray objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    EGBGroup *group = [self.groupsArray objectAtIndex:section];
    
    return [group.students count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        static NSString *addStudentIdentifier = @"AddStudentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
            cell.textLabel.text = @"Tap to add new student";
            cell.textLabel.textColor = [UIColor blueColor];
        }
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        EGBGroup *group = [self.groupsArray objectAtIndex:indexPath.section];
        EGBStudent *student = [group.students objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.2f", student.averageGrade];
        
        if (student.averageGrade >= 4.0) {
            cell.detailTextLabel.textColor = [UIColor greenColor];
        } else if (student.averageGrade >= 3.0) {
            cell.detailTextLabel.textColor = [UIColor orangeColor];
        } else {
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    EGBGroup* sourceGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    EGBStudent* student = [sourceGroup.students objectAtIndex:sourceIndexPath.row - 1];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        
        if (sourceIndexPath.row > destinationIndexPath.row) {
            
            [tempArray insertObject:student atIndex:destinationIndexPath.row];
            [tempArray removeObjectAtIndex:sourceIndexPath.row - 1];
            
        } else {
            
            [tempArray insertObject:student atIndex:destinationIndexPath.row - 1];
            [tempArray removeObjectAtIndex:sourceIndexPath.row];
        }
        
        sourceGroup.students = tempArray;
        
    } else {
        
        [tempArray removeObject:student];
        sourceGroup.students = tempArray;
        
        EGBGroup* destinationGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.students];
        [tempArray insertObject:student atIndex:destinationIndexPath.row];
        destinationGroup.students = tempArray;
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EGBGroup* sourceGroup = [self.groupsArray objectAtIndex:indexPath.section];
        EGBStudent* student = [sourceGroup.students objectAtIndex:indexPath.row - 1];
            
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
        [tempArray removeObject:student];
        sourceGroup.students = tempArray;
            
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGBGroup* sourceGroup = [self.groupsArray objectAtIndex:indexPath.section];
    NSInteger sectionSize = [sourceGroup.students count];
    
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
    
    if (sectionSize == 0) {
        
        return style;
    }
    
    
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone: UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath; {
    
    if (proposedDestinationIndexPath.row == 0) {
        
        return sourceIndexPath;
        
    } else {
        
        return proposedDestinationIndexPath;
    }
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        EGBGroup *group = [self.groupsArray objectAtIndex:indexPath.section];
        NSMutableArray* tempArray = nil;
        
        if (group.students) {
            
            tempArray = [NSMutableArray arrayWithArray:group.students];
            
        } else {
            
            tempArray = [NSMutableArray array];
        }
        
        NSInteger newStudentIndex = 0;
        [tempArray insertObject:[EGBStudent randomStudent] atIndex:newStudentIndex];
        group.students = tempArray;
        [self.tableView beginUpdates];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newStudentIndex + 1 inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    }
}

@end



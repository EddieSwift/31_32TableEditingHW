//
//  EGBViewController.m
//  31_32TableEditingHW
//
//  Created by Eduard Galchenko on 2/2/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBViewController.h"
#import "EGBGroup.h"
#import "EGBStudent.h"

@interface EGBViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
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
    
    self.tableView.editing = YES;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.groupsArray = [NSMutableArray array];
    
    for (int i = 0; i < arc4random() % 5 + 6; i++) {
        
        EGBGroup *group = [[EGBGroup alloc] init];
        group.name = [NSString stringWithFormat:@"Group #%d", i];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (int j = 0; j < arc4random() % 1 + 15; j++) {
            
            [array addObject:[EGBStudent randomStudent]];
        }
        
        group.students = array;
        
        [self.groupsArray addObject:group];
    }

    [self.tableView reloadData];
}

#pragma markd - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    EGBGroup *group = [self.groupsArray objectAtIndex:section];
    
    return [group.students count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.groupsArray objectAtIndex:section] name];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    EGBGroup *group = [self.groupsArray objectAtIndex:indexPath.section];
    EGBStudent *student = [group.students objectAtIndex:indexPath.row];
    
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



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    EGBGroup* sourceGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    EGBStudent* student = [sourceGroup.students objectAtIndex:sourceIndexPath.row];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:sourceGroup.students];
    

    if (sourceIndexPath.section == destinationIndexPath.section) {

        [tempArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
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

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return arc4random() % 1000 / 500 ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

/*
// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
 
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;                               // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;


*/


@end

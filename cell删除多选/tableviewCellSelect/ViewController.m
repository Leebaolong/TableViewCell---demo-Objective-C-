//
//  ViewController.m
//  tableviewCellSelect
//
//  Created by 刘光军 on 15/11/15.
//  Copyright © 2015年 刘光军. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *deleteArr;//删除数据的数组
@property(nonatomic, strong) NSMutableArray *markArr;//标记数据的数组
@property(nonatomic, strong) UIButton *selectAllBtn;//选择按钮
@property(nonatomic, strong) UIView *baseView;//背景view
@property(nonatomic, strong) UIButton *deleteBtn;//删除

@end

@implementation ViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"科比·布莱恩特",@"德里克·罗斯",@"勒布朗·詹姆斯",@"凯文·杜兰特",@"德怀恩·韦德",@"克里斯·保罗",@"德怀特·霍华德",@"德克·诺维斯基",@"德隆·威廉姆斯",@"斯蒂夫·纳什",@"保罗·加索尔",@"布兰顿·罗伊",@"奈特·阿奇博尔德",@"鲍勃·库西",@"埃尔文·约翰逊"]];
        
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.deleteArr = [NSMutableArray array];
    self.markArr = [NSMutableArray array];
    
    self.title = @"首页";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.editing = NO;
    
    //选择按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    [selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    self.navigationItem.rightBarButtonItem =selectItem;
    
    //全选
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectAllBtn.frame = CGRectMake(0, 0, 60, 30);
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_selectAllBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    _selectAllBtn.hidden = YES;
    
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 60, self.view.frame.size.width, 60)];
    _baseView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_baseView];
    
    //删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.backgroundColor = [UIColor redColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.enabled = NO;
    [_baseView addSubview:_deleteBtn];
    
}
    //删除按钮点击事件
- (void)deleteClick:(UIButton *) button {
    
    if (self.tableView.editing) {
    //删除
         [self.dataArray removeObjectsInArray:self.deleteArr];
         [self.tableView reloadData];

    }
    else return;
}

    //选择按钮点击响应事件
- (void)selectedBtn:(UIButton *)button {
    
    _deleteBtn.enabled = YES;
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        _selectAllBtn.hidden = NO;
        [button setTitle:@"完成" forState:UIControlStateNormal];
            
    }else{
        _selectAllBtn.hidden = YES;
        [button setTitle:@"选择" forState:UIControlStateNormal];
    }
    
}
    //全选
- (void)selectAllBtnClick:(UIButton *)button {

    for (int i = 0; i < self.dataArray.count; i ++) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self.deleteArr addObjectsFromArray:self.dataArray];
    }
    NSLog(@"self.deleteArr:%@", self.deleteArr);
}

//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//选择编辑的方式,按照选择的方式对表进行处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
    }

}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.deleteArr addObject:[self.dataArray objectAtIndex:indexPath.row]];
    
}
//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.deleteArr removeObject:[self.dataArray objectAtIndex:indexPath.row]];
}

#pragma mark tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ident  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
//    //长按手势
//    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressedAct:)];
//    longPressed.minimumPressDuration = 1;
//    [cell.contentView addGestureRecognizer:longPressed];
    return cell;
}

/*
-(void)longPressedAct:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan) {
            CGPoint point = [gesture locationInView:self.tableView];
            NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
            if(indexPath == nil) return ;
        self.tableView.editing = YES;
        }
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

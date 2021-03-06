//
//  UserViewController.m
//  HutHelper
//
//  Creatde by nine on 2016/11/19.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "UserViewController.h"
#import "JSHeaderView.h"
#import "UserInfoCell.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
 
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSONKit.h"
#import "MBProgressHUD+MJ.h"
#import "UserCell.h"
#import "UserHeaderCell.h"
#import "UsernameViewController.h"
#import "WebViewController.h"
#import "AFNetworking.h"
static NSString *const kUserInfoCellId = @"kUserInfoCellId";
static NSString *const kUserInfoCellHeadID = @"kUserInfoCellHeadID";

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
        NSMutableArray *datas;
}
@property (nonatomic, copy)NSString *m_auth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserViewController
UIImage* img ;

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //关闭tableview的横线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=RGB(247, 247, 247, 1);
    self.tableView.scrollEnabled = NO;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    [self getAllClasses];
}


- (void)getAllClasses{
    [APIRequest GET:[Config getApiAllClass] parameters:nil
            success:^(id responseObject) {
         HideAllHUD
        NSDictionary *all = [NSDictionary dictionaryWithDictionary:responseObject];
            NSLog(@"class200");
        //NSLog(@"%@",[all  objectForKey:@"data"]);
        NSDictionary *data = [all  objectForKey:@"data"];
        [Config saveAllClasses:data];
        [self reLoadData:data];
       // NSLog(@"%@",[Config getAllClasses]);
//        if ([all[@"code"] isEqualToString:@200]) {
//            NSLog(@"class200");
//        }
     } failure:^(NSError *error) {
         HideAllHUD
         [MBProgressHUD showError:@"网络错误" toView:self.view];
     }];
}
-(void)reLoadData:(NSDictionary*)JSONDic{
//    datas = [[NSMutableArray alloc]init];
//    for (NSDictionary *eachDic in JSONDic) {
////        MomentsModel *momentsModel=[[MomentsModel alloc]initWithDic:eachDic];
//        //[datas addObject:eachDic];
//        NSLog(@"%@",eachDic);
//        NSLog(@"%@",JSONDic);
//          NSMutableDictionary *provinceDic = [NSMutableDictionary dictionary];
//        //provinceName：城市名   cityArray：城市字典
//          [provinceDic setObject:[eachDic allKeys] forKey:@"depName"];
//          NSMutableArray *cityArray = [NSMutableArray array];
//          [provinceDic setObject:[eachDic allValues] forKey:@"depClass"];
//        [datas addObject:provinceDic];
//        
//    }
//    NSLog(@"%@",datas);
}

- (void)getImageFromIpc
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    img = info[UIImagePickerControllerEditedImage]; //获得修改后
    // img = [info objectForKey:UIImagePickerControllerOriginalImage];   //获得原图
    NSData *imageData = UIImageJPEGRepresentation(img,1.0);
    int length = (short)[imageData length]/1024;
    if (length<=2500) {
        [self postimage:img];
    }
    else{
        UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"头像大小过大"
                                                                               message:@"请重新选择"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"取消"
                                                                     otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
- (void)postimage:(UIImage *)img
{
    [MBProgressHUD showMessage:@"上传中" toView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *url_String=Config.getApiProfileAvatar;
    
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
    [manager POST:url_String parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        HideAllHUD
        [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
        [Config saveCacheImg:imageData];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HideAllHUD
        [MBProgressHUD showError:@"上传失败" toView:self.view];
    }];
}


#pragma mark - tableView protocal methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return SYReal(65.f);
    }
    return SYReal(45.f);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==1||section==7) {
        return 10;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellHeadID];
        if (!cell) {
            cell = [[UserHeaderCell alloc] initWithName:@"头像" withInfo:Config.getHeadPicThumb reuseIdentifier:kUserInfoCellHeadID];
        }
        return cell;
    }else if(indexPath.section == 1){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            NSString *username=Config.getUserName;
            if ([username isEqualToString:@""]) {
                username=@"未设置";
            }
            cell = [[UserCell alloc] initWithName:@"昵称" withInfo:username reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }else if(indexPath.section == 2){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"签名" withInfo:@"" reuseIdentifier:kUserInfoCellId];
        }
        return cell;
        

    }else if(indexPath.section == 3){

        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"密码" withInfo:@"点击修改" reuseIdentifier:kUserInfoCellId];
        }
        return cell;
        

    }else if(indexPath.section == 4){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"学院" withInfo:Config.getDepName reuseIdentifier:kUserInfoCellId];
        }
        return cell;
        

    }else if(indexPath.section == 5){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"班级" withInfo:Config.getClassName reuseIdentifier:kUserInfoCellId];
        }
        return cell;
        

    }else if(indexPath.section == 6){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"QQ" withInfo:@"" reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }else if(indexPath.section == 7){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"姓名" withInfo:Config.getTrueName reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }else if(indexPath.section == 8){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"性别" withInfo:Config.getSex reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }else if(indexPath.section == 9){
        UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserCell alloc] initWithName:@"学号" withInfo:Config.getStudentKH reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Username"];
    WebViewController *webViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Web"];
    webViewController.urlString=Config.getApiLoginReset;
    webViewController.viewTitle=@"重置密码";
    switch ((short)indexPath.section) {
        case 0:
            [self getImageFromIpc];
            break; //改头像
        case 1:
            //[self presentViewController:secondViewController animated:true completion:nil];
            [self.navigationController pushViewController:secondViewController animated:YES];
            break; //改昵称
        case 2:
            [self presentViewController:webViewController animated:true completion:nil];
            break; //改签名
        case 3:
            [self presentViewController:webViewController animated:true completion:nil];
                break; //改密码
        case 4:
            [self presentViewController:webViewController animated:true completion:nil];
            break; //改学院
        case 5:
            [self presentViewController:webViewController animated:true completion:nil];
            break; //改班级
        case 6:
            [self presentViewController:webViewController animated:true completion:nil];
            break; //改QQ
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end

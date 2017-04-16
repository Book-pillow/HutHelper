//
//  Config.h
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface Config : NSObject

+ (void)setIs:(int )Is;
+ (int )getIs;
+(void)addNotice;
#pragma mark - 可持续存储
+(void)saveUser:(NSDictionary*)userData;
+(void)saveRememberCodeApp:(NSString*)rememberCodeApp;
+(void)saveCurrentVersion:(NSString*)currentVersion;
+(void)saveCourseXp:(NSArray*)course;
+(void)saveCourse:(NSArray*)course;
+(void)saveWidgetCourse:(NSArray*)course;
+(void)saveWidgetCourseXp:(NSArray*)course;
+(void)saveSay:(NSDictionary*)sayData;
+(void)saveSayLikes:(NSDictionary*)sayLikesData;
+(void)saveHand:(NSArray*)handData;
+(void)saveScore:(NSData*)scoreData;
+(void)saveScoreRank:(NSArray*)examRank;
+(void)saveExam:(NSData*)examData;
+(void)saveLost:(NSArray*)lostData;
+(void)saveNowWeek:(int)nowWeek;
+(void)saveVedio:(NSDictionary*)vedioData;
+(void)saveVedio480p:(NSString*)vedioString;
+(void)saveVedio1080p:(NSString*)vedioString;
#pragma mark - 获得存储数据
+(NSArray*)getCourse;
+(NSArray*)getCourseXp;
+(NSDictionary*)getVedio;
+(NSString*)getVedio480p;
+(NSString*)getVedio1080p;
+(NSDictionary*)getSay;
+(NSDictionary*)getSayLike;
+(NSArray*)getHand;
+(NSArray*)getOtherHand;
+(NSData*)getExam;
+(NSArray*)getScoreRank;
#pragma mark - 获得用户数据
+(User*)getUser;
+(NSString*)getStudentKH;
+(NSString*)getUserName;
+(NSString*)getTrueName;
+(NSString*)getAddress;
+(NSString*)getClassName;
+(NSString*)getDepName;
+(NSString*)getHeadPicThumb;
+(NSString*)getLastLogin;
+(NSString*)getSex;
+(NSString*)getUserId;
+(NSString*)getRememberCodeApp;

#pragma mark - 设置
+(void)saveUmeng;
+(void)removeUmeng;
+(void)removeUserDefaults;
+(void)setNoSharedCache;
+(void)pushViewController:(NSString*)controller;
@end

//
//  Config+Api.h
//  HutHelper
//
//  Created by Nine on 2017/5/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"

@interface Config (Api)
+(NSString*)getApiVedioShow;
+(NSString*)getApiClass;
+(NSString*)getApiClassXP;
+(NSString*)getApiExam;
+(NSString*)getApiScores;
+(NSString*)getApiRank;
+(NSString*)getApiLogin;
+(NSString*)getApiLoginReset;
+(NSString*)getApiProfileUser;
+(NSString*)getApiProfileAvatar;
+(NSString*)getApiHomeWork;
+(NSString*)getApiPower;

+(NSString*)getApiGoods;
+(NSString*)getApiGoodsUser;
+(NSString*)getApiGoodsCreate;
+(NSString*)getApiGoodsImgUpload;
+(NSString*)getApiGoodsShow;

+(NSString*)getApiLost;
+(NSString*)getApiLostUser;
+(NSString*)getApiLostCreate;
+(NSString*)getApiLostImgUpload;

+(NSString*)getApiMoments;
+(NSString*)getApiMomentsUser;
+(NSString*)getApiMomentsCreate;
+(NSString*)getApiMomentsImgUpload;
+(NSString*)getApiMomentsDelete;
+(NSString*)getApiMomentsCommentDelete;
+(NSString*)getApiMomentsCreateComment;
+(NSString*)getApiMomentsLikesCreate;
+(NSString*)getApiMomentsLikesShow;


+(NSString*)getApiFeedback;
+(NSString*)getApiImg;

+(NSString*)apiIndex;
@end
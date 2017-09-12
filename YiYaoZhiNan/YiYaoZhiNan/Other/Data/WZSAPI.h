//
//  WZSAPI.h
//  YiYao
//
//  Created by wzs on 16/6/18.
//  Copyright © 2016年 WZS. All rights reserved.
//

#ifndef WZSAPI_h
#define WZSAPI_h

#define HOMEPAGE @"http://openapi.ypt.langma.cn/yws/?json=%7B%0A%20%20%22op_type%22%20%3A%201003%2C%0A%20%20%22c_ver%22%20%3A%20%224.1.1%22%2C%0A%20%20%22c_type%22%20%3A%200%2C%0A%20%20%22uid%22%20%3A%200%2C%0A%20%20%22cid%22%20%3A%200%0A%7D"

#define LEFTIMAGE @"http://openapi.ypt.langma.cn/yws/?json=%7B%0A%20%20%22op_type%22%20%3A%201006%2C%0A%20%20%22c_ver%22%20%3A%20%224.1.1%22%2C%0A%20%20%22c_type%22%20%3A%200%2C%0A%20%20%22uid%22%20%3A%2028112945%2C%0A%20%20%22activity_id%22%20%3A%20%221%22%2C%0A%20%20%22cid%22%20%3A%200%0A%7D"

#define RIGHTMAGE @"http://openapi.ypt.langma.cn/yws/?json=%7B%0A%20%20%22op_type%22%20%3A%201006%2C%0A%20%20%22c_ver%22%20%3A%20%224.1.1%22%2C%0A%20%20%22c_type%22%20%3A%200%2C%0A%20%20%22uid%22%20%3A%2028112945%2C%0A%20%20%22activity_id%22%20%3A%20%222%22%2C%0A%20%20%22cid%22%20%3A%200%0A%7D"

#define PINPAI @"http://openapi.db.39.net/app/GetDrugCompany?app_key=app&sign=9DFAAD5404FCB6168EA6840DCDFF39E5"

#define FENLEI @"http://openapi.db.39.net/app/GetDrugsByCategory?CategoryName=%@&app_key=app&curPage=%ld&limit=20&sign=9DFAAD5404FCB6168EA6840DCDFF39E5&tags="

#define SOUSUO @"http://openapi.db.39.net/app/GetDrugWords?app_key=app&key=%@&sign=9DFAAD5404FCB6168EA6840DCDFF39E5"

#define SOUSUO_DETAIL @"http://openapi.db.39.net/app/GetDrugs?app_key=app&curPage=%ld&limit=20&sign=9DFAAD5404FCB6168EA6840DCDFF39E5&tags=&word=%@"
#define SOUSOU_DETAIL_MORE @"http://openapi.db.39.net/app/GetDrugsByCategory?CategoryName=%@&app_key=app&curPage=%ld&limit=20&sign=9DFAAD5404FCB6168EA6840DCDFF39E5&tags="

#define DRUG_INSTRUCTION @"http://openapi.db.39.net/app/GetDrugById?app_key=app&id=%ld&sign=9DFAAD5404FCB6168EA6840DCDFF39E5"


#define DRUG_COMMENT @"http://openapi.db.39.net/app/GetDrugComments?Limit=30&app_key=app&curPage=1&drugId=%ld&sign=9DFAAD5404FCB6168EA6840DCDFF39E5"

//508806

#endif /* WZSAPI_h */

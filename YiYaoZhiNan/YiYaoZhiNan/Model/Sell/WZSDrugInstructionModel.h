//
//  WZSDrugInstructionModel.h
//  药品手册
//
//  Created by wzs on 16/6/24.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZSDrugInstructionModel : NSObject
PROPERTY(namecn);
PROPERTY(refdrugcompanyname);
PROPERTY(gongneng);
PROPERTY(composition);
PROPERTY(drugattribute);
PROPERTY(unit);
PROPERTY(usage);
PROPERTY(adr);
PROPERTY(contraindication);
PROPERTY(note);
PROPERTY(interaction);
PROPERTY(pharmacology);
PROPERTY(storage);
PROPERTY(shelflife);
PROPERTY(codename);
PROPERTY(standard);
PROPERTY(specificationdate);
PROPERTY(titleimg);
@property (nonatomic,assign)float avgprice;
@property (nonatomic,assign)NSInteger _id;
@property (nonatomic,assign)NSInteger score;
@property (nonatomic,assign)BOOL basemed;
@property (nonatomic,assign)NSInteger newotc;
@property (nonatomic,assign)NSInteger medcare;
@end

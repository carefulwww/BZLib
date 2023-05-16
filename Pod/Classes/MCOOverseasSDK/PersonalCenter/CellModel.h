//
//  CellModel.h
//  MCOOverseasProject
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject

@property(nonatomic,copy)NSString *cellName;
@property(nonatomic,copy)NSString *imageUrl;

-initWithShowInfor:(NSDictionary *)infor;

@end

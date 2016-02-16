//
//  tableTests.m
//  tableTests
//
//  Created by Vlad on 15.02.16.
//  Copyright © 2016 Vlad. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TableDataController.h"
#import "CellModel.h"


@interface tableTests : XCTestCase

@end

@implementation tableTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCoreDataImageCache
{
    TableDataController *tableDataController = [[TableDataController alloc] initWithTableView:nil];
    NSData *data = [@"asd" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *url = @"url";
    [tableDataController addImageFromData:data withURL:url];
    NSData *newData = [tableDataController ImageDataWithURL:url];
    XCTAssertEqualObjects(data, newData);
}
//
//- (void)testUpdateCellModelProperties
//{
//    CellModel *cell = [[CellModel alloc] initWithEntity:<#(nonnull NSEntityDescription *)#> insertIntoManagedObjectContext:<#(nullable NSManagedObjectContext *)#>;
//    NSDictionary *newCellData = @{@"title" : @"Title",
//                                  @"subTitle" : @"SUBTitle",
//                                  @"imageUrl" : @"imagee",
//                                  @"updatedAt" : @"updateDate"};
//    [cell updateCellWithDictionary:newCellData];
//    XCTAssertEqualObjects(cell.title, [newCellData objectForKey:@"title"]);
//}

@end

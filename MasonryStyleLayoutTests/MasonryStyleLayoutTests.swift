//
//  MasonryStyleLayoutTests.swift
//  MasonryStyleLayoutTests
//
//  Created by 酒井文也 on 2019/01/07.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import XCTest
@testable import MasonryStyleLayout

class MasonryStyleLayoutTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testPhotoGalleryViewModel() {

        // 必要なViewModelを初期化する(APIアクセス部分とState部分はMockを利用)
        let notificationCenter = NotificationCenter()
        let viewModel = PhotoGalleryViewModel(notificationCenter: notificationCenter, state: MockPhotoGalleryListState.shared, api: MockMealsAPIManager.shared)

        // フェッチを実行前の初期状態
        XCTAssertEqual(false, MockPhotoGalleryListState.shared.isTotalCount, "初回時のisTotalCountはfalseである")
        XCTAssertEqual(0, MockPhotoGalleryListState.shared.currentPage, "初回時のcurrentPageは0である")
        XCTAssertEqual(0, MockPhotoGalleryListState.shared.getPhotoListMappedByCategories().count, "PhotoEntity総数は0である")

        // 1回目のフェッチを実行
        fetchFirst(viewModel: viewModel, timeOutSec: 15.0)

        // 2回目のフェッチを実行
        fetchSecond(viewModel: viewModel, timeOutSec: 45.0)

        // 3回目のフェッチを実行
        fetchThird(viewModel: viewModel, timeOutSec: 75.0)

        // 4回目のフェッチを実行
        fetchFourth(viewModel: viewModel, timeOutSec: 105.0)
    }
    
    // MARK: - Private Function

    // 1回目のフェッチを実行
    private func fetchFirst(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        let firstFetchRequestExpectation: XCTestExpectation? = self.expectation(description: "firstFetchRequestExpectation")

        // サブスレッドでViewModelのメソッドを実行する
        DispatchQueue.global().async {

            viewModel.fetchPhotoList()

            // メインスレッドでStateのデータを取得する
            DispatchQueue.main.async {
                photosForTesting = MockPhotoGalleryListState.shared.getPhotoListMappedByCategories()
                firstFetchRequestExpectation?.fulfill()
            }
        }

        // 引数で指定したタイムアウト時間内に処理された場合
        waitForExpectations(timeout: timeOutSec, handler: { _ in

            // ページングに必要な変数のテスト
            XCTAssertEqual(false, MockPhotoGalleryListState.shared.isTotalCount, "isTotalCountはfalseである")
            XCTAssertEqual(1, MockPhotoGalleryListState.shared.currentPage, "currentPageは1である")

            // スタブから取得したデータで合致する値のペアを定義
            let testCases: [(expectedCategoryNumber: Int, expectedPhotosCount: Int)] = [
                (expectedCategoryNumber: 1, expectedPhotosCount: 7),
                (expectedCategoryNumber: 2, expectedPhotosCount: 3),
            ]

            // 期待する数と合致するかのテスト
            photosForTesting.enumerated().forEach{ (index, element) in
                
                // その1: カテゴリ番号のテスト
                let expectedCategoryNumber = testCases[index].expectedCategoryNumber
                let categoryNumberResult = (element.categoryNumber == expectedCategoryNumber)
                XCTAssertTrue(categoryNumberResult, "\(index)番目のcategoryNumberは\(expectedCategoryNumber)と合致する。")

                // その2: カテゴリ番号に紐づく写真の枚数のテスト
                let expectedPhotosCount = testCases[index].expectedPhotosCount
                let photosCountResult = (element.photos.count == expectedPhotosCount)
                XCTAssertTrue(photosCountResult, "\(index)番目のphotos.countは\(expectedPhotosCount)と合致する。")
            }
        })
    }

    // 2回目のフェッチを実行
    private func fetchSecond(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        let secondFetchRequestExpectation: XCTestExpectation? = self.expectation(description: "secondFetchRequestExpectation")

        // サブスレッドでViewModelのメソッドを実行する
        DispatchQueue.global().async {

            viewModel.fetchPhotoList()

            // メインスレッドでStateのデータを取得する
            DispatchQueue.main.async {
                photosForTesting = MockPhotoGalleryListState.shared.getPhotoListMappedByCategories()
                secondFetchRequestExpectation?.fulfill()
            }
        }

        // 引数で指定したタイムアウト時間内に処理された場合
        waitForExpectations(timeout: timeOutSec, handler: { _ in

            // ページングに必要な変数のテスト
            XCTAssertEqual(false, MockPhotoGalleryListState.shared.isTotalCount, "isTotalCountはfalseである")
            XCTAssertEqual(2, MockPhotoGalleryListState.shared.currentPage, "currentPageは2である")

            // スタブから取得したデータで合致する値のペアを定義
            let testCases: [(expectedCategoryNumber: Int, expectedPhotosCount: Int)] = [
                (expectedCategoryNumber: 1, expectedPhotosCount: 7),
                (expectedCategoryNumber: 2, expectedPhotosCount: 7),
                (expectedCategoryNumber: 3, expectedPhotosCount: 6),
            ]

            // 期待する数と合致するかのテスト
            photosForTesting.enumerated().forEach{ (index, element) in

                // その1: カテゴリ番号のテスト
                let expectedCategoryNumber = testCases[index].expectedCategoryNumber
                let categoryNumberResult = (element.categoryNumber == expectedCategoryNumber)
                XCTAssertTrue(categoryNumberResult, "\(index)番目のcategoryNumberは\(expectedCategoryNumber)と合致する。")

                // その2: カテゴリ番号に紐づく写真の枚数のテスト
                let expectedPhotosCount = testCases[index].expectedPhotosCount
                let photosCountResult = (element.photos.count == expectedPhotosCount)
                XCTAssertTrue(photosCountResult, "\(index)番目のphotos.countは\(expectedPhotosCount)と合致する。")
            }
        })
    }

    // 3回目のフェッチを実行
    private func fetchThird(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        let thirdFetchRequestExpectation: XCTestExpectation? = self.expectation(description: "thirdFetchRequestExpectation")

        // サブスレッドでViewModelのメソッドを実行する
        DispatchQueue.global().async {

            viewModel.fetchPhotoList()

            // メインスレッドでStateのデータを取得する
            DispatchQueue.main.async {
                photosForTesting = MockPhotoGalleryListState.shared.getPhotoListMappedByCategories()
                thirdFetchRequestExpectation?.fulfill()
            }
        }

        // 引数で指定したタイムアウト時間内に処理された場合
        waitForExpectations(timeout: timeOutSec, handler: { _ in

            // ページングに必要な変数のテスト
            XCTAssertEqual(false, MockPhotoGalleryListState.shared.isTotalCount, "isTotalCountはfalseである")
            XCTAssertEqual(3, MockPhotoGalleryListState.shared.currentPage, "currentPageは3である")

            // スタブから取得したデータで合致する値のペアを定義
            let testCases: [(expectedCategoryNumber: Int, expectedPhotosCount: Int)] = [
                (expectedCategoryNumber: 1, expectedPhotosCount: 7),
                (expectedCategoryNumber: 2, expectedPhotosCount: 7),
                (expectedCategoryNumber: 3, expectedPhotosCount: 7),
                (expectedCategoryNumber: 4, expectedPhotosCount: 7),
                (expectedCategoryNumber: 5, expectedPhotosCount: 2),
            ]

            // 期待する数と合致するかのテスト
            photosForTesting.enumerated().forEach{ (index, element) in

                // その1: カテゴリ番号のテスト
                let expectedCategoryNumber = testCases[index].expectedCategoryNumber
                let categoryNumberResult = (element.categoryNumber == expectedCategoryNumber)
                XCTAssertTrue(categoryNumberResult, "\(index)番目のcategoryNumberは\(expectedCategoryNumber)と合致する。")

                // その2: カテゴリ番号に紐づく写真の枚数のテスト
                let expectedPhotosCount = testCases[index].expectedPhotosCount
                let photosCountResult = (element.photos.count == expectedPhotosCount)
                XCTAssertTrue(photosCountResult, "\(index)番目のphotos.countは\(expectedPhotosCount)と合致する。")
            }
        })
    }

    // 4回目のフェッチを実行
    private func fetchFourth(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        let fourthFetchRequestExpectation: XCTestExpectation? = self.expectation(description: "fourthFetchRequestExpectation")

        // サブスレッドでViewModelのメソッドを実行する
        DispatchQueue.global().async {

            viewModel.fetchPhotoList()

            // メインスレッドでStateのデータを取得する
            DispatchQueue.main.async {
                photosForTesting = MockPhotoGalleryListState.shared.getPhotoListMappedByCategories()
                fourthFetchRequestExpectation?.fulfill()
            }
        }
        
        // 引数で指定したタイムアウト時間内に処理された場合
        waitForExpectations(timeout: timeOutSec, handler: { _ in

            // ページングに必要な変数のテスト
            XCTAssertEqual(true, MockPhotoGalleryListState.shared.isTotalCount, "isTotalCountはtrueである")
            XCTAssertEqual(4, MockPhotoGalleryListState.shared.currentPage, "currentPageは4である")

            // スタブから取得したデータで合致する値のペアを定義
            let testCases: [(expectedCategoryNumber: Int, expectedPhotosCount: Int)] = [
                (expectedCategoryNumber: 1, expectedPhotosCount: 7),
                (expectedCategoryNumber: 2, expectedPhotosCount: 7),
                (expectedCategoryNumber: 3, expectedPhotosCount: 7),
                (expectedCategoryNumber: 4, expectedPhotosCount: 7),
                (expectedCategoryNumber: 5, expectedPhotosCount: 7),
                (expectedCategoryNumber: 6, expectedPhotosCount: 5),
            ]

            // 期待する数と合致するかのテスト
            photosForTesting.enumerated().forEach{ (index, element) in

                // その1: カテゴリ番号のテスト
                let expectedCategoryNumber = testCases[index].expectedCategoryNumber
                let categoryNumberResult = (element.categoryNumber == expectedCategoryNumber)
                XCTAssertTrue(categoryNumberResult, "\(index)番目のcategoryNumberは\(expectedCategoryNumber)と合致する。")

                // その2: カテゴリ番号に紐づく写真の枚数のテスト
                let expectedPhotosCount = testCases[index].expectedPhotosCount
                let photosCountResult = (element.photos.count == expectedPhotosCount)
                XCTAssertTrue(photosCountResult, "\(index)番目のphotos.countは\(expectedPhotosCount)と合致する。")
            }
        })
    }
}

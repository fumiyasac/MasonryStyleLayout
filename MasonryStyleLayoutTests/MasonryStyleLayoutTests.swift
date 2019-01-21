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

    private func fetchFirst(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        // 1回目のフェッチを実行
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
            // スタブから取得したデータのテスト
            XCTAssertEqual(1, photosForTesting[0].categoryNumber, "categoryNumberは1である")
            XCTAssertEqual(7, photosForTesting[0].photos.count, "photos.countは7である")
            XCTAssertEqual(2, photosForTesting[1].categoryNumber, "categoryNumberは2である")
            XCTAssertEqual(3, photosForTesting[1].photos.count, "photos.countは3である")
        })
    }

    private func fetchSecond(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        // 2回目のフェッチを実行
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
            // スタブから取得したデータのテスト
            XCTAssertEqual(1, photosForTesting[0].categoryNumber, "categoryNumberは1である")
            XCTAssertEqual(7, photosForTesting[0].photos.count, "photos.countは7である")
            XCTAssertEqual(2, photosForTesting[1].categoryNumber, "categoryNumberは2である")
            XCTAssertEqual(7, photosForTesting[1].photos.count, "photos.countは7である")
            XCTAssertEqual(3, photosForTesting[2].categoryNumber, "categoryNumberは3である")
            XCTAssertEqual(6, photosForTesting[2].photos.count, "photos.countは6である")
        })
    }

    private func fetchThird(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        // 3回目のフェッチを実行
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
            // スタブから取得したデータのテスト
            XCTAssertEqual(1, photosForTesting[0].categoryNumber, "categoryNumberは1である")
            XCTAssertEqual(7, photosForTesting[0].photos.count, "photos.countは7である")
            XCTAssertEqual(2, photosForTesting[1].categoryNumber, "categoryNumberは2である")
            XCTAssertEqual(7, photosForTesting[1].photos.count, "photos.countは7である")
            XCTAssertEqual(3, photosForTesting[2].categoryNumber, "categoryNumberは3である")
            XCTAssertEqual(7, photosForTesting[2].photos.count, "photos.countは7である")
            XCTAssertEqual(4, photosForTesting[3].categoryNumber, "categoryNumberは4である")
            XCTAssertEqual(7, photosForTesting[3].photos.count, "photos.countは7である")
            XCTAssertEqual(5, photosForTesting[4].categoryNumber, "categoryNumberは5である")
            XCTAssertEqual(2, photosForTesting[4].photos.count, "photos.countは2である")
        })
    }

    private func fetchFourth(viewModel: PhotoGalleryViewModel, timeOutSec: TimeInterval) {
        var photosForTesting: [(categoryNumber: Int, photos: [PhotoEntity])]  = []

        // 4回目のフェッチを実行
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
            // スタブから取得したデータのテスト
            XCTAssertEqual(1, photosForTesting[0].categoryNumber, "categoryNumberは1である")
            XCTAssertEqual(7, photosForTesting[0].photos.count, "photos.countは7である")
            XCTAssertEqual(2, photosForTesting[1].categoryNumber, "categoryNumberは2である")
            XCTAssertEqual(7, photosForTesting[1].photos.count, "photos.countは7である")
            XCTAssertEqual(3, photosForTesting[2].categoryNumber, "categoryNumberは3である")
            XCTAssertEqual(7, photosForTesting[2].photos.count, "photos.countは7である")
            XCTAssertEqual(4, photosForTesting[3].categoryNumber, "categoryNumberは4である")
            XCTAssertEqual(7, photosForTesting[3].photos.count, "photos.countは7である")
            XCTAssertEqual(5, photosForTesting[4].categoryNumber, "categoryNumberは5である")
            XCTAssertEqual(7, photosForTesting[4].photos.count, "photos.countは7である")
            XCTAssertEqual(6, photosForTesting[5].categoryNumber, "categoryNumberは6である")
            XCTAssertEqual(5, photosForTesting[5].photos.count, "photos.countは5である")
        })
    }
}

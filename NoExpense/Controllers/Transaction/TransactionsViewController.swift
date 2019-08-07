//
//  TransactionsViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 19/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx
import GoogleMobileAds
import Reachability
import RxReachability

final class TransactionsViewController: ViewController, BindableType {
  
  @IBOutlet weak fileprivate var emptyButton: UIButton!
  @IBOutlet weak fileprivate var emptyStackView: UIStackView!
  @IBOutlet weak fileprivate var expenseStackView: UIStackView!
  @IBOutlet weak fileprivate var totalExpenseStackView: UIStackView!
  @IBOutlet weak fileprivate var thisMonthExpenseStackView: UIStackView!
  @IBOutlet weak fileprivate var tableView: UITableView!
  @IBOutlet weak fileprivate var newTransactionButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var totalExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var thisMonthExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var totalExpenseButton: UIButton!
  @IBOutlet weak fileprivate var thisMonthExpenseButton: UIButton!
  
  @IBOutlet weak fileprivate var entireStackView: UIStackView!
  @IBOutlet weak fileprivate var emptyIconLabel: UILabel!
  @IBOutlet weak fileprivate var emptyTitleLabel: UILabel!
  @IBOutlet weak fileprivate var emptyDescriptionLabel: UILabel!

  fileprivate let reachability = Reachability()!
  var viewModel: TransactionsViewModel!
  fileprivate var dataSource: RxTableViewSectionedAnimatedDataSource<TransactionSection>!
  fileprivate var interstitial: GADInterstitial!
  
  var isTableViewEmpty: Bool {
    get {
      return tableView.visibleCells.isEmpty
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    logEventAsync(eventType: .transcation_list_viewed)
    showAd()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Reachability.rx.isReachable
      .bind(to: newTransactionButton.rx.isEnabled)
      .disposed(by: rx.disposeBag)
    
    Reachability.rx.isReachable
      .subscribe(onNext: { [weak self] isReachable in
        guard let strongSelf = self else { return }
        if isReachable {
          strongSelf.interstitial = strongSelf.createAndLoadInterstitial()
          strongSelf.viewModel.isEmpty
            .subscribe(onNext: { (val) in
              strongSelf.emptyState(hide: !val, isEmpty: val)
            })
            .disposed(by: strongSelf.rx.disposeBag)
        } else {
          strongSelf.emptyState(title: "InternetConnectionErrorTitle".localized, message: "InternetConnectionError".localized, icon: "🔥", button: "RetryTitle".localized)
        }
      })
      .disposed(by: rx.disposeBag)
    
    interstitial = createAndLoadInterstitial()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 60
    tableView.register(UINib(nibName: "TransactionCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
    emptyButton.roundCorners(withRadius: 8)
    
    configureDatasource()
    setEditing(true, animated: false)
  }
  
  func bindViewModel() {
    newTransactionButton.rx.action = viewModel.onCreateTransaction()
    emptyButton.rx.action = viewModel.onCreateTransaction()
    totalExpenseButton.rx.action = viewModel.expense(of: .totalExpense)
    thisMonthExpenseButton.rx.action = viewModel.expense(of: .thisMonth)
    bindTableView()
    bindExpensesUI()
    expenseStackView.isHidden = isTableViewEmpty
    emptyStackView.isHidden = !isTableViewEmpty
  }
  
  fileprivate func configureDatasource() {
    dataSource = RxTableViewSectionedAnimatedDataSource<TransactionSection>(configureCell: { _, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
      cell.configure(with: item)
      return cell
    }, titleForHeaderInSection: { dataSource, index in
      dataSource.sectionModels[index].model
    }, canEditRowAtIndexPath: { _, _ in true })
  }
  
  fileprivate func bindTableView() {
    viewModel.sectionItems
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: rx.disposeBag)
    
    tableView.rx.itemSelected
      .map { [unowned self] indexPath in
        return try! self.dataSource.model(at: indexPath) as! TransactionItem
      }
      .subscribe(viewModel.editAction.inputs)
      .disposed(by: rx.disposeBag)
    
    tableView.rx.itemDeleted
      .map { [unowned self] indexPath in
        self.showAd()
        return try! self.dataSource.model(at: indexPath) as! TransactionItem
      }
      .subscribe(viewModel.deleteAction.inputs)
      .disposed(by: rx.disposeBag)
  }
  
  fileprivate func bindExpensesUI() {
    let totalExpenseShared = viewModel.expenseStatistics
      .map { $0.total }
      .share()
    
    totalExpenseShared
      .map { $0.expenseString }
      .bind(to: totalExpenseLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    totalExpenseShared
      .map { $0 == 0 }
      .bind(to: thisMonthExpenseStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
    
    let thisMonthExpenseShared = viewModel.expenseStatistics
      .map { $0.thisMonth }
      .share()
    
    thisMonthExpenseShared
      .map { $0.expenseString }
      .bind(to: thisMonthExpenseLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    thisMonthExpenseShared
      .map { $0 == 0 }
      .bind(to: thisMonthExpenseStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
    
    viewModel.isEmpty
      .bind(to: expenseStackView.rx.isHidden)
      .disposed(by: rx.disposeBag)
  }
}
// MARK: - Private Methods
private extension TransactionsViewController {
  func createAndLoadInterstitial() -> GADInterstitial {
    let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2476036802725781/3456716519")
    interstitial.delegate = self
    interstitial.load(GADRequest())
    return interstitial
  }
  
  func showAd() {
    guard checkForAds(), interstitial.isReady else {
      logEventAsync(eventType: .interstitial_ad_was_not_ready)
      return
    }
    interstitial.present(fromRootViewController: self)
  }
  
  func emptyState(title: String? = nil, message: String? = nil, icon: String? = nil, button: String? = nil, hide: Bool = false, isEmpty: Bool = false) {
    entireStackView.isHidden = !hide
    totalExpenseButton.isHidden = !hide
    thisMonthExpenseButton.isHidden = !hide
    emptyStackView.isHidden = hide
    guard !hide else { return }
    emptyTitleLabel.text = isEmpty ? "EmptyTitle".localized : title
    emptyDescriptionLabel.text = isEmpty ? "EmptyDescription".localized : message
    emptyIconLabel.text = isEmpty ? "🍠" : icon
    emptyButton.isHidden = !isEmpty
  }
}

extension TransactionsViewController: GADInterstitialDelegate {
  /// Tells the delegate an ad request succeeded.
  func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    print("interstitialDidReceiveAd")
  }
  
  /// Tells the delegate an ad request failed.
  func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
    print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
  }
  
  /// Tells the delegate that an interstitial will be presented.
  func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    print("interstitialWillPresentScreen")
  }
  
  /// Tells the delegate the interstitial is to be animated off the screen.
  func interstitialWillDismissScreen(_ ad: GADInterstitial) {
    print("interstitialWillDismissScreen")
  }
  
  /// Tells the delegate the interstitial had been animated off the screen.
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    interstitial = createAndLoadInterstitial()
  }
  
  /// Tells the delegate that a user click will open another app
  /// (such as the App Store), backgrounding the current app.
  func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    print("interstitialWillLeaveApplication")
  }
}

//
//  OverviewViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 20/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import PieCharts
import GoogleMobileAds
import Reachability
import RxReachability

final class OverviewViewController: ViewController, BindableType {
  @IBOutlet weak fileprivate var totalExpenseChart: PieChart!
  @IBOutlet weak fileprivate var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak fileprivate var totalExpenseLabel: UILabel!
  @IBOutlet weak fileprivate var nativeAdPlaceholder: UIView!
  @IBOutlet weak fileprivate var scrollView: UIScrollView!
  @IBOutlet weak fileprivate var outerContentView: UIView!
  @IBOutlet weak fileprivate var headerTitleLabel: UILabel!
  
  @IBOutlet weak fileprivate var emptyStackView: UIStackView!
  @IBOutlet weak fileprivate var emptyTitleLabel: UILabel!
  @IBOutlet weak fileprivate var emptyDescriptionLabel: UILabel!
  @IBOutlet weak fileprivate var emptyIconLabel: UILabel!
  
  var viewModel: OverviewViewModel!
  fileprivate var adLoader: GADAdLoader!
  fileprivate var heightConstraint: NSLayoutConstraint?
  fileprivate var nativeAdView: GADUnifiedNativeAdView!
  fileprivate let reachability = Reachability()!

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    logEventAsync(eventType: .overview_viewed, parameters: ["type": viewModel.overviewType.rawValue])
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    headerTitleLabel.text = viewModel.overviewType.title
    navigationItem.title = "Overview".localized
    Reachability.rx.isReachable
      .subscribe(onNext: { [weak self] isReachable in
        if isReachable {
          self?.emptyState(hide: true)
        } else {
          self?.emptyState(title: "InternetConnectionErrorTitle".localized, message: "InternetConnectionError".localized, icon: "🔥", button: "RetryTitle".localized)
        }
      })
      .disposed(by: rx.disposeBag)
    
    guard let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
      let adView = nibObjects.first as? GADUnifiedNativeAdView else {
        assert(false, "Could not load nib file for adView")
        return
    }
    setAdView(adView)
    refreshAd()
  }
  
  func bindViewModel() {
    cancelBarButton.rx.action = viewModel.onCancel
    totalExpenseChart.layers = viewModel.pieChartLayers
    
    viewModel.expenses
      .map { $0.expenseString }
      .bind(to: totalExpenseLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    viewModel.slices
      .subscribe(onNext: { models in
        self.totalExpenseChart.models = models
      })
      .disposed(by: rx.disposeBag)
  }
}
extension OverviewViewController: GADUnifiedNativeAdLoaderDelegate {
  override func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    print("didFailToReceiveAdWithError: \(error.localizedDescription)")
  }
  
  func adLoader(_ adLoader: GADAdLoader,
                didReceive nativeAd: GADUnifiedNativeAd) {
    nativeAdView.nativeAd = nativeAd
    heightConstraint?.isActive = false
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
    if let controller = nativeAd.videoController, controller.hasVideoContent() {
      controller.delegate = self
      print("Ad contains a video asset.")
    } else {
      print("Ad does not contain a video.")
    }
    if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
      heightConstraint = NSLayoutConstraint(item: mediaView, attribute: .height, relatedBy: .equal, toItem: mediaView, attribute: .width, multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio), constant: 0)
      heightConstraint?.isActive = true
    }
    
    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
    nativeAdView.bodyView?.isHidden = nativeAd.body == nil
    
    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
    
    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
    nativeAdView.iconView?.isHidden = nativeAd.icon == nil
    
    nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
    
    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
    nativeAdView.storeView?.isHidden = nativeAd.store == nil
    
    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
    nativeAdView.priceView?.isHidden = nativeAd.price == nil
    
    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
    nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
    
    nativeAdView.callToActionView?.isUserInteractionEnabled = false
    scrollView.contentSize = outerContentView.frame.size
  }
  
  func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
    print("adLoaderDidFinishLoading: ")
  }
}

extension ViewController: GADVideoControllerDelegate {
  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    print("Video playback has ended.")
  }
}

extension ViewController: GADAdLoaderDelegate {
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
  }
}
// MARK: - Private Methods
private extension OverviewViewController {
  func setAdView(_ view: GADUnifiedNativeAdView) {
    nativeAdView = view
    nativeAdPlaceholder.addSubview(nativeAdView)
    nativeAdView.translatesAutoresizingMaskIntoConstraints = false
    
    let viewDictionary = ["_nativeAdView": nativeAdView!]
    self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                            options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
  }
  
  func refreshAd() {
    adLoader = GADAdLoader(adUnitID: "ca-app-pub-2476036802725781/4521552025", rootViewController: self,
                           adTypes: [ .unifiedNative ], options: nil)
    adLoader.delegate = self
    adLoader.load(GADRequest())
  }
  
  func emptyState(title: String? = nil, message: String? = nil, icon: String? = nil, button: String? = nil, hide: Bool = false) {
    scrollView.isHidden = !hide
    emptyStackView.isHidden = hide
    guard !hide else { return }
    emptyTitleLabel.text = title
    emptyDescriptionLabel.text = message
    emptyIconLabel.text = icon
  }
}

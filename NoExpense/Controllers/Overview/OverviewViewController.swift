//
//  OverviewViewController.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 20/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import PieCharts

final class OverviewViewController: ViewController, BindableType {
  @IBOutlet weak fileprivate var pieChart: PieChart!
  @IBOutlet weak fileprivate var cancelBarButton: UIBarButtonItem!
  
  var viewModel: OverviewViewModel!
  
  func bindViewModel() {
    cancelBarButton.rx.action = viewModel.onCancel
    pieChart.layers = [createTextLayer(), createCustomViewsLayer()]
    viewModel.slices
      .subscribe(onNext: { models in
        self.pieChart.models = models
      })
      .disposed(by: rx.disposeBag)
  }
}

private extension OverviewViewController {
  func createCustomViewsLayer() -> PieCustomViewsLayer {
    let viewLayer = PieCustomViewsLayer()
    
    let settings = PieCustomViewsLayerSettings()
    settings.viewRadius = 135
    settings.hideOnOverflow = false
    viewLayer.settings = settings
    
    viewLayer.viewGenerator = createViewGenerator()
    return viewLayer
  }
  
  func createTextLayer() -> PiePlainTextLayer {
    let textLayerSettings = PiePlainTextLayerSettings()
    textLayerSettings.viewRadius = 75
    textLayerSettings.hideOnOverflow = true
    textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
    
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    textLayerSettings.label.textGenerator = {slice in
      return formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%" } ?? ""
    }
    
    let textLayer = PiePlainTextLayer()
    textLayer.settings = textLayerSettings
    return textLayer
  }
  
  func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
    return { slice, center in
      guard let category = slice.data.model.obj as? CategoryType else { return UIView() }
      let container = UIView()
      container.frame.size = CGSize(width: 100, height: 40)
      container.center = center
      let view = UIImageView()
      view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
      container.addSubview(view)
      
      let specialTextLabel = UILabel()
      specialTextLabel.textColor = .darkGray
      specialTextLabel.textAlignment = .center
      specialTextLabel.text = category.rawValue.capitalized
      specialTextLabel.sizeToFit()
      specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
      container.addSubview(specialTextLabel)
      container.frame.size = CGSize(width: 100, height: 60)
      view.image = category.image
      return container
    }
  }
}

//
//  ViewController.swift
//  PickerViewSample
//
//  Created by Daisaku Ejiri on 2022/10/25.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
  
  let bag: DisposeBag = DisposeBag()
  
  var category: String = ""
  
  
  var quality: JazzQuality = .major7th {
    didSet {
      print(quality)
    }
  }
  
  var voicing: Voicing = .drop2 {
    didSet {
      print(voicing)
    }
  }
  
  var inversion: Inversion = .root {
    didSet {
      print(inversion)
    }
  }
  
  var rootOrTop: RootOrTop = .root {
    didSet {
      print(rootOrTop)
    }
  }
  
  var note: Note = .C {
    didSet {
      print(note)
    }
  }
  
  let bannerHeight: CGFloat = 100.0
  
  var labelWidth: CGFloat {
    viewWidth*0.3
  }
  
  var labelHeight: CGFloat {
    areaHeight/2
  }
  
  var areaMargin: CGFloat {
    viewWidth*0.05
  }
  
  var areaGap: CGFloat {
    viewHeight*0.01
  }
  
  var areaHeight: CGFloat {
    viewHeight/11
  }
  
  var buttonWidth: CGFloat {
    viewWidth/2
  }
  
  var buttonHeight: CGFloat {
    appAreaHeight / 2 * 0.3
  }
  
  var viewWidth: CGFloat {
    view.bounds.width
  }
  
  var viewHeight: CGFloat{
    view.bounds.height
  }
  
  var topInset: CGFloat {
    view.safeAreaInsets.top
  }
  
  var bottomInset: CGFloat {
    view.safeAreaInsets.bottom
  }
  
  var appAreaHeight: CGFloat {
    viewHeight - topInset - bottomInset - bannerHeight
  }
  
  // MARK: ChordQuality
  
  lazy var qualitySelectArea: UIView = {
    let view = UIView()
    return view
  }()
  
  lazy var qualityLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var qualityPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.tag = 1
    return picker
  }()
  
  
  // MARK: Voicing
  
  lazy var voicingSelectArea: UIView = {
    let view = UIView()
    return view
  }()
  
  lazy var voicingLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var voicingPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.tag = 2
    return picker
  }()
  
  // MARK: Inversion
  
  lazy var inversionSelectArea: UIView = {
    let view = UIView()
    return view
  }()
  
  lazy var inversionLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var inversionPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.tag = 3
    return picker
  }()
  
  
  // MARK: Note Selection
  lazy var noteSelectArea: UIView = {
    let view = UIView()
    return view
  }()
  
  lazy var rootOrTopPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.tag = 4
    return picker
  }()
  
  lazy var notePicker: UIPickerView = {
    let picker = UIPickerView()
    picker.tag = 5
    return picker
  }()
  
  // MARK: GoButton
  
  lazy var goButton: UIButton = {
    let button = UIButton()
    let buttonColor = UIColor.link
    let uiImage = Helper.createUIImageFromUIColor(color: Constants.searchButtonColor)
    button.setBackgroundImage(uiImage, for: .normal)
    button.setTitleColor(Constants.textColorWhite, for: .normal)
    button.titleLabel?.font = UIFont(name: Constants.appBasicFont, size: areaHeight*0.4)
    button.setTitle("Search", for: .normal)
    button.layer.cornerRadius = 10
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(onGoButtonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.rowHeight = 400
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(dismissSelf))
    
    view.addSubview(qualitySelectArea)
    view.addSubview(voicingSelectArea)
    view.addSubview(inversionSelectArea)
    view.addSubview(noteSelectArea)
    view.addSubview(goButton)
    
    
    qualityPicker.delegate = self
    qualityPicker.dataSource = self
    
    voicingPicker.delegate = self
    voicingPicker.dataSource = self
    
    inversionPicker.delegate = self
    inversionPicker.dataSource = self
    
    rootOrTopPicker.delegate = self
    rootOrTopPicker.dataSource = self
    
    notePicker.delegate = self
    notePicker.dataSource = self
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    styleQualitySelectArea()
    styleVoicingSlectArea()
    styleInversionSelectArea()
    styleNoteSelectArea()
    
    styleGoButton()
//    styleTableView()
  }
  
  @objc private func dismissSelf() {
    dismiss(animated: true, completion: nil)
  }
  
  private func styleQualitySelectArea() {
    qualitySelectArea.frame = CGRect(x: areaMargin, y: viewHeight/2 - areaHeight*2 - areaHeight/2 - areaGap*2, width: viewWidth - areaMargin*2, height: areaHeight)
    qualitySelectArea.backgroundColor = Constants.buttonBlue
    qualitySelectArea.layer.cornerRadius = 10
    
    // adding a label
    qualitySelectArea.addSubview(qualityLabel)
    qualityLabel.frame = CGRect(x: 5, y: qualitySelectArea.frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight)
    
    qualityLabel.text = "Quality"
    qualityLabel.textAlignment = .center
    qualityLabel.font = UIFont(name: Constants.appBasicFont, size: labelHeight)
    qualityLabel.adjustsFontSizeToFitWidth = true
    qualityLabel.textColor = Constants.textColorWhite
    
    // adding a picker
    qualitySelectArea.addSubview(qualityPicker)
    qualityPicker.frame = CGRect(x: labelWidth+5, y: 0, width: viewWidth - areaMargin*2 - labelWidth - 5, height: areaHeight)
  }
  
  private func styleVoicingSlectArea() {
    voicingSelectArea.frame = CGRect(x: areaMargin, y: viewHeight/2 - areaHeight - areaHeight/2 - areaGap, width: viewWidth - areaMargin*2, height: areaHeight)
    voicingSelectArea.backgroundColor = Constants.buttonBlue
    voicingSelectArea.layer.cornerRadius = 10
    
    voicingSelectArea.addSubview(voicingLabel)
    voicingLabel.frame = CGRect(x: 5, y: voicingSelectArea.frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight)
    voicingLabel.text = "Voicing"
    voicingLabel.textAlignment = .center
    voicingLabel.font = UIFont(name: Constants.appBasicFont, size: labelHeight)
    voicingLabel.adjustsFontSizeToFitWidth = true
    voicingLabel.textColor = Constants.textColorWhite
    //    inversionLabel.backgroundColor = .yellow
    
    voicingSelectArea.addSubview(voicingPicker)
    voicingPicker.frame = CGRect(x: labelWidth+5, y: 0, width: viewWidth - areaMargin*2 - labelWidth - 5, height: areaHeight)
  }
  
  private func styleInversionSelectArea() {
    inversionSelectArea.frame = CGRect(x: areaMargin, y: viewHeight/2 - areaHeight/2, width: viewWidth - areaMargin*2, height: areaHeight)
    inversionSelectArea.backgroundColor = Constants.buttonBlue
    inversionSelectArea.layer.cornerRadius = 10
    
    inversionSelectArea.addSubview(inversionLabel)
    inversionLabel.frame = CGRect(x: 5, y: inversionSelectArea.frame.height/2 - labelHeight/2, width: labelWidth, height: labelHeight)
    inversionLabel.text = "Inversion"
    inversionLabel.textAlignment = .center
    inversionLabel.font = UIFont(name: Constants.appBasicFont, size: labelHeight)
    inversionLabel.adjustsFontSizeToFitWidth = true
    inversionLabel.textColor = Constants.textColorWhite
    //    inversionLabel.backgroundColor = .yellow
    
    inversionSelectArea.addSubview(inversionPicker)
    inversionPicker.frame = CGRect(x: labelWidth+5, y: 0, width: viewWidth - areaMargin*2 - labelWidth - 5, height: areaHeight)
  }
  
  private func styleNoteSelectArea() {
    noteSelectArea.frame = CGRect(x: areaMargin, y: viewHeight/2 + areaHeight/2 + areaGap, width: viewWidth - areaMargin*2, height: areaHeight)
    noteSelectArea.backgroundColor = Constants.buttonBlue
    noteSelectArea.layer.cornerRadius = 10
    
    noteSelectArea.addSubview(rootOrTopPicker)
    rootOrTopPicker.frame = CGRect(x: 5, y: 0, width: labelWidth, height: areaHeight)
    
    noteSelectArea.addSubview(notePicker)
    notePicker.frame = CGRect(x: labelWidth+5, y: 0, width: viewWidth - areaMargin*2 - labelWidth - 5, height: areaHeight)
    
  }
  
  private func styleGoButton() {
    let goButtonWidth = (viewWidth - areaMargin*2) / 2
    goButton.frame = CGRect(x: viewWidth/2 - goButtonWidth/2 , y: viewHeight/2 + areaHeight + areaHeight/2 + areaGap*2, width: goButtonWidth, height: areaHeight)
  }
  
  @objc private func onGoButtonTapped() {
    
  }
}

extension ViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch(pickerView.tag) {
      case 1:
        return JazzQuality.allCases.count
      case 2:
        return Voicing.allCases.count
      case 3:
        return Inversion.allCases.count
      case 4:
        return RootOrTop.allCases.count
      case 5:
        return Note.allCases.count
      default:
        return 0
    }
  }
}

extension ViewController: UIPickerViewDelegate {
  
  // assigning values from the pick results
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch(pickerView.tag) {
      case 1:
        quality = JazzQuality.allCases[row]
      case 2:
        voicing = Voicing.allCases[row]
      case 3:
        inversion = Inversion.allCases[row]
      case 4:
        rootOrTop = RootOrTop.allCases[row]
      case 5:
        note = Note.allCases[row]
      default:
        break
    }
  }
  
  // row height
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return areaHeight
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    switch(pickerView.tag) {
      case 1:
        let label = (view as? UILabel) ?? UILabel()
        label.text = JazzQuality.allCases[row].name
        label.font = UIFont(name: Constants.appBasicFont, size: 30)
        label.textAlignment = .center
        label.textColor = Constants.textColorWhite
        label.adjustsFontSizeToFitWidth = true
        return label
      case 2:
        let label = (view as? UILabel) ?? UILabel()
        label.text = Voicing.allCases[row].name
        label.font = UIFont(name: Constants.appBasicFont, size: 30)
        label.textAlignment = .center
        label.textColor = Constants.textColorWhite
        label.adjustsFontSizeToFitWidth = true
        return label
      case 3:
        let label = (view as? UILabel) ?? UILabel()
        label.text = Inversion.allCases[row].name
        label.font = UIFont(name: Constants.appBasicFont, size: 30)
        label.textAlignment = .center
        label.textColor = Constants.textColorWhite
        label.adjustsFontSizeToFitWidth = true
        return label
      case 4:
        let label = (view as? UILabel) ?? UILabel()
        label.text = RootOrTop.allCases[row].name
        label.font = UIFont(name: Constants.appBasicFont, size: 30)
        label.textAlignment = .center
        label.textColor = Constants.textColorWhite
        label.adjustsFontSizeToFitWidth = true
        return label
      case 5:
        let label = (view as? UILabel) ?? UILabel()
        label.text = Note.allCases[row].name
        label.font = UIFont(name: Constants.appBasicFont, size: 30)
        label.textAlignment = .center
        label.textColor = Constants.textColorWhite
        label.adjustsFontSizeToFitWidth = true
        return label
      default:
        let label = UILabel()
        return label
    }
  }
}

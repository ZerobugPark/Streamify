//
//  NameInputViewController.swift
//  Streamify
//
//  Created by 조다은 on 3/22/25.
//

import UIKit
import RxSwift
import SnapKit

final class NameInputViewController: BaseViewController<NameInputView, NameInputViewModel> {
    
    weak var coordinator: OnboardingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        let input = NameInputViewModel.Input(
            nameInput: mainView.nameTextField.rx.text.orEmpty.asObservable(),
            nextTap: mainView.nextButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidName
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isValidName
            .map { $0 ? UIColor.systemBlue : UIColor.lightGray }
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.navigateToNext
            .emit(onNext: { [weak self] name in
                self?.coordinator?.showGenreSelectionScreen(userName: name)
            })
            .disposed(by: disposeBag)
    }
}

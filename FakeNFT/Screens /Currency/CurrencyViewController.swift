import UIKit
import SnapKit

protocol CurrencyViewControllerProtocol: AnyObject, Loadable {
    func setup(with data: CurrenciesScreenModel)
}

final class CurrencyViewController: UIViewController {
    private let presenter: CurrencyPresenter
    private var currencies: [CurrencyModel] = []
    
    private let paymentPanel = CurrencyPaymentBottomPanel {
    }
    
    private let progressHud: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView(style: .medium)
        progress.hidesWhenStopped = true
        progress.color = UIColor.segmentActive
        
        return progress
    }()
    
    private let currencyCollectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.backgroundColor = UIColor.background
        collection.showsHorizontalScrollIndicator = false
        collection.allowsMultipleSelection = false
        
        collection.register(
            CurrencyCollectionCell.self,
            forCellWithReuseIdentifier: CurrencyCollectionCell.reuseIdentifier
        )
        
        return collection
    }()
    
    init(presenter: CurrencyPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         configure()
    }
    
    private func configure() {
        view.backgroundColor = UIColor.background
        // NSLocalizedString
        title = NSLocalizedString(
            "Выберите способ оплаты",
            comment: ""
        )
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont.bodyBold,
            .foregroundColor: UIColor.segmentActive
        ]
        
        currencyCollectionView.delegate = self
        currencyCollectionView.dataSource = self
        
         setupSubViews()
        presenter.setupData()
    }
    
    private func setupSubViews() {
        [currencyCollectionView,
         paymentPanel,
         progressHud].forEach {
            view.addSubview($0)
        }
        
        currencyCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        paymentPanel.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-152)
        }
        
        progressHud.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    
    private func getCell (
        _ collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> CurrencyCollectionCell? {
        guard let cell = collectionView.cellForItem(
            at: indexPath
        ) as? CurrencyCollectionCell else {return nil}
        
        return cell
    }
}

extension CurrencyViewController: CurrencyViewControllerProtocol {
    func showProgressHud() {
        progressHud.startAnimating()
    }
    
    func hideProgressHud() {
        progressHud.stopAnimating()
    }
    
    func setup(with data: CurrenciesScreenModel) {
        currencies = data.currencies
        currencyCollectionView.reloadData()
    }
}

extension CurrencyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? CurrencyCollectionCell else {return UICollectionViewCell() }
        
        cell.configure(with: currencies[indexPath.item])
        
        return cell
    }
}

extension CurrencyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = getCell(collectionView, at: indexPath) else {
            return
        }
        cell.select()
        paymentPanel.unlockButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = getCell(collectionView, at: indexPath) else {
            return
        }
        cell.deselect()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 20,
            left: 16,
            bottom: 0,
            right: 16
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = CGFloat(39)
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 46)
    }
}

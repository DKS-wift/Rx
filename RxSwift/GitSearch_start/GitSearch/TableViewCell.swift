//
//  TableViewCell.swift
//  GitSearch
//
//  Created by 박의서 on 2023/06/26.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private let label = UILabel().then{
        $0.textColor = .red
        $0.font = .systemFont(ofSize: 20)
    }
    private let uiButton = UIButton().then {
        $0.backgroundColor = .red
    }
    
    static let identifier = "TableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setLayout() {
        contentView.addSubviews(label)
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    
    public func dataBind(model: RepoModel) {
        label.text = model.fullName
    }
}

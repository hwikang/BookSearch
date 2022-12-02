//
//  BookView.swift
//  BookSearch
//
//  Created by 강휘 on 2022/12/01.
//

import Foundation
import UIKit

final class BookView: UIView {
    
    let scrollView = UIScrollView()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()
    
    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: DefaultLabel = {
       let label = DefaultLabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()
    let subTitleLabel: DefaultLabel = {
       let label = DefaultLabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        return label
    }()
    let publisherLabel: DefaultLabel = {
       let label = DefaultLabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }()
    let priceLabel = DefaultLabel()
    let authorLabel = DefaultLabel()
    let languageLabel = DefaultLabel()
    let yearLabel = DefaultLabel()
    let ratingLabel = DefaultLabel()
    let descLabel = DefaultLabel()
    let isbnLabel = DefaultLabel()
  
    let urlLabel = DefaultLabel()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setContent(book: Book) {
        bookImage.setImage(url: book.image)
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        publisherLabel.text = book.publisher
        priceLabel.text = book.price
        authorLabel.text = book.authors
        languageLabel.text = book.language
        if let year = book.year, let rating = book.rating,
          let isbn10 = book.isbn10 {
            yearLabel.text = "\(year) Year"
            ratingLabel.text = "Rating : \(rating) / 5"
            isbnLabel.text = "ISBN13: \(book.isbn13) ISBN10: \(isbn10)"
        }
        descLabel.text = book.desc
        urlLabel.text = book.url
       
    }
    
    func setPDF(pdf: [Dictionary<String, String>.Element]){
        
        
        if let test = pdf.first {
            let imageView = UIImageView()
            imageView.setImage(pdfUrl: test.value)
            stackView.addArrangedSubview(imageView)
            
            
        }
        
    }
    
    
    private func setUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [bookImage, titleLabel, subTitleLabel, publisherLabel, priceLabel,  authorLabel, languageLabel, yearLabel, ratingLabel, descLabel, isbnLabel, urlLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        setConstraint()
    }
    
    private func setConstraint() {
        [scrollView, stackView, bookImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            bookImage.heightAnchor.constraint(equalToConstant: Layout.bookImageHeight),
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CustomAnnotationView.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    override var annotation: (any MKAnnotation)? {
        didSet {
            setupViews()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        guard let annotation = annotation as? StopLocation else { return }
        
        self.frame = CGRect(x: 0, y: 0, width: 46, height: 24)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: "Bike"))
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.text = annotation.availableVehicles
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(imageView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.backgroundColor = .white
    }
}

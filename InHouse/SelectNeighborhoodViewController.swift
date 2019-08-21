//
//  SelectNeighborhoodViewController.swift
//  InHouse
//
//  Created by Kevin Johnson on 7/24/17.
//  Copyright © 2017 Kevin Johnson. All rights reserved.
//

import UIKit
import Mapbox

let postCodeNeighborhoodId: [String: [Int]] = ["E1" : [13],
                                               "EC1" : [13, 16],
                                               "W1" : [12, 14, 15],
                                               "WC1" : [16],
                                               "WC2" : [11]]

class SelectNeighborhoodViewController: UIViewController {
    
    // MARK: Variables
    
    var neighborhoodIds: [Int] = [Int]() {
        didSet {
            updateNYCMapLayer()
        }
    }
    var postCodes: [String] = [String]() {
        didSet {
            updateLondonMapLayer()
        }
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak private var mapView: MGLMapView!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "INHOUSE"
        
        mapView.delegate = self
        mapView.setCenter(currentCity.center, zoomLevel: currentCity.zoom, animated: false)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MixpanelHelper.screenView("SelectMap")
    }
    
    // MARK: Update Selection
    
    func updateNYCMapLayer() {
        let layer = mapView.style?.layer(withIdentifier: "New York") as? MGLFillStyleLayer
//        var sourceStops = [AnyHashable : MGLStyleValue<UIColor>]()
//        neighborhoodIds.forEach { id in
//            sourceStops[id] = MGLStyleValue<UIColor>.init(rawValue: .red)
//        }
//
//        if sourceStops.isEmpty {
//            //layer?.fillColor = MGLStyleValue<UIColor>.init(rawValue: Colors.GrayBlue) - way below is the way to reset it, set to nonexistant id, causes flashing/buggy issues other way
//            layer?.fillColor = MGLStyleValue(interpolationMode: .categorical, sourceStops: [555 : MGLStyleValue<UIColor>.init(rawValue: .red)], attributeName: "inhouse_id", options: [.defaultValue: MGLStyleValue<UIColor>.init(rawValue: Colors.MapBlue)])
//        } else {
//            layer?.fillColor = MGLStyleValue(interpolationMode: .categorical, sourceStops: sourceStops, attributeName: "inhouse_id", options: [.defaultValue: MGLStyleValue<UIColor>.init(rawValue: Colors.MapBlue)])
//        }
    }
    
    func updateLondonMapLayer() {
        let layer = mapView.style?.layer(withIdentifier: "London") as? MGLFillStyleLayer
//        var sourceStops = [AnyHashable : MGLStyleValue<UIColor>]()
//        postCodes.forEach { code in
//            sourceStops[code] = MGLStyleValue<UIColor>.init(rawValue: .red)
//        }
//
//        if sourceStops.isEmpty {
//            layer?.fillColor = MGLStyleValue(interpolationMode: .categorical, sourceStops: [555 : MGLStyleValue<UIColor>.init(rawValue: .red)], attributeName: "postcode", options: [.defaultValue: MGLStyleValue<UIColor>.init(rawValue: Colors.MapBlue)])
//        } else {
//            layer?.fillColor = MGLStyleValue(interpolationMode: .categorical, sourceStops: sourceStops, attributeName: "postcode", options: [.defaultValue: MGLStyleValue<UIColor>.init(rawValue: Colors.MapBlue)])
//        }
    }
    
    // MARK: Hit Test
    
    @IBAction func handleTap(_ gesture: UITapGestureRecognizer) {
        let spot = gesture.location(in: mapView)
        let features = mapView.visibleFeatures(at: spot, styleLayerIdentifiers: [currentCity.name])
        guard let feature = features.first else { return }
        
        switch currentCity.code {
        case 1:
            if let neighborhoodId = feature.attribute(forKey: "inhouse_id") as? Int {
                if let index = neighborhoodIds.index(where: { $0 == neighborhoodId }) {
                    neighborhoodIds.remove(at: index)
                } else {
                    neighborhoodIds.append(neighborhoodId)
                }
            }
        case 2:
            if let postcode = feature.attribute(forKey: "postcode") as? String {
                if let index = postCodes.index(where: { $0 == postcode }) {
                    postCodes.remove(at: index)
                } else {
                    postCodes.append(postcode)
                }
            }
        default:
            break
        }
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MixpanelHelper.buttonTap("SelectMapNext")
        if segue.identifier == "Next" {
            guard let bookBy = segue.destination as? BookByMapViewController else { return }
            if currentCity.code == 2 {
                postCodes.forEach { postCode in
                    if let ids = postCodeNeighborhoodId[postCode] {
                        neighborhoodIds = neighborhoodIds + ids
                    }
                }
            }
            Printer.print("Neighborhood ids: \(neighborhoodIds)")
            bookBy.selectedNeighborhoodIds = Array(Set(neighborhoodIds))
        }
    }
}

extension SelectNeighborhoodViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        updateNYCMapLayer()
        updateLondonMapLayer()
    }
}

// MARK: Class Func

extension SelectNeighborhoodViewController {
    class func identifier()-> String {
        return "SelectNeighborhoodViewControllerIdentifier"
    }
}

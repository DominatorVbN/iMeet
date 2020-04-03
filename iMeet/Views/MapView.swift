//
//  MapView.swift
//  MapKitInSwiftUI
//
//  Created by dominator on 19/02/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCordinate: CLLocationCoordinate2D
    var annotations: [UserAnnotation]
    class Coordinator: NSObject, MKMapViewDelegate{
        var parent: MapView
        init(_ parent: MapView){
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.parent.centerCordinate = mapView.centerCoordinate
        }


        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = NSStringFromClass(UserAnnotation.self)
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
            return annotationView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(UserAnnotation.self))
        mapView.setCamera(MKMapCamera(lookingAtCenter: centerCordinate, fromDistance: CLLocationDistance(1000), pitch: 0, heading: 0), animated: false)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if annotations.count != uiView.annotations.count{
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
        uiView.setCamera(MKMapCamera(lookingAtCenter: centerCordinate, fromDistance: CLLocationDistance(1000), pitch: 0, heading: 0), animated: false)

    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCordinate: .constant(UserAnnotation.example.coordinate), annotations: [UserAnnotation.example])
            .padding()
            .cornerRadius(10)
            .shadow(radius: 8)
    }
}
extension UserAnnotation {
    static var example: UserAnnotation {
        let annotation = UserAnnotation(coordinate: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13))
        annotation.title = "Amit"
        annotation.image = #imageLiteral(resourceName: "amit")
        return annotation
    }
}

//
//  ClusterManager.swift
//  Common
//
//  Created by 전소영 on 2025/02/25.
//

import Foundation
import MapKit

@Observable public final class ClusterManager {
    private let quadTree = QuadTree(boundingBox: BoundingBox.init(mapRect: MKMapRect.world))
    public var clusterAnnotations: [SiggiAnnotation] = []

    public init() { }

    public func addAnnotations(annotations: [SiggiAnnotation]) {
        add(annotations: annotations)
    }

    public func clusterAnnotations(visibleMapRect: MKMapRect, zoomScale: Double) {
        cluster(visibleMapRect: visibleMapRect, zoomScale: zoomScale)
    }

    private func add(annotations: [SiggiAnnotation]) {
        quadTree.reset()

        for annotation in annotations {
            quadTree.insert(annotation: annotation)
        }
    }

    private func cluster(visibleMapRect: MKMapRect, zoomScale: Double) {
        guard !zoomScale.isInfinite else {
            return
        }

        clusterAnnotations = []
        let minX = visibleMapRect.minX
        let maxX = visibleMapRect.minX + visibleMapRect.width
        let minY = visibleMapRect.minY
        let maxY = visibleMapRect.minY + visibleMapRect.height
        let cellSizePoints = Double(visibleMapRect.size.width / Double(calculateDivisionCount(for: MKZoomScale(zoomScale))))

        var yCoordinate = minY

        while yCoordinate < maxY {
            var xCoordinate = minX

            while xCoordinate < maxX {
                let area = BoundingBox.init(mapRect: MKMapRect(x: xCoordinate, y: yCoordinate, width: cellSizePoints, height: cellSizePoints))

                Task {
                    do {
                        let annotations = try await self.quadTree.findAnnotations(searchInBoundingBox: area)
                        if annotations.count > 1 {
                            var totalX = 0.0
                            var totalY = 0.0
                            let totalAnnotationsCount = annotations.count
                            var titlesSet: Set<String> = []
                            for annotation in annotations {
                                totalX += annotation.coordinate.latitude
                                totalY += annotation.coordinate.longitude
                                if let title = annotation.title {
                                    titlesSet.insert(title)
                                }
                            }

                            let averageCoordinate = CLLocationCoordinate2D(latitude: totalX / Double(totalAnnotationsCount),
                                                                           longitude: totalY / Double(totalAnnotationsCount))
                            let annotationTitle = "\(totalAnnotationsCount)"
                            let annotationTitles = Array(titlesSet)

                            DispatchQueue.main.async {
                                self.clusterAnnotations.append(
                                    SiggiAnnotation(coordinate: averageCoordinate,
                                                     title: annotationTitle,
                                                     titles: annotationTitles)
                                )
                            }
                        } else if annotations.count == 1 {
                            if let annotation = annotations.first, let title = annotation.title {
                                DispatchQueue.main.async {
                                    self.clusterAnnotations.append(
                                        SiggiAnnotation(coordinate: annotation.coordinate,
                                                         title: "1",
                                                         titles: [title])
                                    )
                                }
                            }
                        }
                    }
                    catch {
                        print("find annotaions error: \(error.localizedDescription)")
                    }
                }
                xCoordinate += cellSizePoints
            }
            yCoordinate += cellSizePoints
        }
    }

    private func calculateZoomLevel(for scale: MKZoomScale) -> Int {
        let totalTilesAtMaxZoom = MKMapSize.world.width / 256.0
        let zoomLevelAtMaxZoom = CGFloat(log2(totalTilesAtMaxZoom))

        return Int(max(0, zoomLevelAtMaxZoom + CGFloat(floor(log2f(Float(scale)) + 0.5))))
    }

    private func calculateDivisionCount(for zoomScale: MKZoomScale) -> Int {
        let zoomLevel = calculateZoomLevel(for: zoomScale)

        switch zoomLevel {
        case 0...4:
            return 32
        case 5...8:
            return 16
        case 9...16:
            return 8
        case 17...20:
            return 4
        default:
            return 10
        }
    }
}

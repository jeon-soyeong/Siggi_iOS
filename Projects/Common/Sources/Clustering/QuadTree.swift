//
//  QuadTree.swift
//  Common
//
//  Created by 전소영 on 2025/02/25.
//

import Foundation
import MapKit

final class QuadTree {
    static let capacity = 8
    var boundingBox: BoundingBox
    private var annotations = [ClusterAnnotation]()
    private var isDivided = false

    private var northWest: QuadTree?
    private var northEast: QuadTree?
    private var southWest: QuadTree?
    private var southEast: QuadTree?

    init(boundingBox: BoundingBox) {
        self.boundingBox = boundingBox
    }

    deinit {
        annotations.removeAll()
        isDivided = false

        northWest = nil
        northEast = nil
        southWest = nil
        southEast = nil
    }

    func reset() {
        annotations.removeAll()
        isDivided = false

        northWest = nil
        northEast = nil
        southWest = nil
        southEast = nil
    }

    func insert(annotation: ClusterAnnotation) {
        guard self.boundingBox.contains(coordinate: annotation.coordinate) else {
            return
        }

        if annotations.count < QuadTree.capacity {
            annotations.append(annotation)
        } else {
            if northWest == nil {
                self.subdivide()
            }
            northWest?.insert(annotation: annotation)
            northEast?.insert(annotation: annotation)
            southWest?.insert(annotation: annotation)
            southEast?.insert(annotation: annotation)
        }
    }

    func findAnnotations(searchInBoundingBox: BoundingBox) async throws -> [ClusterAnnotation] {
        guard searchInBoundingBox.intersects(boundingBox: boundingBox) else {
            return []
        }

        var totalAnnotations: [ClusterAnnotation] = []
        for annotation in annotations {
            if searchInBoundingBox.contains(coordinate: annotation.coordinate) {
                totalAnnotations.append(annotation)
            }
        }

        if isDivided {
            async let northEastResults = northEast?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? []
            async let northWestResults = northWest?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? []
            async let southEastResults = southEast?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? []
            async let southWestResults = southWest?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? []
            do {
                totalAnnotations.append(contentsOf: try await northEastResults)
                totalAnnotations.append(contentsOf: try await northWestResults)
                totalAnnotations.append(contentsOf: try await southEastResults)
                totalAnnotations.append(contentsOf: try await southWestResults)
            } catch {
                throw error
            }
        }

        return totalAnnotations
    }

    private func subdivide() {
        isDivided = true
        let midLongitude = (boundingBox.minLongitude + boundingBox.maxLongitude) / 2.0
        let midLatitude = (boundingBox.minLatitude + boundingBox.maxLatitude) / 2.0

        northWest = QuadTree(boundingBox: BoundingBox(minLatitude: midLatitude, maxLatitude: boundingBox.maxLatitude, minLongitude: boundingBox.minLongitude, maxLongitude: midLongitude))
        northEast = QuadTree(boundingBox: BoundingBox(minLatitude: midLatitude, maxLatitude: boundingBox.maxLatitude, minLongitude: midLongitude, maxLongitude: boundingBox.maxLongitude))
        southWest = QuadTree(boundingBox: BoundingBox(minLatitude: boundingBox.minLatitude, maxLatitude: midLatitude, minLongitude: boundingBox.minLongitude, maxLongitude: midLongitude))
        southEast = QuadTree(boundingBox: BoundingBox(minLatitude: boundingBox.minLatitude, maxLatitude: midLatitude, minLongitude: midLongitude, maxLongitude: boundingBox.maxLongitude))
    }
}

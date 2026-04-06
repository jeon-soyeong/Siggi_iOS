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

    @discardableResult
    func insert(annotation: ClusterAnnotation) -> Bool {
        guard self.boundingBox.contains(coordinate: annotation.coordinate) else {
            return false
        }

        // 이미 분할된 노드(부모 노드)라면, 자식에게 넘김
        if isDivided {
            return insertIntoChildren(annotation: annotation)
        }

        // 아직 자리가 남았다면 부모가 가짐
        if annotations.count < QuadTree.capacity {
            annotations.append(annotation)
            return true
        }

        // [무한 재귀 방어] 가로 또는 세로 길이가 한계치보다 작아지면 분할 중지
        // (완전히 동일하거나 극도로 가까운 좌표 밀집 시 Stack Overflow 방지)
        let width = boundingBox.maxLongitude - boundingBox.minLongitude
        let height = boundingBox.maxLatitude - boundingBox.minLatitude

        if width < 0.00001 || height < 0.00001 {
            annotations.append(annotation)
            return true
        }

        // 기존 데이터를 미리 분리
        let oldAnnotations = annotations
        annotations.removeAll()

        subdivide()

        // 분리해둔 기존 데이터들을 자식들에게 재분배
        for oldAnnotation in oldAnnotations {
            insertIntoChildren(annotation: oldAnnotation)
        }

        // 이번에 새로 들어온 데이터도 자식에게 전달
        return insertIntoChildren(annotation: annotation)
    }

    func findAnnotations(searchInBoundingBox: BoundingBox) -> [ClusterAnnotation] {
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
            totalAnnotations.append(contentsOf: northEast?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? [])
            totalAnnotations.append(contentsOf: northWest?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? [])
            totalAnnotations.append(contentsOf: southEast?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? [])
            totalAnnotations.append(contentsOf: southWest?.findAnnotations(searchInBoundingBox: searchInBoundingBox) ?? [])
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

    // 자식 노드들에게 순서대로 삽입을 시도하는 헬퍼 메서드
    @discardableResult
    private func insertIntoChildren(annotation: ClusterAnnotation) -> Bool {
        if northWest?.insert(annotation: annotation) == true { return true }
        if northEast?.insert(annotation: annotation) == true { return true }
        if southWest?.insert(annotation: annotation) == true { return true }
        if southEast?.insert(annotation: annotation) == true { return true }
        return false
    }
}

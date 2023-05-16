//
//  ContentStorage.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/15.
//

import Foundation
import CoreData

struct ContentStorage {
    typealias EntityType = ContentEntity
    private let entityName = "ContentEntity"
    
    func downloadWith(model: Content) throws {
        let context = CoreDataStorage.shared.context
        
        let filter = filteredRequestWith(id: model.id)
        let sameContents = try context.fetch(filter).compactMap { $0 as? EntityType }
        
        if sameContents.isEmpty {
            let entity = toEntity(model, context: context)
            
            try context.save()
        } else {
            print("이미 다운로드한 Content")
        }
    }
    
    func fetchContentsFromCoreData() throws -> [Content] {
        let context = CoreDataStorage.shared.context
        
        let request: NSFetchRequest<EntityType> = EntityType.fetchRequest()
        
        let contentEntities = try context.fetch(request)
        return contentEntities.compactMap { toModel($0) }
    }
    
    func delete(model: Content) throws {
        let context = CoreDataStorage.shared.context
        
        let filter = filteredRequestWith(id: model.id)
        let deleteItems = try context.fetch(filter).compactMap { $0 as? EntityType }
        
        deleteItems.forEach { context.delete($0) }
        
        try context.save()
    }
    
    private func filteredRequestWith(id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        return fetchRequest
    }
}

extension ContentStorage {
    private func toEntity(_ model: Content, context: NSManagedObjectContext) -> EntityType {
        let item = EntityType(context: context)
        
        item.id = Int64(model.id)
        item.mediaType = model.mediaType.rawValue
        item.adult = model.adult ?? false
        item.title = model.title ?? "Unknown"
        item.originalTitle = model.originalTitle ?? "Unknown"
        item.overview = model.overview ?? "None"
        item.posterPath = model.posterPath ?? ""
        item.popularity = model.popularity ?? 0.0
        item.releaseDate = model.releaseDate ?? ""
        item.voteAverage = model.voteAverage ?? 0.0
        item.voteCount = Int32(model.voteCount ?? 0)
        
        return item
    }
    
    private func toModel(_ entity: EntityType) -> Content? {
        guard let mediaType = entity.mediaType else {
            return nil
        }
        
        return .init(id: Int(entity.id),
                     mediaType: mediaType == "movie" ? .movie : .tv,
                     adult: entity.adult,
                     title: entity.title,
                     originalTitle: entity.originalTitle,
                     overview: entity.overview,
                     posterPath: entity.posterPath,
                     popularity: entity.popularity,
                     releaseDate: entity.releaseDate,
                     voteAverage: entity.voteAverage,
                     voteCount: Int(entity.voteCount))
    }
}

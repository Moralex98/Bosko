//
//  GameData.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 29/03/25.
//

import Foundation
import CoreData

/*
class GameData: ObservableObject {
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var levelOneStars: Int = 0
    @Published var levelTwoStars: Int = 0

    var context: NSManagedObjectContext
    private var progress: PlayerProgress?

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        loadProgress()
    }

    func loadProgress() {
        let request: NSFetchRequest<PlayerProgress> = PlayerProgress.fetchRequest()
        if let result = try? context.fetch(request), let saved = result.first {
            self.progress = saved
            self.score = Int(saved.score)
            self.lives = Int(saved.lives)
            self.levelOneStars = Int(saved.levelOneStars)
            self.levelTwoStars = Int(saved.levelTwoStars)
        } else {
            let newProgress = PlayerProgress(context: context)
            newProgress.score = 0
            newProgress.lives = 3
            newProgress.levelOneStars = 0
            newProgress.levelTwoStars = 0
            self.progress = newProgress
            saveProgress()
        }
    }

    func saveProgress() {
        guard let progress = progress else { return }
        progress.score = Int64(score)
        progress.lives = Int64(lives)
        progress.levelOneStars = Int64(levelOneStars)
        progress.levelTwoStars = Int64(levelTwoStars)
        try? context.save()
    }

    func resetProgress() {
        self.score = 0
        self.lives = 3
        self.levelOneStars = 0
        self.levelTwoStars = 0
        saveProgress()
    }
}
*/

class GameData: ObservableObject {
    @Published var score: Int = 0
    @Published var lives: Int = 5
}

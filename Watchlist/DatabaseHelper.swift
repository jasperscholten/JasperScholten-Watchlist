//
//  DatabaseHelper.swift
//  Watchlist
//
//  Created by Jasper Scholten on 27-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    private let movies = Table("movies")
    
    private let id = Expression<Int64>("id")
    private let title = Expression<String?>("title")
    private let year = Expression<String?>("year")
    private let rated = Expression<String?>("rated")
    private let released = Expression<String?>("released")
    private let runtime = Expression<String?>("runtime")
    private let genre = Expression<String?>("genre")
    private let director = Expression<String?>("director")
    private let writer = Expression<String?>("writer")
    private let actors = Expression<String?>("actors")
    private let plot = Expression<String?>("plot")
    private let language = Expression<String?>("language")
    private let country = Expression<String?>("country")
    private let awards = Expression<String?>("awards")
    private let poster = Expression<String?>("poster")
    private let metascore = Expression<String?>("metascore")
    private let imdbrating = Expression<String?>("imdbrating")
    private let imdbvotes = Expression<String?>("imdbvotes")
    private let imdbid = Expression<String?>("imdbid")
    private let type = Expression<String?>("type")
    // private let response = Expression<Bool>("response")
    
    private var db: Connection?
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
            
        } catch {
            throw error
        }
        
    }
    
    private func createTable() throws {
        
        do {
            // Delete old table after adding new column - be careful!
            // try dropTable()
            
            try db!.run(movies.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                t.column(year)
                t.column(rated)
                t.column(released)
                t.column(runtime)
                t.column(genre)
                t.column(director)
                t.column(writer)
                t.column(actors)
                t.column(plot)
                t.column(language)
                t.column(country)
                t.column(awards)
                t.column(poster)
                t.column(metascore)
                t.column(imdbrating)
                t.column(imdbvotes)
                t.column(imdbid)
                t.column(type)
                // t.column(response)
            })
            
        } catch {
            throw error
        }
    }
    
    private func dropTable() throws {
        do {
            try db!.run(movies.drop(ifExists: true))
        } catch {
            print(error)
        }
    }
    
    func countRows() throws -> Int {
        do {
            return try db!.scalar(movies.count)
        } catch {
            throw error
        }
    }
    
    func populate(index: Int) throws -> [String: String?] {
        
        var result: [String: String?]
        result = [:]
        var count = 0
        
        do {
            for list in try db!.prepare(movies) {
                if count == index {
                    // return array
                    result["title"] = "\(list[title]!)"
                    result["year"] = "\(list[year]!)"
                    result["poster"] = "\(list[poster]!)"
                    result["imdbid"] = "\(list[imdbid]!)"
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        return result
    }
    
    func add(title: String, year: String, rated: String, released: String, runtime: String, genre: String, director: String, writer: String, actors: String, plot: String, language: String, country: String, awards: String, poster: String, metascore: String, imdbrating: String, imdbvotes: String, imdbid: String, type: String) throws {
        
        let insert = movies.insert(self.title <- title, self.year <- year, self.rated <- rated, self.released <- released, self.runtime <- runtime, self.genre <- genre, self.director <- director, self.writer <- writer, self.actors <- actors, self.plot <- plot, self.language <- language, self.country <- country, self.awards <- awards, self.poster <- poster, self.metascore <- metascore, self.imdbrating <- imdbrating, self.imdbvotes <- imdbvotes, self.imdbid <- imdbid, self.type <- type)
        
        do {
            let rowId = try db!.run(insert)
            print(rowId)
        } catch {
            throw error
        }
        
    }
    
    func delete(index: Int) throws {
        
        var rowID: Int64
        rowID = 0
        var count = 0
        
        do {
            for row in try db!.prepare(movies.select(id)) {
                if count == index {
                    rowID = row[id]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let item = movies.filter(id == rowID)
        
        do {
            let number = try db!.run(item.delete())
            print("\(number) row deleted")
        } catch {
            print(error)
        }
    }
    
}

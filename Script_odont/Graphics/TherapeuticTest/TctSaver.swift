//
//  TctSaver.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

fileprivate func string_(for session: TctSession) -> String
{
    // date
    var result = "\(session.date.timeIntervalSinceReferenceDate)\n"
    
    // participant name
    result += "\(session.participant.firstName)\n"
    
    // participant category
    result += "\(session.participant.category.name)\n"
    
    // elapsed time
    result += "\(session.elapsedTime)\n"
    
    let addComments = session.comments.count > 0
    
    // the answers and comments
    for (i, answer) in session.answers.enumerated()
    {
        result += "\t".join(answer)
        
        // comment
        if addComments && i < session.comments.count
        {
            result += "\ncomment:" + session.comments[i]
        }
        
        if i < session.answers.count - 1
        {
            result += "\n"
        }
    }
    
    return result
}

fileprivate func session_(for string: String, sequenceIndex: Int) -> TctSession
{
    let lines = string.split(separator: Character("\n"))
    guard lines.count > 4 else
    {
        return TctSession(sequenceIndex: -1, date: Date(), participant: TctParticipant(firstName: "", category: .student4), answers: [])
    }
    let dateSeconds = Double(lines[0]) ?? 0.0
    let date = Date(timeIntervalSinceReferenceDate: dateSeconds)
    
    let participantFirstName = String(lines[1])
    let participantCategoryName = String(lines[2])
    var elapsedTimeString = String(lines[3])
    
    // TEMP : problème de date dans le format à corriger
    let linesToSkip: Int
    if elapsedTimeString.contains(String("\t"))
    {
        linesToSkip = 3
        elapsedTimeString = "120.000000"
    }
    else
    {
        linesToSkip = 4
    }
    
    guard let participantCategory = ParticipantCategory.category(for: participantCategoryName),
        let elapsedTime = Double(elapsedTimeString) else
    {
        return TctSession(sequenceIndex: -1, date: Date(), participant: TctParticipant(firstName: participantFirstName, category: .student4), answers: [])
    }
    
    var answers = [[Int]]()
    var comments = [String]()
    for i in linesToSkip..<lines.count
    {
        if lines[i].starts(with: "comment:")
        {
            let comment = lines[i].replacingOccurrences(of: "comment:", with: "")
            comments.append(comment)
            continue
        }
        
        let itemAnswers = lines[i].split(separator: Character("\t"))
        
        answers.append(itemAnswers.map { Int(String($0)) ?? 0 })
    }
    
    if comments.count > 0
    {
        return TctSession(sequenceIndex: sequenceIndex, date: date, participant: TctParticipant(firstName: participantFirstName, category: participantCategory), answers: answers, elapsedTime: elapsedTime, comments: comments)
    }
    return TctSession(sequenceIndex: sequenceIndex, date: date, participant: TctParticipant(firstName: participantFirstName, category: participantCategory), answers: answers, elapsedTime: elapsedTime)
}

/// The TCT session saver.
class TctSaver
{
    // -------------------------------------------------------------------------
    // MARK: - SAVE
    // -------------------------------------------------------------------------
    public class func save(session: TctSession, sequenceIndex: Int)
    {
        let sequenceUrl = TctSaver.url(forSequenceIndex: sequenceIndex)
        // create folder if needed
        if !FileManager.default.fileExists(atPath: sequenceUrl.path)
        {
           do
           {
                try FileManager.default.createDirectory(at: sequenceUrl, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                return
            }
        }
        
        let newFileName = "\(TctSaver.getNewSessionId_(forSequenceIndex: sequenceIndex)).tct"
        let newFileStringContent = string_(for: session)
        let newFileUrl = sequenceUrl.appendingPathComponent(newFileName)
        
        guard let newFileContent = newFileStringContent.data(using: String.Encoding.utf8) else
        {
            return
        }
        
        FileManager.default.createFile(atPath: newFileUrl.path, contents: newFileContent, attributes: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - GET
    // -------------------------------------------------------------------------
    /// - returns: The list of TCT sessions.
    public class func getAllSession() -> [TctSession]
    {
        var result = [TctSession]()
        for i in 0..<TctQuestion.sequences.count
        {
            result.append(contentsOf: getSessions(forSequenceIndex: i))
        }
        return result
    }
    
    /// - returns: The list of TCT sessions in the sequence.
    public class func getSessions(forSequenceIndex sequenceIndex: Int) -> [TctSession]
    {
        let sequenceUrl = url(forSequenceIndex: sequenceIndex)
        let sessionFiles: [String]
        do
        {
            sessionFiles = try FileManager.default.contentsOfDirectory(atPath: sequenceUrl.path)
        }
        catch
        {
            return []
        }
        
        var result = [TctSession]()
        
        for sessionFile in sessionFiles
        {
            let currentFileUrl = sequenceUrl.appendingPathComponent(sessionFile)
            
            guard let sessionData = FileManager.default.contents(atPath: currentFileUrl.path),
                let sessionContent = String(data: sessionData, encoding: .utf8)
                else
            {
                continue
            }
            
            var newSession = session_(for: sessionContent, sequenceIndex: sequenceIndex)
            if let sessionId = Int(sessionFile.replacingOccurrences(of: ".tct", with: ""))
            {
                newSession.id = sessionId
            }
            result.append(newSession)
        }
        
        return result
    }
    
    /// - returns: The TCT session with the `id` and `sequenceIndex` if found.
    public class func getSession(for sequenceIndex: Int, id: Int) -> TctSession?
    {
        let sequenceUrl = url(forSequenceIndex: sequenceIndex)
        let sessionFiles: [String]
        do
        {
            sessionFiles = try FileManager.default.contentsOfDirectory(atPath: sequenceUrl.path)
        }
        catch
        {
            return nil
        }
        
        for sessionFile in sessionFiles
        {
            if sessionFile != "\(id).tct"
            {
                continue
            }
            
            let currentFileUrl = sequenceUrl.appendingPathComponent(sessionFile)
            
            guard let sessionData = FileManager.default.contents(atPath: currentFileUrl.path),
                let sessionContent = String(data: sessionData, encoding: .utf8)
                else
            {
                continue
            }
            
            var newSession = session_(for: sessionContent, sequenceIndex: sequenceIndex)
            if let sessionId = Int(sessionFile.replacingOccurrences(of: ".tct", with: ""))
            {
                newSession.id = sessionId
            }
            return newSession
        }
        
        return nil
    }
    
    /// - returns: The number of sessions in the sequence.
    public class func getSessionsCount(forSequenceIndex sequenceIndex: Int) -> Int
    {
        do
        {
            let sequenceUrl = url(forSequenceIndex: sequenceIndex)
            let sessionFiles = try FileManager.default.contentsOfDirectory(atPath: sequenceUrl.path)
            return sessionFiles.count
        }
        catch
        {
            return 0
        }
    }
    
    /// - returns: A list of correct answers for the sequence.
    public class func getCorrection(forSequenceIndex sequenceIndex: Int, id: Int) -> [[Int]]?
    {
        guard let session = getSession(for: sequenceIndex, id: id) else
        {
            return nil
        }
        
        // TEMP : return random values
        return session.answers.map {
            (answers: [Int]) -> [Int] in
            
            return answers.map {
                (answer: Int) -> Int in
                
                if Constants.random(min: 1, max: 10) < 3
                {
                    return (answer + Constants.random(min: 1, max: 3)) % 4
                }
                return answer
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DELETE
    // -------------------------------------------------------------------------
    /// Delete all sessions.
    public class func deleteAll()
    {
        let sessionFolders: [String]
        do
        {
            sessionFolders = try FileManager.default.contentsOfDirectory(atPath: therapeuticChoicePath_.path)
        }
        catch
        {
            return
        }
        
        for sessionFolder in sessionFolders
        {
            let folderPath = therapeuticChoicePath_.appendingPathComponent(sessionFolder).path
            try! FileManager.default.removeItem(atPath: folderPath)
        }
    }
    
    /// Delete a specific session.
    public class func delete(for sequenceIndex: Int, id: Int)
    {
        let sequenceUrl = url(forSequenceIndex: sequenceIndex)
        let sessionUrl = sequenceUrl.appendingPathComponent("\(id).tct")
        
        guard FileManager.default.fileExists(atPath: sessionUrl.path) else
        {
            return
        }
        
        do
        {
            // remove the session
            try FileManager.default.removeItem(at: sessionUrl)
            
            // update otther sessions indexes
            let sessionNumbers = try FileManager.default.contentsOfDirectory(atPath: sequenceUrl.path).map {
                name -> Int in
                
                return Int(name.replacingOccurrences(of: ".tct", with: "")) ?? 0
                }.filter {
                $0 > id
            }.sorted()
            
            for sessionNumber in sessionNumbers
            {
                let newSessionFile = sequenceUrl.appendingPathComponent("\(sessionNumber - 1).tct").path
                let previousSessionFile = sequenceUrl.appendingPathComponent("\(sessionNumber).tct").path
                
                try FileManager.default.moveItem(atPath: previousSessionFile, toPath: newSessionFile)
            }
        }
        catch
        {
            return
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UTILS
    // -------------------------------------------------------------------------
    fileprivate static let documentPath_: URL = {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    fileprivate static let therapeuticChoicePath_: URL = TctSaver.documentPath_.appendingPathComponent("TherapeuticChoiceTraining")
    
    fileprivate static func url(forSequenceIndex sequenceIndex: Int) -> URL
    {
        return therapeuticChoicePath_.appendingPathComponent("\(sequenceIndex + 1)")
    }
    
    fileprivate static func getNewSessionId_(forSequenceIndex sequenceIndex: Int) -> Int
    {
        do
        {
            let sequenceUrl = url(forSequenceIndex: sequenceIndex)
            return try FileManager.default.contentsOfDirectory(atPath: sequenceUrl.path).count + 1
        }
        catch
        {
            print(error)
            return -1
        }
    }
}

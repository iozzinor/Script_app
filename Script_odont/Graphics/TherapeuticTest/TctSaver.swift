//
//  TctSaver.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class TctSaver
{
    public class func save(session: TctSession)
    {
        // create folder if needed
        if !FileManager.default.fileExists(atPath: therapeuticChoicePath_.path)
        {
           do
           {
                try FileManager.default.createDirectory(at: therapeuticChoicePath_, withIntermediateDirectories: false, attributes: nil)
            }
            catch
            {
                return
            }
        }
        
        let newFileName = "\(TctSaver.newSessionId_).tct"
        let newFileStringContent = string(for: session)
        let newFileUrl = therapeuticChoicePath_.appendingPathComponent(newFileName)
        
        guard let newFileContent = newFileStringContent.data(using: String.Encoding.utf8) else
        {
            return
        }
        
        FileManager.default.createFile(atPath: newFileUrl.path, contents: newFileContent, attributes: nil)
    }
    
    public class func getSessions() -> [TctSession]
    {
        let sessionFiles: [String]
        do
        {
            sessionFiles = try FileManager.default.contentsOfDirectory(atPath: therapeuticChoicePath_.path)
        }
        catch
        {
            return []
        }
        
        var result = [TctSession]()
        
        for sessionFile in sessionFiles
        {
            let currentFileUrl = therapeuticChoicePath_.appendingPathComponent(sessionFile)
            
            guard let sessionData = FileManager.default.contents(atPath: currentFileUrl.path),
                let sessionContent = String(data: sessionData, encoding: .utf8)
                else
            {
                continue
            }
            
            result.append(TctSaver.session(for: sessionContent))
        }
        
        return result
    }
    
    public class func getSessionsCount() -> Int
    {
        do
        {
            let sessionFiles = try FileManager.default.contentsOfDirectory(atPath: therapeuticChoicePath_.path)
            return sessionFiles.count
        }
        catch
        {
            return 0
        }
    }
    
    public class func deleteAll()
    {
        let sessionFiles: [String]
        do
        {
            sessionFiles = try FileManager.default.contentsOfDirectory(atPath: therapeuticChoicePath_.path)
        }
        catch
        {
            return
        }
        
        for sessionFile in sessionFiles
        {
            let filePath = therapeuticChoicePath_.appendingPathComponent(sessionFile).path
            try! FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    fileprivate static let documentPath_: URL = {
       return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    fileprivate static let therapeuticChoicePath_: URL = TctSaver.documentPath_.appendingPathComponent("TherapeuticChoiceTraining")
    
    fileprivate static var newSessionId_: Int {
        do
        {
            return try FileManager.default.contentsOfDirectory(atPath: therapeuticChoicePath_.path).count + 1
        }
        catch
        {
            print(error)
            return -1
        }
    }
    
    fileprivate static func string(for session: TctSession) -> String
    {
        // date
        var result = "\(session.date.timeIntervalSinceReferenceDate)\n"
        
        // participant name
        result += "\(session.participant.firstName)\n"
        
        // participant category
        result += "\(session.participant.category.name)\n"
        
        // the answers
        for (i, answer) in session.answers.enumerated()
        {
            result += "\t".join(answer)
            if i < session.answers.count - 1
            {
                result += "\n"
            }
        }
        
        return result
    }
    
    fileprivate static func session(for string: String) -> TctSession
    {
        let lines = string.split(separator: Character("\n"))
        guard lines.count > 3 else
        {
            return TctSession(date: Date(), participant: TctParticipant(firstName: "", category: .student4), answers: [])
        }
        let dateSeconds = Double(lines[0]) ?? 0.0
        let date = Date(timeIntervalSinceReferenceDate: dateSeconds)
        
        let participantFirstName = String(lines[1])
        let participantCategoryName = String(lines[2])
        
        guard let participantCategory = ParticipantCategory.category(for: participantCategoryName) else
        {
            return TctSession(date: Date(), participant: TctParticipant(firstName: participantFirstName, category: .student4), answers: [])
        }
        
        var answers = [[Int]]()
        for i in 3..<lines.count
        {
            let itemAnswers = lines[i].split(separator: Character("\t"))
            
            answers.append(itemAnswers.map { Int(String($0)) ?? 0 })
        }
        
        return TctSession(date: date, participant: TctParticipant(firstName: participantFirstName, category: participantCategory), answers: answers)
    }
}

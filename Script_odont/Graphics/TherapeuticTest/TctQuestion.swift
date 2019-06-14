//
//  TctQuestion.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

fileprivate func getQuestionWordings_() -> [String]
{
    return [
        """
Une patiente de 23 ans se présente avec une carie sous un amalgame de la dent numéro 35. Après avoir
déposer la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Un patient de 31 ans se présente avec une carie importante sur la dent numéro 16 ayant nécessité la
réalisation d’un traitement endodontique. Après avoir déposer la reconstitution pré endodontique, vous
souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 44 ans se présente avec une lésion carieuse sur la dent 16. Après avoir effectué l’éviction
carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 20 ans se présente avec une carie sous un ancien composite de la dent numéro 16. Après
avoir déposer la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire
de ce patient.
""",
        """
Un patient de 35 ans se présente avec une fracture de la cuspide vestibulaire sur de la dent numéro 15.
Vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 39 ans se présente suite à la perte de son ancien amalgame sur la dent numéro 15. Après
avoir nettoyé la cavité, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 54 ans se présente avec une carie importante sur la dent numéro 15 ayant nécessité la
réalisation d’un traitement endodontique. Après avoir déposer la reconstitution pré endodontique, vous
souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 31 ans se présente suite à la perte de son ancienne restauration sur la dent numéro 16 qui
possède un traitement endodontique. Après avoir réalisé un premier nettoyage de la cavité, vous souhaitez
reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 39 ans se présente avec une lésion carieuse proximale sur la dent 46. Après avoir effectué l’
éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 39 ans se présente avec un inlay qui présente une infiltration et des début de lésion
carieuses sur la dent . Après avoir déposé la restauration et effectué l’éviction carieuse, vous souhaitez
reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 39 ans se présente avec une fracture de sa cuspide disto-palatine sur la dent 16. Vous
souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 33 ans se présente avec une lésion carieuse sur la dent numéro 16. Après avoir réalisé l’
éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 16 ans se présente avec une fracture d’un ancien amalgame de la dent numéro 16. Après
avoir effectué l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 41 ans se présente avec une lésion carieuse en distal de la dent 16. Après avoir éffectué l’
éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 22 ans se présente avec une pulpite sur la dent numéro 16 ayant nécessité la réalisation
d’un traitement endodontique. Après avoir déposé la reconstitution pré endodontique, vous souhaitez
reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 16 ans se présente avec une lésion carieuse sur la dent 16. Après avoir réalisé l’éviction
carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Un patient de 39 ans se présente avec une carie sous un amalgame de la dent numéro 16. Après avoir
déposer la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Un patient de 70 ans se présente avec une carie sous un composite de la dent numéro 16. Après avoir
déposé la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Un patient de 16 ans se présente avec une lésion carieuse sur la dent 16. Après avoir réalisé l’éviction
carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
""",
        """
Une patiente de 23 ans se présente avec une carie sous une couronne de la dent numéro 15. Après avoir
déposer la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Une patiente de 32 ans se présente avec une carie sous un onlay de la dent numéro 15. Après avoir
déposer la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Une patiente de 40 ans se présente avec une carie sous un amalgame de la dent numéro 15. Après avoir
déposer la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Une patiente de 60 ans se présente avec perte d'obturation sur la dent numéro 15. Après avoir
déposé la restauration et effectuer l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce
patient.
""",
        """
Une patiente de 13 ans se présente avec une carie sur la numéro 15. Après avoir effectué l’éviction carieuse, vous souhaitez reconstruire la perte tissulaire de ce patient.
"""
    ]
}

fileprivate func loadDefaultQuestions_() -> [TctQuestion]
{
    var result = [TctQuestion]()
    let wordings = getQuestionWordings_()
    
    for (i, wording) in wordings.enumerated()
    {
        result.append(TctQuestion(volumeFileName: "\(i + 1)", wording: wording))
    }
    
    return result
}

class TctQuestion
{
    fileprivate static let allQuestions_: [TctQuestion] = {
        loadDefaultQuestions_()
    }()
    public static let sequences: [[Int]] = [
        [1,    2,    3,    7,    8,     11,     15,     17,    18,    22],
        [0,    5,    6,    7,    13,    15,     16,     18,    21,    23],
        [0,    2,    5,    6,    7,     8,      15,     20,    21,    23],
        [0,    7,    8,    10,   12,    13,     17,     18,    21,    22],
        [0,    6,    7,    10,   13,    17,     18,     19,    22,    23],
        [1,    4,    5,    6,    8,     12,     16,     18,    19,    23],
        [0,    1,    2,    4,    7,     10,     15,     16,    18,    19],
        [0,    1,    3,    4,    6,     9,      11,     21,    22,    23],
        [0,    1,    3,    5,    7,     8,      9,      17,    18,    20],
        [2,    4,    5,    10,   12,    17,     18,     20,    21,    23]
    ]
    
    public static func questions(sequenceIndex: Int) -> [TctQuestion]
    {
        if sequenceIndex < 0 || sequenceIndex > TctQuestion.allQuestions_.count - 1
        {
            return []
        }
        var result = [TctQuestion]()
        for i in TctQuestion.sequences[sequenceIndex]
        {
            result.append(TctQuestion.allQuestions_[i])
        }
        return result
    }
    
    var volumeFileName: String
    var wording:        String
    
    init(volumeFileName: String, wording: String)
    {
        self.volumeFileName = volumeFileName
        self.wording        = wording
    }
}

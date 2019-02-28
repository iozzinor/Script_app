//
//  ViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    static let scaHorizontalSegueId = "MainToScaHorizontalSegueId"
    static let walkthroughSegueId = "MainToWalkthroughSegueId"
    
    fileprivate var checkFirstTime_ = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if !checkFirstTime_ && UIApplication.isFirstLaunch
        {
            checkFirstTime_ = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                 self.launchWalkthrough()
            })
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case ViewController.scaHorizontalSegueId:
            prepareForScaHorizontal(segue: segue, sender: sender)
        default:
            break
        }
    }
    
    fileprivate func prepareForScaHorizontal(segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? ScaHorizontalViewController
        {
            var first = Sca()
            // TEMP
            first.wording = "Un patient de 34 ans se présente en consultation pour des douleurs intenses sur 36 depuis plusieurs jours. Cette dent a déjà été reconstitué par un onlay MOD 4 ans plus tôt."
            
            first.questions.append(ScaQuestion(hypothesis: "une fracture amélo-dentinaire", newData:" un sondage parodontal de 8 mm en vestibulaire"))
            first.questions.append(ScaQuestion(hypothesis: "une reprise carieuse et une pulpite sous l’onlay", newData:"  le test au froid est négatif"))
            first.questions.append(ScaQuestion(hypothesis: "une reprise carieuse et à une pulpite sous l’onlay", newData:"    Il y a une douleur à la palpation et à la percussion de la dent"))
            first.questions.append(ScaQuestion(hypothesis: "une surcharge occlusale", newData:"   le papier d’occlusion marque principalement sur les cuspides linguales"))
            
            var second = Sca()
            second.topic = .therapeutic
            second.wording = "Une patiente de 25 ans se présente en consultation pour la reconstruction de sa dent 11 qui ne présente ni douleur ni dyschromie."
            second.questions.append(ScaQuestion(hypothesis: "réaliser un composite en technique direct", newData: "sa dent a déja été reconstruite par plusieurs composite qui sont étanches"))
            second.questions.append(ScaQuestion(hypothesis: "réaliser un composite en technique direct", newData: "le test au froid est négatif"))
            second.questions.append(ScaQuestion(hypothesis: "réaliser une facette", newData: "la zone de collage est quasi intégralement dentinaire"))
            second.questions.append(ScaQuestion(hypothesis: "réaliser une facette", newData: "le patient est bruxomane"))

            
            let exam = ScaExam(scas: [first, second])
            destination.scaSession = ScaSession(exam: exam)
        }
    }
    
    fileprivate func launchWalkthrough()
    {
        performSegue(withIdentifier: ViewController.walkthroughSegueId,
                     sender: self)
    }
}


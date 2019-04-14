//
//  TplBundle.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import ToothCommon

/// Load tooth paths from the folder named "ToothPosition" in the main bundle.
class TplBundle: ToothPositionLoader
{
    func loadToothPosition(forTooth tooth: Tooth) throws -> ToothPosition
    {
        // get the url
        guard let url = Bundle.main.url(forResource: "\(tooth.internationalNumber)", withExtension: "tp", subdirectory: "ToothPosition") else
        {
            throw ToothPositionDataError.unableToReadData
        }
        
        // read the data
        let data: Data
        do
        {
            data = try Data(contentsOf: url, options: .alwaysMapped)
        }
        catch
        {
            throw ToothPositionDataError.unableToReadData
        }
        
        // create the tooth position
        return try ToothPosition(data: data)
    }
}

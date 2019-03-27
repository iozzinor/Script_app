//
//  SettingsViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -------------------------------------------------------------------------
// MARK: - SETTINGS SECTION
// -------------------------------------------------------------------------
enum SettingsSection: TableSection
{
    case general
    case account
    case developer
    case other
    
    var headerTitle: String? {
        switch self
        {
        case .general:
            return nil
        case .account:
            return "Settings.Section.Account.Title".localized
        case .developer:
            return "Settings.Section.Developer.Title".localized
        case .other:
            return nil
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SETTINGS ROW
// -----------------------------------------------------------------------------
enum SettingsRow: TableRow
{
    typealias ViewController = SettingsViewController
    
    static let textCellId = "SettingsTextCellReuseId"
    
    // general
    case about
    case advanced
    case passphrase
    
    // account
    case confidentialData
    case password
    case qualifications
    case logout
    case linkAccount
    case updateAccount
    
    // other
    case reset
    
    // developer
    case developer
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell {
        switch self
        {
        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.About".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
        case .advanced:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Advanced".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
        case .passphrase:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Passphrase".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
            
        case .confidentialData:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.ConfidentialData".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
        case .password:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Password".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
        case .qualifications:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Qualifications".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Logout".localized
            cell.textLabel?.textColor = Appearance.Color.error
            return cell
        case .linkAccount:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.LinkAccount".localized
            cell.textLabel?.textColor = Appearance.Color.action
            return cell
        case .updateAccount:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.UpdateAccount".localized
            cell.textLabel?.textColor = Appearance.Color.action
            return cell
            
        case .reset:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Reset".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
            
        case .developer:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsRow.textCellId, for: indexPath)
            cell.textLabel?.text = "Settings.Row.Developer".localized
            cell.textLabel?.textColor = Appearance.Color.default
            return cell
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        switch self
        {
        case .about, .advanced, .passphrase, .confidentialData, .password, .qualifications, .developer, .reset:
            return .disclosureIndicator
        case .logout, .linkAccount, .updateAccount:
            return .none
        }
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
}

// -----------------------------------------------------------------------------
// MARK: - SETTINGS VIEW CONTROLLER
// -----------------------------------------------------------------------------
class SettingsViewController: AsynchronousTableViewController<SettingsSection, SettingsRow, ErrorButtonView, UIView, UIView, UIViewController>
{
    public static let toAbout               = "SettingsToAboutSegueId"
    public static let toAdvancedSettings    = "SettingsToAdvancedSettingsSegueId"
    public static let toPassphrase          = "SettingsToPassphraseSegueId"
    public static let toLogin               = "SettingsToLoginSegueId"
    public static let toDeveloper           = "SettingsToDeveloperSegueId"
    public static let toReset               = "SettingsToResetSegueId"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var errorView_ = ErrorButtonView()
    fileprivate var connectionInformation_: ConnectionInformation?
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Settings.NavigationItem.Title".localized
        
        loadSettings_()
    }
    
    fileprivate func loadSettings_()
    {
        var newContent = Content()
        // general
        newContent.append((section: .general, rows: [.about, .advanced, .passphrase]))
        
        // account
        do
        {
            connectionInformation_ = try NetworkingService.shared.getConnectionInformation(host: Settings.shared.host)
            newContent.append((section: .account, rows: [.confidentialData, .password, .qualifications, .logout]))
        }
        catch let connectionError as NetworkingService.ConnectionError
        {
            switch connectionError
            {
            case .noAccountLinked:
                newContent.append((section: .account, rows: [.linkAccount]))
                
            case .wrongCredentials:
                newContent.append((section: .account, rows: [.updateAccount]))
            }
        }
        catch
        {    
        }
        
        // developer
        if Settings.shared.showDeveloper
        {
            newContent.append((section: .developer, rows: [.developer]))
        }
        
        // other
        newContent.append((section: .other, rows: [.reset]))
        state = .loaded(newContent)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setup(tableView: tableView, errorView: errorView_, emptyView: UIView(), loadingView: UIView(), viewController: self)
        setupErrorView_()
        
        loadSettings_()
    }
    
    fileprivate func setupErrorView_()
    {
        errorView_.delegate = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = content[indexPath.section].rows[indexPath.row]
        switch row
        {
        case .about, .advanced, .passphrase, .developer, .reset, .logout, .linkAccount, .updateAccount:
            return indexPath
        case .confidentialData, .password, .qualifications:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = content[indexPath.section].rows[indexPath.row]
        switch row
        {
        case .about:
            performSegue(withIdentifier: SettingsViewController.toAbout, sender: self)
        case .advanced:
            performSegue(withIdentifier: SettingsViewController.toAdvancedSettings, sender: self)
        case .passphrase:
            performSegue(withIdentifier: SettingsViewController.toPassphrase, sender: self)
        case .developer:
            performSegue(withIdentifier: SettingsViewController.toDeveloper, sender: self)
        case .reset:
            performSegue(withIdentifier: SettingsViewController.toReset, sender: self)
        case .logout:
            break
        case .linkAccount:
            performSegue(withIdentifier: SettingsViewController.toLogin, sender: self)
        case .updateAccount:
            break
        case .confidentialData, .password, .qualifications:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SettingsViewController.toPassphrase,
            let target = segue.destination as? PassphraseViewController
        {
            target.editType = .modify
            target.delegate = self
            target.previousPassphraseKind = AuthenticationManager.shared.passphraseKind
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - ERROR BUTTON DELEGATE
// -----------------------------------------------------------------------------
extension SettingsViewController: ErrorButtonDelegate
{
    func errorButtonView(shouldDisplayButton errorButtonView: ErrorButtonView, error: Error) -> Bool
    {
        switch error
        {
        case _ as NetworkError:
            return true
        default:
            return false
        }
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, actionTriggeredFor error: Error)
    {
        switch error
        {
        case _ as NetworkError:
            UIApplication.shared.openPreferences()
        default:
            break
        }
    }
    
    func errorButtonView(_ errorButtonView: ErrorButtonView, buttonTitleFor error: Error) -> String
    {
        switch error
        {
        case let networkError as NetworkError:
            return networkError.fixTip
        default:
            return ""
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - PASSPHRASE DELEGATE
// -----------------------------------------------------------------------------
extension SettingsViewController: PassphraseDelegate
{
    func passphraseViewController(_ passphraseViewController: PassphraseViewController, didChoosePassphrase passphrase: Passphrase)
    {
        navigationController?.popViewController(animated: true)
        
        AuthenticationManager.shared.storePassphrase(passphrase.text, kind: passphrase.kind)
    }
}

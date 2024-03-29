//
//  SearchViewController.swift
//  Calorico
//
//  Created by Dane Jensen on 9/13/23.
//

import UIKit
//
// MARK: - Gloabl Variables
//

var selectedTerm = ""
var showRecents = true
var recentSearches: [String] = []
var showHistory = true

//
// MARK: - Auto Complete View Controller
//

class AutoCompleteVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let colors = Colors()
    let autoCompleteTable = UITableView()
    var data: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        print(foodHistory)

        data = recentSearches

        DispatchQueue.main.async {

            self.autoCompleteTable.reloadData()
        }

        view.backgroundColor = .red

        autoCompleteTable.dataSource = self

        autoCompleteTable.delegate = self

        let upperView = UIView()

        upperView.translatesAutoresizingMaskIntoConstraints = false
        upperView.backgroundColor = colors.darkBlueBG
        view.addSubview(upperView)
        NSLayoutConstraint.activate([
            upperView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            upperView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            upperView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            upperView.heightAnchor.constraint(equalToConstant: 140)
        ])

        view.addSubview(autoCompleteTable)
        autoCompleteTable.backgroundColor = .white
        autoCompleteTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            autoCompleteTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            autoCompleteTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            autoCompleteTable.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 0),
            autoCompleteTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])

    }

    //
    // MARK: - Auto Complete Table
    //

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You Selected: " + data[indexPath.row])
        selectedTerm = data[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("SearchFood"), object: nil)
        autoCompleteTable.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "addCategoryCell")
        cell.selectionStyle =  UITableViewCell.SelectionStyle.default
        cell.imageView?.image = UIImage(systemName: (showRecents ? "clock.arrow.circlepath" : "magnifyingglass" ))?.withTintColor(.lightGray)
        cell.tintColor = .lightGray
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

}

//
// MARK: - Search View Controller
//
class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    //
    // MARK: - UI Initializers
    //
    let searchResultsTable = UITableView(frame: CGRect.zero, style: .grouped)
    let colors = Colors()
    let searchController = UISearchController(searchResultsController: AutoCompleteVC())
    let closeButton = UIBarButtonItem()
    let spinner = UIActivityIndicatorView(style: .medium)

    //
    // MARK: - Variables and Properties
    //
    var searchResults: [finalFoodItem] = []
    let networkManager = NetworkManager()

    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        recentSearches = (defaults.array(forKey: "recentSearches")) as? [String] ?? [""]
        addNoResults()
        showHistory = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.searchFood), name: Notification.Name("SearchFood"), object: nil)

        closeButton.style = .done
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem?.tintColor = .white

        setupSearchBar()

        searchResults = foodHistory
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        self.searchResultsTable.register(UINib(nibName: "SearchResultsCell", bundle: nil), forCellReuseIdentifier: "ResultsCell")
        setupResultsTable()

        title = "Search"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.backgroundColor = colors.darkBlueBG
       // navigationController?.setNavigationBarHidden(true, animated: false)

        let upperView = UIView()
        upperView.translatesAutoresizingMaskIntoConstraints = false
        upperView.backgroundColor = colors.darkBlueBG
        view.addSubview(upperView)
        NSLayoutConstraint.activate([
            upperView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            upperView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            upperView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            upperView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Do any additional setup after loading the view.
        let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = colors.darkBlueBG
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navigationController?.navigationBar.compactAppearance = navigationBarAppearance
            navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    //
    // MARK: - Setup Views
    //
    func addNoResults() {
        let vStack = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 85))
        vStack.axis = .vertical

        let noResults = MainLabel(labelText: "No Results.", labelType: .subheadingSmall, labelColor: .black)
        let newSearch = MainLabel(labelText: "Try a new search.", labelType: .caloriesLeft, labelColor: .lightGray)

        noResults.textAlignment = .center
        newSearch.textAlignment = .center

        vStack.addArrangedSubview(noResults)
        vStack.addArrangedSubview(newSearch)
        vStack.spacing = 0

        view.addSubview(vStack)
     //   vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.center = self.view.center

    }

    func setupResultsTable() {
        searchResultsTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchResultsTable)
        NSLayoutConstraint.activate([
            searchResultsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            searchResultsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            searchResultsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            searchResultsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        searchResultsTable.separatorStyle = .none
        searchResultsTable.backgroundView = spinner
        if #available(iOS 15.0, *) {
            searchResultsTable.sectionHeaderTopPadding = 5
        }
    }

    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        searchController.searchBar.searchTextField.attributedPlaceholder  = NSAttributedString(
            string: "Search for a food",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]

        )

        searchController.searchBar.tintColor = .white
     //   searchController.searchBar.placeholder = "Search for a food"
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["All Items", "My Items"]
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
        searchController.searchBar.setScopeBarButtonTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes(titleTextAttributesSelected, for: .selected)

        // searchController.isActive =
    }

    //
    // MARK: - Button Selectors
    //
    @objc func searchFood() {
        DispatchQueue.main.async { [self] in
            searchController.isActive = false
            searchController.searchBar.text = selectedTerm
        }
        fetchFoodFromTerm(term: selectedTerm)

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let text = searchController.searchBar.text else {
            return
        }
        searchController.isActive = false
        searchController.searchBar.text = text
        fetchFoodFromTerm(term: text)
    }

    @objc func closeView() {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
        let transition: CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }

    //
    // MARK: - Search Results TableView
    //
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))

               let label = UILabel()
               label.frame = CGRect.init(x: 20, y: 10, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = showHistory ? "History" : "Results"
        label.font =  UIFont(name: "Poppins-SemiBold", size: 20)
        label.textColor = .black

        headerView.addSubview(label)

        return headerView

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultsTable.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.async {

            let addPage = AddFoodViewController()
            addPage.existingFood = self.searchResults[indexPath.row]

            addPage.modalPresentationStyle = .overFullScreen
            self.present(addPage, animated: true, completion: nil)

            }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchResultsTable.dequeueReusableCell(withIdentifier: "ResultsCell") as! SearchResultsCell

        cell.food = searchResults[indexPath.row]
        cell.updateView()
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func fetchFoodFromTerm(term: String) {

        DispatchQueue.main.async { [self] in
            searchResultsTable.isHidden = false
            spinner.isHidden = false
            showHistory = false
            searchResultsTable.reloadData()
        }

        recentSearch(term: term)
        searchResults = []

        networkManager.getFoodFromSearch(searchTerm: term, page: 0) { result in
            switch result {
            case .success(let foods):
                print("Returned \(foods.count) foods")
                self.searchResults = foods
                DispatchQueue.main.async {
                    self.spinner.isHidden = true
                    self.searchResultsTable.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.searchResultsTable.isHidden = true
                }
            }
        }

    }

    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false

        guard let text = searchController.searchBar.text else {
            return
        }

        if !text.isEmpty {
            showRecents = false

            networkManager.getSearchAutoComplete(searchTerm: text) { result in
                switch result {
                case .success(let searchTerms):

                    DispatchQueue.main.async {
                        let test = searchController.searchResultsController as! AutoCompleteVC
                        test.data = searchTerms
                        test.autoCompleteTable.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }

            }
        } else {
            print("Showing recent searches")
            showRecents = true
            DispatchQueue.main.async {
                let test = searchController.searchResultsController as! AutoCompleteVC
                test.data = recentSearches
                test.autoCompleteTable.reloadData()
            }
        }
    }

     func recentSearch(term: String) {

         if recentSearches.count == 5 {
             recentSearches.removeLast()
             recentSearches.insert(term, at: 0)
         } else {
             recentSearches.insert(term, at: 0)
         }
         defaults.set(recentSearches, forKey: "recentSearches")

     }

}

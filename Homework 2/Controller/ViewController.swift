//
//  ViewController.swift
//  Homework 2
//
//  Created by Noah Korner on 4/6/20.
//  Copyright © 2020 asu. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: Outlets
    @IBOutlet weak var citiesTableView: UITableView!
    
    // MARK: Variables
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //handler to managed object
    var fetchResults = [City]() //array that stores CoreData entities
    var myCities = Cities() //Cities object with member variable cities[cityObject]
    var cityDictionary = [String:[cityObject]]()
    var citySectionTitles = [String]()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        self.fetchRecords()
        self.prepareSections()
        
    }
    
    func fetchRecords(){
        // Create a new fetch request using the CityEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        // Execute the fetch request, and cast the results to an array of FruitEnity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [City])!
        let count = fetchResults.count
        
        print("Number of fetched objects: \(count)")
        
        // For each City entity, create a cityObject and add it to myCities array
        for item in self.fetchResults {
            self.myCities.addCityObject(name: item.cityName!, desc: item.cityDesc!, image: UIImage(data: item.cityImage!, scale: 1.0)!)
        }
    }
    
    // MARK: Add City Functions
    @IBAction func addCity(_ sender: Any) {
        // Initialize Add City Alerts
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
              
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name of city..."
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Short description..."
        })
        
        // Initialize Photo Alert & Actions
        let photoAlert = UIAlertController(title: "Add Photo", message: "", preferredStyle: .alert)
                      
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (aciton) in
            let photoPicker = UIImagePickerController ()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
                          
            // Present Libary
            self.present(photoPicker, animated: true, completion: nil)
        }
                      
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ (action) in
            let photoPicker = UIImagePickerController ()
            photoPicker.delegate = self
            photoPicker.sourceType = .camera
            // Present Camera
            self.present(photoPicker, animated: true, completion: nil)
        }
        photoAlert.addAction(libraryAction)
        photoAlert.addAction(cameraAction)
        
        // Add New City Action
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let newCityName = alert.textFields?[0].text {
                if let newCityDesc = alert.textFields?[1].text {
                    self.addCity(cityName: newCityName, cityDesc: newCityDesc, cityImage: UIImage(named: "default.jpg")!)
                    // Present next alert
                    self.present(photoAlert, animated: true)
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    // Add City Helper Function
    func addCity(cityName:String, cityDesc:String, cityImage:UIImage){
        // Add to the cityObject array
        self.myCities.addCityObject(name: cityName, desc: cityDesc, image: cityImage)
        // Refresh the table
        self.prepareSections()
        self.citiesTableView.reloadData()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker .dismiss(animated: true, completion: nil)
        
        // Create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "City", in: self.managedObjectContext)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Update cityObject Image
            let cityObject = myCities.Cities.last
            cityObject?.cityImage = image
            // Update the row with image
            self.prepareSections()
            self.citiesTableView.reloadData()
            // Add to the managed object context
            let newCity = City(entity: ent!, insertInto: self.managedObjectContext)
            newCity.cityName = cityObject?.cityName
            newCity.cityDesc = cityObject?.cityDescription
            newCity.cityImage = image.pngData()! as Data
            fetchResults.append(newCity)
            // Save Core Data
            do {
                try managedObjectContext.save()
            } catch {
                print("Error while saving the new image")
            }
        }
    }
    
    @IBAction func editCity(_ sender: Any) {
        // Initialize Add City Alerts
        let editAlert = UIAlertController(title: "Edit City", message: nil, preferredStyle: .alert)
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        editAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            var deleted = cityObject(cn: "nil", cd: "nil", cimg: UIImage(named:"default")!)
            for item in self.myCities.Cities{
                if item.cityName == editAlert.textFields!.first!.text! {
                    deleted = item
                }
            }
            if deleted.cityName == "nil"{
                print("city not found")
                self.dismiss(animated: true, completion: nil)
            }
            else{
                let deletedName = deleted.cityName
                var index = 0
                for item in self.myCities.Cities{
                    if item.cityName == deletedName{
                        self.myCities.Cities.remove(at: index)
                        self.managedObjectContext.delete(self.fetchResults.remove(at: index))
                        // Save Core Data
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print("Error while deleting the city")
                        }
                    }
                    index += 1
                }
                self.prepareSections()
                self.citiesTableView.reloadData()
                //re-add the city
                self.addCity(self)
            }
        }))
        editAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Name of city to edit..."
        })
        
        
        self.present(editAlert, animated: true)
    }
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return myCities.getCount()
        let cityKey = citySectionTitles[section]
        if let cityValues = cityDictionary[cityKey]{
            return cityValues.count
        }
        return 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.citiesTableView.rowHeight = 75
        let cell = citiesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let cityKey = citySectionTitles[indexPath.section]
        if let cityValues = cityDictionary[cityKey] {
            // Calling the model to get the fruit object each row
            let cityItem = cityValues[indexPath.row]
            cell.cityName.text! = cityItem.cityName!
            cell.cityImage.image = cityItem.cityImage
        }
        return cell
    }
    
    func prepareSections(){
        self.cityDictionary.removeAll()
        self.citySectionTitles.removeAll()
        
        for city in myCities.Cities{
            let cityKey = String(city.cityName!.prefix(1))
            if var cityValues = cityDictionary[cityKey]{
                cityValues.append(city)
                cityDictionary[cityKey] = cityValues
            }else{
                cityDictionary[cityKey] = [city]
            }
        }
        
        citySectionTitles = [String](cityDictionary.keys)
        citySectionTitles = citySectionTitles.sorted(by: {$0 < $1})
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return citySectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return citySectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return citySectionTitles
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleted = citiesTableView.cellForRow(at: indexPath) as! CustomTableViewCell
            let deletedName = deleted.cityName.text!
            var index = 0
            for item in myCities.Cities{
                if item.cityName == deletedName{
                    myCities.Cities.remove(at: index)
                    managedObjectContext.delete(fetchResults.remove(at: index))
                    // Save Core Data
                    do {
                        try managedObjectContext.save()
                    } catch {
                        print("Error while deleting the city")
                    }
                }
                index += 1
            }
            self.prepareSections()
            citiesTableView.reloadData()
        }
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex: IndexPath = self.citiesTableView.indexPath(for: sender as! UITableViewCell)!
        let selectedCell = citiesTableView.cellForRow(at: selectedIndex) as! CustomTableViewCell
        let foundCity = myCities.getCityObject(findName: selectedCell.cityName.text!)
        
        if(segue.identifier == "detailView"){
               if let viewController: DetailViewController = segue.destination as? DetailViewController {
                    viewController.selectedCity = foundCity
               }
           }
       }
}


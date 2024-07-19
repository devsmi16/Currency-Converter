import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    /*
    @IBAction func getRatesClicked(_ sender: Any) {
        // 1- Request & Session
        // 2- Response & Data
        // 3- Parsing & JSON Serialization
        
        // 1. Step
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=dc7b9051924d313ea7b13aa30f5ead41")
        let session = URLSession.shared
        
        
        // Closure
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                // 2. Step
                if data != nil {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        // ASYNC
                        DispatchQueue.main.async{
                            print(jsonResponse["Success"] as Any)
                        }
                    }catch{
                        print("Error!")
                    }
                }
            }
        }
        task.resume()
    }
    */
    @IBAction func getRatesClicked(_ sender: Any) {
        guard let url = URL(string: "http://data.fixer.io/api/latest?access_key=dc7b9051924d313ea7b13aa30f5ead41") else {
            print("Invalid URL")
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let rates = jsonResponse["rates"] as? [String : Any] {
                            
                            if let cad = rates["CAD"] as? Double{
                                self.cadLabel.text = "CAD: \(cad)"
                            }
                            
                            if let chf = rates["CHF"] as? Double{
                                self.chfLabel.text = "CHF: \(chf)"
                            }
                            
                            if let gbp = rates["GBP"] as? Double{
                                self.gbpLabel.text = "GBP: \(gbp)"
                            }
                            
                            if let jpy = rates["JPY"] as? Double{
                                self.jpyLabel.text = "JPY: \(jpy)"
                            }
                            
                            if let usd = rates["USD"] as? Double{
                                self.usdLabel.text = "USD: \(usd)"
                            }
                            
                            if let turkish = rates["TRY"] as? Double{
                                self.tryLabel.text = "TRY: \(turkish)"
                            }
                            
                            
                        } else {
                            print("Key 'success' not found in JSON response")
                        }
                    }
                }
            } catch {
                print("JSON parse error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

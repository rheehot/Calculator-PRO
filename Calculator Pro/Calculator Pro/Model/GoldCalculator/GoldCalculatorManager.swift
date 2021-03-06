import Foundation

// Using https://www.goldapi.io/dashboard

protocol GoldCalculatorManagerDelegate{
    
    func didUpdateGoldPrice(_ goldCalculatorManager: GoldCalculatorManager, goldModel: GoldModel)
    
    func didFailWithError(error: Error)
}


struct GoldCalculatorManager{
    
    let goldUnitArray = ["oz", "g", "kg"]
    
    let APIKey = "goldapi-3ldrukkm196k6-io"
    let urlString = "https://www.goldapi.io/api/XAU/USD"
    
    var inputAmount: Float = 0.0
    var goldUnit: String = "oz"
    
    var goldDelegate: GoldCalculatorManagerDelegate?

}

//MARK: - API Networking Methods

extension GoldCalculatorManager{
    
    func fetchGoldPrice(){
        
        let semaphore = DispatchSemaphore (value: 0)
    
        if let url = URL(string: urlString){
            var request = URLRequest(url: url, timeoutInterval:  Double.infinity)
            request.addValue("goldapi-3ldrukkm196k6-io", forHTTPHeaderField: "x-access-token")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data else {
                    goldDelegate?.didFailWithError(error: error!)
                    return
                }
                if let goldModel = parseJSON(for: data){
                    goldDelegate?.didUpdateGoldPrice(self, goldModel: goldModel)
                }
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        }
 
    }
    
    func parseJSON(for goldData: Data)->GoldModel?{
        
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(GoldData.self, from: goldData)
            
            let currency = decodedData.currency
            let metal = decodedData.metal
            let price = decodedData.price
        
            
            let goldModel = GoldModel(metal: metal, currency: currency, price: price, finalResult: nil)
            
            return goldModel
        }
        catch{
            goldDelegate?.didFailWithError(error: error)
            return nil
        }
    }
}


//MARK: - Calculation Methods

extension GoldCalculatorManager{
    
     func calculateFinalResult(currentGoldPrice: Float)->Float{
        
        var finalResult: Float
       
        switch goldUnit {
        case "oz":
            finalResult = inputAmount * currentGoldPrice
        case "g":
            finalResult = (inputAmount * currentGoldPrice) / 28.35
        case "kg":
            finalResult = (inputAmount * currentGoldPrice) * 0.03
        default:
            finalResult = 0.0
        }
        return finalResult
    }
    
    
    mutating func setGoldUnit(unit: String){
        
        switch unit {
        case "oz":
            goldUnit = "oz"
        case "g":
            goldUnit = "g"
        case "kg":
            goldUnit = "kg"
        default:
            return
        }
    }
    
}

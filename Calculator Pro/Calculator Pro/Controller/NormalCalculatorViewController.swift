
import UIKit

class NormalCalculatorViewController: UIViewController {
    
    
    @IBOutlet weak var calculatorWorkings: UILabel!
    @IBOutlet weak var calculatorResults: UILabel!
    
    
    var workings: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Functions
    
    func clearAll(){
        workings = ""
        calculatorWorkings.text = ""
        calculatorResults.text = ""
    }
    
    func addToWorkings(value: String){
        
        workings = workings + value
        calculatorWorkings.text = workings
    }
     
    //MARK: - Calculator Functions
    @IBAction func allClearTap(_ sender: UIButton) {
        clearAll()
    }
    
    @IBAction func backTap(_ sender: UIButton) {
     
        if(!workings.isEmpty){
            workings.removeLast()
            calculatorWorkings.text = workings
        }
    }
    
    
    
    @IBAction func equalTap(_ sender: UIButton) {
        
        if(validInput()){
            
            let checkedWorkingsForPercent = workings.replacingOccurrences(of: "%", with: "*0.01")
            let expression = NSExpression(format: checkedWorkingsForPercent)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            
            let resultString = formatResult(result: result)
            
            calculatorResults.text = resultString
            
        }
        else{
            
            let alert = UIAlertController(title: "잘못된 입력입니다.", message: "입력값을 다시 확인해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true, completion: nil)
            clearAll()
            
        }
    
    }
    func formatResult(result: Double)->String{
        
        if(result.truncatingRemainder(dividingBy: 1) == 0){ //If a whole number
            return String(format: "%.0f", result)
        }
        else{
            return String(format: "%.2f", result)   //two decimal places
        }
    }
    
    func validInput()->Bool{
        
        var count = 0
        var funcCharIndexes = [Int]()
        
        // Going through each character in the workings String
        for char in workings{
            
            if(specialCharacter(char: char)){
                funcCharIndexes.append(count)
            }
            count += 1
        }
    
        var previous: Int = -1
        
        for index in funcCharIndexes{
                
            // If the very first input is a special character, the input is invalid
            if(index == 0){
                return false
            }
            
            // If the very last input is a special character, the input is also invalid
            if(index == workings.count - 1){
                return false
            }
            
            if(previous != -1){
                
                if(index - previous == 1){
                    return false
                }
            }
            previous = index
        }
        
        
        return true
    }
    
    // Function to check if input is indeed any of our functions
    func specialCharacter(char: Character)->Bool{
        
        if(char == "*"){
            return true
        }
        if(char == "/"){
            return true
        }
        if(char == "+"){
            return true
        }
        if(char == "-"){
            return true
        }
       
        return false
        
    }
    
    
    
    
    //MARK: - Numbers
    
    @IBAction func functionOrNumberButtonTapped(_ sender: UIButton) {

        addToWorkings(value: sender.currentTitle!)
        
    }

    
    
    
}

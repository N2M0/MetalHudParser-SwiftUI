import Foundation

class DataSet{
    static let shared = DataSet()
    
    var csvData : [[String]] = []
    
    var dataHeader: String = ""
    var missedFrame: Double = 0
    
    var gpuTimeData: [Double] = []
    var memoryData: [Double] = []
    var frameTimeData: [Double] = []
    
    var missedFrameTime: Int = 0
    var missedGPUTime: Int = 0
    
    var missedFrameTimeData: [String] = []
    var missedGPUTimeData: [String] = []
    
    var fpsData: [Double] = []
    var avgFPS : Double = 0
    
    private init() { }
    
    func loadCSV(from url: URL) {
        print("loadCSV")
        do {
            // Save data one by one
            let data = try String(contentsOf: url)
            csvData = data.components(separatedBy: "\n").map { $0.components(separatedBy: ",") }
        } catch {
            print("CSV loading ERROR: \(error)")
        }
    }
    
    func parseCSV(rawData : [[String]]){
        for (rowIndex, _) in rawData.enumerated(){
            
            if rawData[rowIndex][0] == "" {
                print("File end")
                break
            }
            
            else if rawData[rowIndex][0] == dataHeader {
                print("Duplicated Data!")
                continue
            }
            
            for (colIndex, _) in rawData[rowIndex].enumerated(){
                switch colIndex{
                case 0:
                    dataHeader = rawData[rowIndex][0]
                case 1:
                    missedFrame = Double(rawData[rowIndex][1])!
                case 2:
                    memoryData.append(Double(rawData[rowIndex][2])!)
                default:
                    if colIndex % 2 == 1 {
                        if rawData[rowIndex][colIndex].contains("<…>"){
                            missedFrameTimeData.append(rawData[rowIndex][colIndex])
                            missedFrameTime = missedFrameTime + 1
                        }
                        else{frameTimeData.append(Double(rawData[rowIndex][colIndex])!)}
                    }
                    else {
                        if rawData[rowIndex][colIndex].contains("<…>"){
                            missedGPUTimeData.append(rawData[rowIndex][colIndex])
                            missedGPUTime = missedFrameTime + 1
                        }
                        else{gpuTimeData.append(Double(rawData[rowIndex][colIndex])!)}
                    }
                }
            }
        }
    }
    
    func calculateFPS(frameTimeRawData: [Double]) {
        var tempFrameTimeSum: Double = 0
        var tempFrameNumSum: Double = 0
        var overTempFrameTimeSum: Double = 0
        
        for (Index, _) in frameTimeRawData.enumerated(){
            tempFrameTimeSum = tempFrameTimeSum + frameTimeRawData[Index]
            tempFrameNumSum = tempFrameNumSum + 1
            
            if tempFrameTimeSum >= 1000 - overTempFrameTimeSum {
                /// Rounds to the third place.
                fpsData.append(round((tempFrameNumSum / (tempFrameTimeSum / 1000)) * 100) / 100)
                overTempFrameTimeSum = tempFrameTimeSum - (1000 - overTempFrameTimeSum)
                print(overTempFrameTimeSum)
                tempFrameTimeSum = 0
                tempFrameNumSum = 0
            }
        }
        
        if tempFrameTimeSum > 0 {
            fpsData.append(round((tempFrameNumSum / (tempFrameTimeSum / 1000)) * 100) / 100)
        }
        
        for (Index, _) in fpsData.enumerated(){
            avgFPS = avgFPS + fpsData[Index]
        }
        
        avgFPS = avgFPS / Double(fpsData.count)
        avgFPS = round(avgFPS * 100) / 100
        
        print(fpsData)
    }
}

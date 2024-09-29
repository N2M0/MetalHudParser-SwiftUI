import SwiftUI
import Charts

struct FramerateChartView: View {
    let dataSet = DataSet.shared
    
    @State var selectedData : Int?
    
    var body: some View {
        VStack{
            Spacer()
            Text("Framerate Chart by MetalHUDParser-SwiftUI").font(.largeTitle)
            Spacer()
            
            //There are an error about
            //"The compiler is unable to type-check this expression in reasonable time"
            //So do not use Type Inference more
            
            if let bindingSelected = selectedData {
                HStack{
                    Text(String(Int(bindingSelected) / Int(60)) + "m " + String(Int(bindingSelected) % Int(60)) + "s / ")
                        .font(.title2)
                    Text("FPS : " + String(dataSet.fpsData[bindingSelected]))
                        .font(.title2)
                }
            } else {
                Text("Time / FPS")
                    .font(.title2)
            }
            
            Chart(){
                ForEach(0..<dataSet.fpsData.count, id:\.self){index in
                    LineMark(
                        x: .value("Seconds", index),
                        y: .value("FPS", dataSet.fpsData[Int(index)])
                    )
                    .symbol(.circle)
                    .interpolationMethod(.catmullRom)
                    
                    if let selectedData{
                        RuleMark(x: .value("selectedData", selectedData))
                            .foregroundStyle(Color.gray.opacity(0.3))
                            .offset(yStart: -10)
                            .zIndex(1)
                    }
                }
            }
            .chartXScale(domain: 0...dataSet.fpsData.count-1)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let originalSeconds = value.as(Int.self) {
                            let minutes : Int = originalSeconds / 60
                            let seconds : Int = originalSeconds - (minutes * 60)
                            Text(String(minutes) + "m " + String(seconds) + "s")
                        }
                    }
                }
            }
            .chartXSelection(value: $selectedData)
            Spacer()
        }.background(Color.white)
    }
}

#Preview {
    FramerateChartView()
}

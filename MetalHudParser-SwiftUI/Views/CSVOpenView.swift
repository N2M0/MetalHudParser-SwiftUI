import SwiftUI
import Charts
import UniformTypeIdentifiers

struct CSVOpenView: View {
    
    @State private var isImporting: Bool = false
    @State private var isParseDone: Bool = false
    @State private var dataStatus: String = "Please open CSV file"
    let dataSet = DataSet.shared
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                if(isParseDone){
                    FramerateChartView()
                    Spacer()
                }
                Text(dataStatus)
                    .font(.title)
                    .foregroundStyle(.mhpText)
                
                if !isParseDone{
                    Button("Import CSV") {
                        isImporting = true
                        dataStatus = "Please wait for a moment..."
                    }
                    .font(.title)
                    .foregroundStyle(.mhpText)
                    .fileImporter(isPresented: $isImporting, allowedContentTypes: [.commaSeparatedText]) { result in
                        switch result {
                        case .success(let url):
                            dataSet.loadCSV(from: url)
                            dataSet.parseCSV(rawData: dataSet.csvData)
                            dataSet.calculateFPS(frameTimeRawData: dataSet.frameTimeData)
                            dataStatus = "Total testing time : " + String(dataSet.fpsData.count / 60) + "m " + String(dataSet.fpsData.count % 60) + "s / AVG FPS : " + String(dataSet.avgFPS)
                            isImporting = false
                            isParseDone = true
                        case .failure(let error):
                            print("Import Error: \(error.localizedDescription)")
                        }
                    }
                }
                Spacer()
            }
            .background(.mhpBackGround)
            Spacer()
        }
        .background(.mhpBackGround)
    }
}

#Preview {
    CSVOpenView()
}

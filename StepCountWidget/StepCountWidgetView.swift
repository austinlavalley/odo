//
//  StepCountWidgetView.swift
//  odo
//
//  Created by Austin Lavalley on 7/14/24.
//

import SwiftUI
import WidgetKit



struct StepCountWidgetEntryView : View {
    var entry: StepCountEntry

    var body: some View {
        VStack {
            OdometerView(steps: entry.stepCount)
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.black)
        .containerBackground(.black, for: .widget)
    }
}





struct StepCountWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepCountWidgetEntryView(entry: StepCountEntry(date: Date(), stepCount: 3852))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

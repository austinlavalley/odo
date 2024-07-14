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
        HStack {
            VStack(alignment: .leading) {
                Text("Steps Today")
                    .font(.headline)
                Text("\(entry.stepCount)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
            Image(systemName: "figure.walk")
                .font(.system(size: 40))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}





struct StepCountWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepCountWidgetEntryView(entry: StepCountEntry(date: Date(), stepCount: 5000))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium Widget")
    }
}

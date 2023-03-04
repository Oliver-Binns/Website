import Foundation
import Plot
import Publish

struct Timeline: Component {
    let groupedItems: [Int: [Item<OliverBinns>]]

    init(items: [Item<OliverBinns>]) {
        self.groupedItems = Dictionary(grouping: items, by: \.date.year)
    }

    var body: Component {
        ComponentGroup(members: groupedItems.keys.sorted().reversed().map { year in
            ComponentGroup {
                Year(year)
                ComponentGroup(members: groupedItems[year, default: []].sorted().map { item in
                    Div {
                        ComponentGroup {
                            Node.i()
                                    .class("fas").class(item.metadata.icon ?? "")
                                .attribute(named: "aria-hidden", value: "true")

                            item.body.body
                        }
                    }.class("timeline-item")
                })
            }
        })
    }
}

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
}

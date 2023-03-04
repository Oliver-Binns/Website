import Plot

struct Year: Component {
    private let year: Int

    init(_ year: Int) {
        self.year = year
    }

    var body: Component {
        H4("\(year)").class("year")
    }
}

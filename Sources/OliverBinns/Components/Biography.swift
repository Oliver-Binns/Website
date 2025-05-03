import Plot

struct About: Component {
    var body: Component {
        Wrapper {
            Image(url: "Images/profile-yellow.jpg",
                  description: "A photo of Oliver in a yellow sweater")
                .class("profile-image")

            H3("Biography")

            Paragraph {
                Text("""
                Oliver is an experienced software engineer specialising in native iOS development with Swift, holding an MEng in Computer Science from the University of York. As a Manager at Deloitte Digital, he leads teams delivering high-profile mobile apps primary for the public sector. His work has included scaling a public sector app from the very first lines of code to multiple cross-functional feature teams, reaching #1 on the App Store and Google Play. 
                """).addLineBreak().addLineBreak()

                Text("""
                Beyond iOS, Oliver has wide knowledge of Android (Java, Kotlin, Unity/C#) and web technologies (Angular, PHP, JS, Python). He was shortlisted for Engineer of the Year at the BCS UK IT Industry Awards 2024, is an international conference speaker, and actively contributes to the open-source community. Oliver received WWDC scholarships in 2015 and 2016.
                """).addLineBreak().addLineBreak()

                Text("""
                Previously, he worked at Amadeus across several projects (C++, Java, Angular, Python, PHP, Swift) and led the native rebuild (Swift/Kotlin) and backend development (Swift/Vapor) for a healthcare app.
                """)
            }

        }
    }
}
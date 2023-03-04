import Plot

struct About: Component {
    var body: Component {
        Wrapper {
            Image(url: "images/profile-yellow.jpg",
                  description: "A photo of Oliver in a yellow sweater")
                .class("profile-image")

            H3("Biography")

            Paragraph {
                Text("""
                Oliver is an experienced software engineer who mainly focusses on native iOS development in Swift. He has worked on a number of mobile apps, across a range of sectors including travel, healthcare and productivity, for both the general consumer and enterprise markets. Oliver was awarded a scholarship to attend Apple's Worldwide Developer Conference in both 2015 & 16.
                """).addLineBreak().addLineBreak()

                Text("""
                As well as a deep understanding of the native Apple software development, Oliver has wide-ranging knowledge of Web and wider mobile platforms. He has worked on native (Java, Kotlin) and Unity (C#) applications for Android, and has developed for a range of web-based systems (Angular, PHP, JavaScript, Python).
                """).addLineBreak().addLineBreak()

                Text("""
                Oliver has an IET accredited master's degree in Computer Science from the University of York. Drawing on this background, he is able to ensure his work has a strong grounding in first principles, while observing best practices from industry. Oliver draws on his deep theoretical knowledge to quickly learn new tools and frameworks.
                """)
            }

        }
    }
}

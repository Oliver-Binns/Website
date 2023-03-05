---
date: 2021-12-18 19:00
title: Attempting SonarQube Analysis on Xcode Cloud
image: /images/hammer-sonar.png
tags: iOS, Swift
---

SonarQube can be a great tool for finding smells, bugs and duplications in your code. I like to use a combination of SonarQube and SwiftLint to enforce quality standards on the codebases I work on. These tools can help to ensure developers always meet the required standards in their code, and can reduce (or even prevent) the amount of bike-shedding on our merge requests.

Bike-shedding is where we spend a disproportionate amount of time discussing trivial things and leave important matters undiscussed. This is usually because the important items are more complex and we don’t spend the time to fully understand them, so we focus on the those that we can understand quickly. From a development perspective, I’ve seen intense debates on what the format for a pull request title should be, while the code itself is violating multiple SOLID principles.

Here I’ll be implementing SonarQube for a project I’ve written about before: my London Underground Status app. I’ll be using the Fastlane plugin for SonarQube and attempting to output a report on code quality and test coverage from an Xcode Cloud pull request validation build. I’m using SonarCloud for this, as it’s free for open source projects, but you can also use this for your own privately hosted SonarQube instances.

I won’t cover how to create an Xcode Cloud build, as others have covered that already and the [Apple Documentation](https://developer.apple.com/documentation/Xcode/Configuring-Your-First-Xcode-Cloud-Workflow) is fairly well written.

> prettylink https://docs.fastlane.tools/actions/sonar/
> image /images/fastlane.png
> title sonar - fastlane docs
> description Invokes sonar-scanner to programmatically run SonarQube analysis

> prettylink /posts/tube-status-widget
> image /images/roundel.png
> title Create a Tube Status home-screen Widget for iOS 14
> description In this article, I will detail how to quickly and easily create a home-screen widget for your app, using the London Underground status board as a real-world example.


## Prerequisites

Xcode Cloud agents are currently quite light on pre-installed software. They have Xcode, Homebrew, anything that comes pre-installed on macOS and that’s about it. To run Sonar Analysis, we’ll need to install three additional things on the build agent: fastlane, sonar-scanner and the fastlane plugin for converting Xcode’s test coverage output into JUnit format.

We can do this in our `ci_pre_xcodebuild.sh` script. As a single agent performs the build before handing off to multiple agents to run the tests in parallel, placing this in the `ci_post_clone.sh` won’t work as this is only run on the initial build agent.

```
#!/bin/sh
set -e

brew install fastlane
brew install sonar-scanner

fastlane add_plugin xcresult_to_junit
```

## Main Branch Analysis

We can start by performing an analysis on a shared branch, i.e. develop or main. This will help us to understand the overall health of our code-base. I’ve used the Fastlane plugin for SonarQube as it was the easiest way to install and run SonarQube on the build agent.

We can call this directly, or create a `Fastfile`:

```
fastlane run sonar \
   project_key:"tube-status-ios" \
   project_name:"tube-status-ios" \
   project_version:"1.0" \
   project_language:"swift" \
   sonar_runner_args:"-Dsonar.projectBaseDir=$CI_WORKSPACE -Dsonar.c.file.suffixes=- -Dsonar.cpp.file.suffixes=- -Dsonar.objc.file.suffixes=- -Dsonar.pullrequest.provider=github" \
   sources_path:$CI_WORKSPACE \
   sonar_organization:"oliver-binns" \
   sonar_login:$SONAR_TOKEN \
   sonar_url:"https://sonarcloud.io"
```

![Coverage: 0.0% on 8.3k new lines. Greater than or equal to 80% coverage is required. Red status.](/images/zero-percent-coverage.png)

_0.0% code covered by the unit test suite_

As you can see, this analysis has failed, in part because we haven’t met the code-coverage requirements. When running a test action, Xcode Cloud will provide us with a `$CI_RESULT_BUNDLE_PATH` variable which we can use to provide coverage results to SonarQube. Fastlane has [a plugin](https://github.com/zanizrules/fastlane-plugin-xcresult_to_junit) which lets us convert from the xcresult file that Xcode outputs into the JUnit format that SonarQube requires:

```
default_platform(:ios)

platform :ios do
  desc "Exports Test Coverage and Code Quality Analysis to SonarCloud"
  lane :sonar_analysis do |options|
    xcresult_to_junit(
      xcresult_path: options[:result_path],
      output_path: "#{options[:workspace]}/test_output"
    )
    sonar(
      project_key: "tube-status-ios",
      project_name: "tube-status-ios",
      project_version: "1.0",
      project_language: "swift",
      exclusions: "vendor",
      sonar_runner_args: "-Dsonar.projectBaseDir=#{options[:workspace]} -Dsonar.c.file.suffixes=- -Dsonar.cpp.file.suffixes=- -Dsonar.objc.file.suffixes=- -Dsonar.pullrequest.provider=github -Dsonar.junit.report_paths=#{options[:workspace]}/test_output",
      sources_path: options[:workspace],
      sonar_organization: "oliver-binns",
      sonar_login: options[:sonar_token],
      sonar_url: "https://sonarcloud.io",
    )
  end
end
```

Great, we can now see how much of our code is covered and where we can improve. For me and my Tube Status demo project, it seems there’s a long way to go!

![SonarQube report. 2.1k lines of code. Version 1, last analysis 14 days ago. Commit ID 2d3252a4. Quality Gate: Failed. 1 Failed Condition. New Code, since about 1 month ago. Reliability: 0 bugs. Maintainability: 1 code smell. Security: 0 vulnerabilities. Security Review: 0 security hotspots. Coverage: 8.6% coverage on 499 new lines to cover. Duplications 0.0% duplications on 2.1k new lines.](/images/full-report-sonar.png)

_SonarQube Report complete with test coverage metrics._

## Pull Request Analysis

When performing a pull request analysis, we need to pass some additional parameters to SonarQube so that it can determine the differences between the two branches. Luckily, these are all parameters that Xcode Cloud [provides us as Environment Variables](https://developer.apple.com/documentation/xcode/environment-variable-reference): `$CI_PULL_REQUEST_TARGET_BRANCH`, `$CI_PULL_REQUEST_SOURCE_BRANCH` and `$CI_PULL_REQUEST_NUMBER`. We can pass these in, as above, and then consume them as additional parameters in our Fastlane file.

```
default_platform(:ios)

platform :ios do
  desc "Exports Test Coverage and Code Quality Analysis to SonarCloud"
  lane :sonar_analysis do |options|
    xcresult_to_junit(
      ...
    )
    sonar(
      project_key: "tube-status-ios",
      ...,
      pull_request_branch: options[:source_branch],
      pull_request_base: options[:target_branch],
      pull_request_key: options[:pr_number] 
    )
  end
end
```

When Xcode retrieves our code for a pull request, it creates a new repository and checks out the target branch. After this it merges in the source branch. The outcome of this is that the agent only has one branch: which has the same name as our target branch (likely develop or main). This is a problem as when we compare the difference against the target branch, we’ll find no changes.

If we just run the same script that we used for our main branch, with the additional parameters, we’ll get a very boring report:

![SonarQube analysis results. 0 new lines. Quality Gate: Passed. Last analysis 7 minutes ago. Commit hash. Reliability: A rating, 0 bugs. Maintainability: A rating, 0 code smells. Security: A rating, 0 vulnerabilities. Security Review: A rating, 0 security hotspots.](/images/empty-report-sonar.jpg)

_A SonarQube report from Xcode Cloud showing no changes against the develop branch._

We have to do some Git magic to add the true target branch back into [the refspec](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec).

1. Create a new branch, we can just call it `temp`.
2. Delete the target branch so that we have no reference to it.
3. Reset the refspec to be able to retrieve the true target branch again.
4. Perform a git fetch to retrieve a clean reference to the remote target branch.

```
#!/bin/sh
set -e

git -C $CI_WORKSPACE checkout -b temp
git -C $CI_WORKSPACE branch -d $CI_PULL_REQUEST_TARGET_BRANCH

# fetch a reference to the develop branch on GitHub
# this will allow SonarQube analysis to work
git -C $CI_WORKSPACE config remote.origin.fetch \
"+refs/heads/$CI_PULL_REQUEST_SOURCE_BRANCH:refs/remotes/origin/$CI_PULL_REQUEST_SOURCE_BRANCH"
git -C $CI_WORKSPACE config remote.origin.fetch \
"+refs/heads/$CI_PULL_REQUEST_TARGET_BRANCH:refs/remotes/origin/$CI_PULL_REQUEST_TARGET_BRANCH"
git -C $CI_WORKSPACE fetch
```

That’s better, we can now run an analysis and changes will get detected: 47 new lines.

![SonarQube report. 47 new lines. From branch feature/sonar-qube to develop. Last analysis 2 days ago, commit ID fbb4d929. 1 warning. Quality gate failed. 1 failed condition. Reliability: 0 bugs. Maintainability: 0 code smells. Security: 0 vulnerabilities. Security Review: 0 security hotspots. Coverage: 0.0% coverage on 26 new lines to cover. 0.0% estimated after merge. Duplications 0.0% duplications on 47 new lines. 1.3% estimated after merge.](/images/line-difference-sonar.png)

_A SonarQube report from Xcode Cloud showing 47 lines changed against the develop branch._

## Summary

As you can see, it’s possible to get some of the features of SonarQube working on Xcode Cloud. Unfortunately, a lack of pre-installed software makes it slow to run, and a number of the implementation details make it tricky to implement. There no guarantee that this will be improved in the future, or that future changes won’t break the workarounds that we’ve implemented to get this to work. All in all, if you require SonarQube, I’d probably suggest steering clear of Xcode Cloud for the timebeing.

Checkout the final implementation on GitHub:

> prettylink https://github.com/Oliver-Binns/tube-status-ios/tree/develop/ci_scripts
> image /images/tube-status-ios-github.png
> title Xcode Cloud CI Scripts: Tube Status
> description A sample iOS app for displaying the status of the London Underground using WidgetKit. - tube-status-ios/ci_scripts at develop · Oliver-Binns/tube-status-ios

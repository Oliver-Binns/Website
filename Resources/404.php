<?php
    switch($_SERVER['REQUEST_URI']) {
    case '/2022/01/04/some-thoughts-on-xcode-cloud/';
    case '/2022/01/04/some-thoughts-on-xcode-cloud';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/xcode-cloud-thoughts');
        exit();
    case '/2021/12/26/what-ive-learnt-from-advent-of-code-21/';
    case '/2021/12/26/what-ive-learnt-from-advent-of-code-21';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/advent-of-code-21');
        exit();
    case '/2021/12/18/attempting-sonarqube-analysis-on-xcode-cloud/';
    case '/2021/12/18/attempting-sonarqube-analysis-on-xcode-cloud';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/sonarqube-xcodecloud');
        exit();
    case '/2021/04/28/gitflow-with-automation-for-mobile-apps/';
    case '/2021/04/28/gitflow-with-automation-for-mobile-apps';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/gitflow-automation');
        exit();
    case '/2021/03/26/creating-great-enterprise-apps/';
    case '/2021/03/26/creating-great-enterprise-apps';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/enterprise-apps');
        exit();
    case '/2020/11/25/going-native-with-wordpress/';
    case '/2020/11/25/going-native-with-wordpress';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/native-with-wordpress');
        exit();
    case '/2020/09/05/going-for-gold-taking-full-advantage-of-apple-platforms/';
    case '/2020/09/05/going-for-gold-taking-full-advantage-of-apple-platforms';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/going-for-gold');
        exit();
    case '/2020/07/23/constructing-data-with-swift-function-builders/';
    case '/2020/07/23/constructing-data-with-swift-function-builders';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/function-builders');
        exit();
    case '/2020/07/03/building-almost-anything-on-bitrise-using-docker/';
    case '/2020/07/03/building-almost-anything-on-bitrise-using-docker';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/docker-bitrise');
        exit();
    case '/2020/06/27/create-a-tube-status-home-screen-widget-for-ios-14/';
    case '/2020/06/27/create-a-tube-status-home-screen-widget-for-ios-14';
        header('HTTP/1.1 301 Moved Permanently');
        header('Location: /posts/tube-status-widget');
        exit();
    default:
        header('HTTP/1.1 404 Not Found');
        header('Location: /index.php');
        exit();
    }
?>

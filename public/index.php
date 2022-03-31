<?php

$environ = getenv('HOST') ?: 'dev';
define('APPLICATION_PATH', dirname(__DIR__));
//require APPLICATION_PATH . '/vendor/autoload.php';
$application = new Yaf_Application(APPLICATION_PATH . '/conf/application.ini', $environ);
$application->bootstrap()->run();

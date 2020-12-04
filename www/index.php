<?php
require_once __DIR__ . '/vendor/autoload.php';

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Silex\Application;

$app = new Silex\Application();


$app->GET('/', function(Application $app, Request $request) {
            return $app->json(array(
                'verify' => getenv('SSL_CLIENT_VERIFY'), 
                'datefin' => date('Y-m-d H:i:s.001Z',strtotime(getenv('SSL_CLIENT_V_END'))),
                'cn' => getenv('SSL_CLIENT_S_DN_CN'),
                'prenom' => getenv('SSL_CLIENT_S_DN_G'),
                'nom' => getenv('SSL_CLIENT_S_DN_S'),
                ), 
                200);
            });


$app->run();

<?php

require __DIR__ . '/../vendor/autoload.php';

$hora = date('g:i:s');

(new \Symfony\Component\HttpFoundation\JsonResponse(['hora'=>$hora]))->send();

<?php
require '../vendor/autoload.php';
use Symfony\Component\HttpFoundation\JsonResponse;
$hora = date('g:i:s');
$response = new JsonResponse(['hora' => $hora]);
$response->send();

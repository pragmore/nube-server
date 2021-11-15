<?php

define('EMAIL', 'nube@pragmore.com');
define('WHATSAPP_NUMBER', '+54 11 5623-4435');
define('APPLY_BETA', 'Quiero participar de la beta');
define('DESCRIPTION', 'Subi tu PHP de la manera mas fácil y rápida. Soporta Laravel, Symfony, entre otros.');

function onlyNumbers(string $text): string
{
    return preg_replace('/[^0-9.]+/', '', $text); 
}

?><!doctype html>
<html lang="en">
<head>
  <title>Nube, by Pragmore</title>
  <meta charset="utf-8">
  <meta name="description" content="<?= DESCRIPTION ?>">
  <meta property="og:title" content="Nube, servicio de cloud de PHP (PaaS) 🚀" />
  <meta property="og:description" content="<?= DESCRIPTION ?>" />
  <meta property="og:image" itemprop="image" content="https://nube.pragmore.com/push-prod.png">
  <meta property="og:type" content="website" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" href="data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3Ctext%20y=%22.9em%22%20font-size=%2290%22%3E🚀%3C/text%3E%3C/svg%3E">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/blouse.css/dist/blouse.css" crossorigin="anonymous">
<style>
@import url('https://fonts.googleapis.com/css2?family=Quicksand:wght@400;700&display=swap');
body { font-family: 'Quicksand', sans-serif }
h1 span{ font-size: .8em }
@media (max-width:420px) { h1 { margin: 1em }}
</style>
</head>
<body>
  <main class="text-center">
    <h1><em>Nube</em>, by Pragmore <span aria-hidden="true">🚀</span></h1>
    <p class="text-lg">
        Poné tus apps <em>PHP</em> online en segundos desde <strong>git</strong>. Un Heroku nacional y popular, a precios cuidados. <strong>Sumate a la beta gratis</strong>.
    </p>
    <p class="text-lg">
        <a href="mailto:<?= EMAIL ?>?subject=<?= APPLY_BETA ?>" class="btn main"><?= APPLY_BETA ?> <span aria-hidden="true">✨</span></a>
    </p>
    <script id="asciicast-RiPZdEvLYAlcDuxUqpxCqDisa" src="https://asciinema.org/a/RiPZdEvLYAlcDuxUqpxCqDisa.js" async></script>
    <p>Lo podes usar con PhpStorm, Visual Studio Code, Sublime o cualquier otro programa que soporte <strong>git</strong>. Mira también como se integra con <a href="https://asciinema.org/a/I8YTFPTFVh4Z1YeaZqWQYEdyK" target="_blank">Laravel y corre las migraciones automáticamente</a>.</p>

    <h2 class="mt-4">Mandanos un mensaje</h2>
    <h4><span aria-hidden="true">📩</span> <a href="mailto:<?= EMAIL ?>"><?= EMAIL ?></a></h4>
    <h4>
      <a href="https://wa.me/<?= onlyNumbers(WHATSAPP_NUMBER ) ?>" target="_blank" aria-label="Contactanos por WhatsApp">
        <i class="wa" aria-hidden="true" title="Contactanos por WhatsApp"></i>
        <?= WHATSAPP_NUMBER ?>
      </a>
    </h4>
  </main>
  <footer>
    <span>Hecho con ❤️ y 🥚🥚🥚
        por <a href="https://pragmore.com">Pragmore</a></span>
    <span>
      <a href="https://wa.me/<?= onlyNumbers(WHATSAPP_NUMBER ) ?>" target="_blank" aria-label="Contactanos por WhatsApp">
        <i class="wa" aria-hidden="true" title="Contactanos por WhatsApp"></i>
      </a>
    </span>
    <span>
      <a href="https://twitter.com/pragmore" target="_blank" aria-label="Twitter">
        <i class="tw" aria-hidden="true" title="Twitter"></i>
      </a>
    </span>
    <span>
      <a href="https://www.linkedin.com/company/pragmore/" target="_blank" aria-label="LinkedIn">
        <i class="in" aria-hidden="true" title="LinkedIn"></i>
      </a>
    </span>
  </footer>
<script>
if ("maxTouchPoints" in navigator && navigator.maxTouchPoints > 0) {
    document.querySelector('.btn.main').href = "https://wa.me/<?= onlyNumbers(WHATSAPP_NUMBER) ?>?text=<?= APPLY_BETA ?>";
}
</script>
</body>
</html>

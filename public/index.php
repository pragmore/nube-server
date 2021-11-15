<?php

define('APPLY_BETA', 'Quiero participar de la beta de Nube');

?><!doctype html>
<html lang="en">
<head>
  <title>Nube, by Pragmore</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" href="data:image/svg+xml,%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20viewBox=%220%200%20100%20100%22%3E%3Ctext%20y=%22.9em%22%20font-size=%2290%22%3E☁️%3C/text%3E%3C/svg%3E">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/blouse.css/dist/blouse.css" crossorigin="anonymous">
</head>
<body>
  <main class="text-center">
    <h1><em>Nube</em>, by Pragmore</h1>
    <h3>“Heroku con precios cuidados”</h3>
    <p class="text-lg">
        Deploya tus apps PHP desde git. Como Heroku pero pagando en pesos argentinos. <strong>Sumate a la beta gratis</strong>.
    </p>
    <p class="text-lg">
        <a href="mailto:albo@pragmore.com?subject=<?= APPLY_BETA ?>" class="btn main"><?= APPLY_BETA ?></a>
    </p>
    <script id="asciicast-1nrxebECCVbb3wsfuVMhk4fzA" src="https://asciinema.org/a/1nrxebECCVbb3wsfuVMhk4fzA.js" async></script>
    <p>Mira como se integra con <a href="https://asciinema.org/a/I8YTFPTFVh4Z1YeaZqWQYEdyK" target="_blank">Laravel y corre las migraciones automáticamente</a>.</p>

  </main>
  <footer>
    <span>Hecho con ❤️ y 🥚🥚🥚
        por <a href="https://pragmore.com">Pragmore</a></span>
    <span>
      <a href="https://wa.me/541156234435" target="_blank" aria-label="WhatsApp">
        <i class="wa" aria-hidden="true" title="WhatsApp"></i>
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
    document.querySelector('.btn.main').href = document.querySelector("[aria-label=WhatsApp]").href + "?text=<?= APPLY_BETA ?>";
}
</script>
</body>
</html>

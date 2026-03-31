import json
import os
import random
import subprocess
from datetime import datetime, timezone

ROOT = os.path.dirname(os.path.dirname(__file__))
FACTS_PATH = os.path.join(ROOT, "scripts", "flo_funfacts.json")

with open(FACTS_PATH, "r", encoding="utf-8") as f:
    facts = json.load(f)

fact = random.choice(facts)

after_lines = [
    "Erinnerung des Tages: Nur Fleisch macht Fleisch. Iss mehr, Maschine.",
    "PSA deiner Sekretärin: Mehr essen. Nur Fleisch macht Fleisch.",
    "Und jetzt vernünftig futtern, Flo: Nur Fleisch macht Fleisch."
]

secretary_name = random.choice([
    "Kurvenkathi",
    "Apex-Aylin",
    "Schräglagen-Susi",
    "Rennsemmel-Rita",
    "Benzin-Bianca",
])

subject = random.choice([
    "Flo, kurzer Servicehinweis aus der Knieschleifer-Zentrale",
    "Moin Flo – dein täglicher Motorrad-Quatsch mit Sinn",
    "Flo, bevor du wieder am Kabel ziehst",
    "Ein kurzer Gruß aus der Kurven-Hölle, Flo",
    "Flo, einmal Technik in lecker und frech",
])

body = (
    f"Moin Flo,\n\n"
    f"hier ist {secretary_name}, deine inoffizielle Sekretärin der Knieschleifer-Gang. "
    "Ich klatsch dir kurz was Nützliches rein, bevor du wieder wie ein Irrer in die Kurven stichst:\n\n"
    f"{fact}\n\n"
    f"{random.choice(after_lines)}\n\n"
    "So, genug gelabert. Helm zu, Hirn an, dann gib ihm.\n"
)

env = os.environ.copy()
env["MAIL_SUBJECT"] = subject
env["MAIL_BODY"] = body
env["SMTP_TO"] = env.get("FLO_EMAIL", "florian.kunzweiler@dwarftech.de")

cmd = ["python", "/app/scripts/send_mail.py"]
subprocess.run(cmd, check=True, env=env)
print("FLO_FUNFACT_SENT")

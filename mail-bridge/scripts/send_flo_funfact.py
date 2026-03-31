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

subject = f"[Knieschleifer Fun Fact] {datetime.now(timezone.utc).strftime('%d.%m.%Y %H:%M UTC')}"
body = (
    "Moin Flo,\n\n"
    "Sekretärin der Knieschleifer-Zentrale hier – Tagesansage:\n\n"
    f"{fact}\n\n"
    f"{random.choice(after_lines)}\n\n"
    "Gruß aus der Kurven-Hölle. Fahr sauber, nicht nur laut.\n"
)

env = os.environ.copy()
env["MAIL_SUBJECT"] = subject
env["MAIL_BODY"] = body
env["SMTP_TO"] = env.get("FLO_EMAIL", "florian.kunzweiler@dwarftech.de")

cmd = ["python", "/app/scripts/send_mail.py"]
subprocess.run(cmd, check=True, env=env)
print("FLO_FUNFACT_SENT")

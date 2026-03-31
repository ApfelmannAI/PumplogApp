import email
import imaplib
import json
import os
import random
import re
import subprocess
from datetime import datetime, timezone
from email.header import decode_header, make_header
from email.utils import parsedate_to_datetime

STATE_PATH = "/app/outbox/flo_reply_state.json"
REPLY_TEMPLATES_PATH = "/app/scripts/flo_reply_templates.json"

IMAP_HOST = os.getenv("IMAP_HOST", "imap.strato.de")
IMAP_PORT = int(os.getenv("IMAP_PORT", "993"))
IMAP_USER = os.getenv("IMAP_USER", os.getenv("SMTP_USER", "")).strip()
IMAP_PASS = os.getenv("IMAP_PASS", os.getenv("SMTP_PASS", "")).strip()
IMAP_FOLDER = os.getenv("IMAP_FOLDER", "INBOX")
FLO_EMAIL = os.getenv("FLO_EMAIL", "florian.kunzweiler@dwarftech.de").strip().lower()
MAX_REPLIES_PER_DAY = int(os.getenv("MAX_REPLIES_PER_DAY", "2"))

if not IMAP_HOST or not IMAP_USER or not IMAP_PASS:
    raise SystemExit("IMAP credentials missing (IMAP_HOST/IMAP_USER/IMAP_PASS)")


def load_state():
    if os.path.exists(STATE_PATH):
        with open(STATE_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    return {"replied_ids": [], "daily": {}}


def save_state(state):
    os.makedirs(os.path.dirname(STATE_PATH), exist_ok=True)
    with open(STATE_PATH, "w", encoding="utf-8") as f:
        json.dump(state, f, ensure_ascii=False, indent=2)


def decode_subject(raw):
    if not raw:
        return ""
    try:
        return str(make_header(decode_header(raw)))
    except Exception:
        return raw


def get_plain_text(msg):
    if msg.is_multipart():
        for part in msg.walk():
            ctype = part.get_content_type()
            disp = str(part.get("Content-Disposition", ""))
            if ctype == "text/plain" and "attachment" not in disp.lower():
                payload = part.get_payload(decode=True)
                charset = part.get_content_charset() or "utf-8"
                if payload:
                    return payload.decode(charset, errors="ignore")
    else:
        payload = msg.get_payload(decode=True)
        if payload:
            charset = msg.get_content_charset() or "utf-8"
            return payload.decode(charset, errors="ignore")
    return ""


with open(REPLY_TEMPLATES_PATH, "r", encoding="utf-8") as f:
    templates = json.load(f)

state = load_state()
today = datetime.now(timezone.utc).strftime("%Y-%m-%d")
replies_today = state.get("daily", {}).get(today, 0)
if replies_today >= MAX_REPLIES_PER_DAY:
    print("DAILY_LIMIT_REACHED")
    raise SystemExit(0)

mail = imaplib.IMAP4_SSL(IMAP_HOST, IMAP_PORT)
mail.login(IMAP_USER, IMAP_PASS)
mail.select(IMAP_FOLDER)

status, data = mail.search(None, 'UNSEEN', f'FROM "{FLO_EMAIL}"')
if status != "OK":
    print("NO_SEARCH_RESULTS")
    mail.logout()
    raise SystemExit(0)

msg_ids = data[0].split()
if not msg_ids:
    print("NO_NEW_MAIL")
    mail.logout()
    raise SystemExit(0)

# newest first
msg_ids = list(reversed(msg_ids))

for msg_id in msg_ids:
    sid = msg_id.decode("utf-8", errors="ignore")
    if sid in state.get("replied_ids", []):
        continue

    status, msg_data = mail.fetch(msg_id, "(RFC822)")
    if status != "OK" or not msg_data:
        continue

    raw = msg_data[0][1]
    msg = email.message_from_bytes(raw)

    from_addr = email.utils.parseaddr(msg.get("From", ""))[1].lower()
    if FLO_EMAIL not in from_addr:
        continue

    subj = decode_subject(msg.get("Subject", ""))
    body_in = get_plain_text(msg)
    body_in = re.sub(r"\s+", " ", body_in).strip()
    teaser = body_in[:220] + ("…" if len(body_in) > 220 else "")

    reply_subject = f"Re: {subj}" if subj else "Kurze Antwort aus der Knieschleifer-Zentrale"
    base = random.choice(templates)
    reply_body = f"{base}\n\nKurz zu deiner Nachricht: \"{teaser or 'Gelesen und notiert.'}\"\n\n– Kurvenkathi"

    env = os.environ.copy()
    env["SMTP_TO"] = FLO_EMAIL
    env["MAIL_SUBJECT"] = reply_subject
    env["MAIL_BODY"] = reply_body

    subprocess.run(["python", "/app/scripts/send_mail.py"], check=True, env=env)

    # mark seen
    mail.store(msg_id, "+FLAGS", "\\Seen")

    state.setdefault("replied_ids", []).append(sid)
    # cap memory
    state["replied_ids"] = state["replied_ids"][-500:]
    state.setdefault("daily", {})[today] = state.get("daily", {}).get(today, 0) + 1
    save_state(state)

    print("FLO_REPLY_SENT")
    break
else:
    print("NO_ACTION")

mail.close()
mail.logout()

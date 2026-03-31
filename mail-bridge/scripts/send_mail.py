import os
import ssl
import smtplib
from email.message import EmailMessage
from datetime import datetime, timezone


def env(name: str, default: str = "") -> str:
    return os.getenv(name, default).strip()


smtp_host = env("SMTP_HOST")
smtp_port = int(env("SMTP_PORT", "465"))
smtp_user = env("SMTP_USER")
smtp_pass = env("SMTP_PASS")
smtp_from = env("SMTP_FROM", smtp_user)
smtp_to = env("SMTP_TO")
use_ssl = env("SMTP_USE_SSL", "true").lower() in {"1", "true", "yes", "on"}

subject = env("MAIL_SUBJECT", "OpenClaw Update")
body = env("MAIL_BODY", f"Status update generated at {datetime.now(timezone.utc).isoformat()}")

missing = [
    name
    for name, value in {
        "SMTP_HOST": smtp_host,
        "SMTP_USER": smtp_user,
        "SMTP_PASS": smtp_pass,
        "SMTP_FROM": smtp_from,
        "SMTP_TO": smtp_to,
    }.items()
    if not value
]

if missing:
    raise SystemExit(f"Missing required env vars: {', '.join(missing)}")

msg = EmailMessage()
msg["From"] = smtp_from
msg["To"] = smtp_to
msg["Subject"] = subject
msg.set_content(body)

if use_ssl:
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL(smtp_host, smtp_port, context=context, timeout=30) as server:
        server.login(smtp_user, smtp_pass)
        server.send_message(msg)
else:
    with smtplib.SMTP(smtp_host, smtp_port, timeout=30) as server:
        server.starttls(context=ssl.create_default_context())
        server.login(smtp_user, smtp_pass)
        server.send_message(msg)

print("MAIL_SENT")

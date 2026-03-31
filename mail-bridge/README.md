# Mail Bridge (STRATO SMTP)

Diese kleine Bridge verschickt Statusmails per STRATO SMTP, ohne Passwörter im Chat zu teilen.

## 1) Setup

```bash
cd /data/workspace/mail-bridge
cp .env.example .env
```

Dann `.env` bearbeiten und `SMTP_PASS` setzen.

## 2) Starten

```bash
docker compose up -d
```

## 3) Testmail

```bash
chmod +x send_test_mail.sh send_update_mail.sh
./send_test_mail.sh
```

Wenn erfolgreich, erscheint `MAIL_SENT`.

## 4) Update-Mail senden

```bash
./send_update_mail.sh "[PumpLog] Zwischenstand" "Build läuft, nächstes Update in 30 Minuten."
```

## STRATO Werte

- SMTP Host: `smtp.strato.de`
- Port: `465`
- Sicherheit: `SSL/TLS`
- Benutzername: volle Mailadresse

## Sicherheit

- `.env` nie committen.
- Passwort nach dem Posten im Chat als kompromittiert ansehen und wechseln.

# Security Policy

WorkSphere is maintained as an academic, portfolio, and project demonstration application.

This project is publicly available for learning and review purposes, but it should not be treated as a production-ready system without additional security improvements.

---

## Supported Version

| Version | Status |
|---|---|
| v1.0.0 | Portfolio release |

---

## Security Guidelines

Before using or deploying this project, make sure to follow these security practices:

```text
Do not commit database passwords
Do not commit email credentials
Do not commit API keys
Do not expose server credentials
Use environment variables for sensitive values
Use HTTPS in production
Validate all user input
Protect authenticated routes
Restrict file upload types
Limit uploaded file size
Use secure session handling
Rotate credentials if they are accidentally exposed

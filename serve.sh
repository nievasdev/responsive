#!/usr/bin/env bash
# Sirve el snapshot en http://localhost:8080 (Ctrl+C para parar)
cd "$(dirname "$0")" && python3 -m http.server 8080

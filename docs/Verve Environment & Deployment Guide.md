# Verve: Environment & Deployment Guide v1.0

**Document Status:** Engineering Ready  
**Date:** May 13, 2026

## 1. Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| **Flutter** | 3.22+ | Consumer + Rider mobile apps |
| **Dart** | 3.4+ | Flutter language |
| **Go** | 1.22+ | Orchestrator middleware |
| **Python** | 3.11+ | Intent Engine |
| **Node.js** | 20+ | Nexus API |
| **PostgreSQL** | 16+ | Transactional database |
| **Redis** | 7+ | Cache, sessions, real-time |
| **Docker** | 24+ | Observability stack, local services |
| **Android Studio** | Latest | Android SDK, emulator |

## 2. Local Development Setup

### 2.1 Clone and Structure
```bash
git clone https://github.com/ericfranzee/Verve.git
cd Verve
```

### 2.2 Database Setup
```bash
# PostgreSQL
createdb verve_dev
psql verve_dev < services/nexus-api/migrations/schema.sql

# Redis
redis-server --port 6379
```

### 2.3 Start Backend Services

**Terminal 1 — Go Orchestrator:**
```bash
cd services/orchestrator
cp .env.example .env  # Configure REDIS_URL, ALLOWED_ORIGINS, JWT_SECRET
go run .
# → Listening on :8080
```

**Terminal 2 — Python Intent Engine:**
```bash
cd services/intent-engine
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env  # Configure OPENAI_API_KEY, WHISPER_MODEL
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
# → Listening on :8000
```

**Terminal 3 — Node.js Nexus API:**
```bash
cd services/nexus-api
npm install
cp .env.example .env  # Configure DATABASE_URL, REDIS_URL, PAYSTACK_SECRET
npm run dev
# → GraphQL at http://localhost:4000/graphql
```

**Terminal 4 — Observability (Optional):**
```bash
cd ops
docker compose up -d
# → Prometheus: :9090, Grafana: :3000, Jaeger: :16686
```

### 2.4 Start Mobile Apps

**Consumer App:**
```bash
cd apps/mobile
flutter pub get
flutter run --debug
```

**Rider App:**
```bash
cd apps/rider
flutter pub get
flutter run --debug
```

## 3. Environment Variables

### 3.1 Go Orchestrator (`services/orchestrator/.env`)
```env
PORT=8080
REDIS_URL=redis://localhost:6379
INTENT_ENGINE_URL=http://localhost:8000
NEXUS_API_URL=http://localhost:4000
JWT_SECRET=your-jwt-secret-here
ALLOWED_ORIGINS=http://localhost:3000,capacitor://localhost
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
LOG_LEVEL=debug
```

### 3.2 Python Intent Engine (`services/intent-engine/.env`)
```env
PORT=8000
OPENAI_API_KEY=sk-...
WHISPER_MODEL=whisper-1
LLM_MODEL_FAST=gpt-4o-mini
LLM_MODEL_COMPLEX=gpt-4o
NEXUS_API_URL=http://localhost:4000/graphql
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
LOG_LEVEL=debug
```

### 3.3 Node.js Nexus API (`services/nexus-api/.env`)
```env
PORT=4000
DATABASE_URL=postgresql://postgres:password@localhost:5432/verve_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-jwt-secret-here
PAYSTACK_SECRET_KEY=sk_test_...
FLUTTERWAVE_SECRET_KEY=FLWSECK_TEST-...
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
NODE_ENV=development
```

### 3.4 Flutter Apps (`apps/mobile/.env` and `apps/rider/.env`)
```env
ORCHESTRATOR_WS_URL=ws://10.0.2.2:8080/ws
NEXUS_API_URL=http://10.0.2.2:4000/graphql
ENVIRONMENT=development
```

## 4. Docker Compose (Production)

```yaml
# docker-compose.prod.yml
version: '3.9'
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: verve
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  orchestrator:
    build: ./services/orchestrator
    ports:
      - "8080:8080"
    depends_on: [redis]
    env_file: ./services/orchestrator/.env

  intent-engine:
    build: ./services/intent-engine
    ports:
      - "8000:8000"
    env_file: ./services/intent-engine/.env

  nexus-api:
    build: ./services/nexus-api
    ports:
      - "4000:4000"
    depends_on: [postgres, redis]
    env_file: ./services/nexus-api/.env

volumes:
  pgdata:
```

## 5. CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/ci.yml
name: Verve CI
on: [push, pull_request]
jobs:
  lint-go:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with: { go-version: '1.22' }
      - run: cd services/orchestrator && go build ./...
      - run: cd services/orchestrator && go test ./...

  lint-python:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: '3.11' }
      - run: cd services/intent-engine && pip install -r requirements.txt
      - run: cd services/intent-engine && python -m pytest

  lint-node:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: cd services/nexus-api && npm ci
      - run: cd services/nexus-api && npm run build
      - run: cd services/nexus-api && npm test

  lint-flutter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.0' }
      - run: cd apps/mobile && flutter pub get && flutter analyze
      - run: cd apps/rider && flutter pub get && flutter analyze

  build-apk:
    needs: lint-flutter
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.0' }
      - run: cd apps/mobile && flutter build apk --debug
      - uses: actions/upload-artifact@v4
        with: { name: verve-consumer-apk, path: apps/mobile/build/app/outputs/flutter-apk/ }
```

## 6. Testing Strategy

| Layer | Framework | Type | Coverage Target |
|-------|-----------|------|-----------------|
| Flutter | `flutter_test` + `mocktail` | Unit + Widget | 70% |
| Go | `testing` + `testify` | Unit + Integration | 80% |
| Python | `pytest` + `httpx` | Unit + API | 75% |
| Node.js | `jest` + `supertest` | Unit + Integration | 75% |
| E2E | Maestro (mobile) | Flows | Critical paths |

## 7. Build Commands Quick Reference

```bash
# Flutter Consumer
cd apps/mobile && flutter build apk --debug
cd apps/mobile && flutter build apk --release

# Flutter Rider
cd apps/rider && flutter build apk --debug

# Go Orchestrator
cd services/orchestrator && go build -o orchestrator .

# Python Intent Engine
cd services/intent-engine && python -m pytest

# Node.js Nexus API
cd services/nexus-api && npm run build
cd services/nexus-api && npm test
```

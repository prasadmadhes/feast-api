# Feast API - Project Guide

## Overview
Feast is a restaurant order management system backend built with FastAPI, SQLModel, and PostgreSQL.

## Tech Stack
- **Framework**: FastAPI 0.119.x
- **ORM**: SQLModel 0.0.27 (SQLAlchemy 2.x + Pydantic)
- **Database**: PostgreSQL (psycopg2-binary)
- **Server**: Uvicorn (ASGI)
- **Config**: python-dotenv
- **Python**: >=3.12
- **Package Manager**: Poetry (poetry-core 2.x)
- **Formatter**: black

## Commands
```bash
# Install dependencies
poetry install

# Run dev server
uvicorn main:app --reload --port 8000

# Format code
poetry run black .

# Run tests
poetry run pytest

# Add a dependency
poetry add <package>

# Add a dev dependency
poetry add --group dev <package>
```

## Project Structure
```
feast-api/
├── main.py              # FastAPI app entry point
├── app/
│   ├── __init__.py
│   ├── config.py        # Settings & env config
│   ├── database.py      # DB engine & session
│   ├── models/          # SQLModel table definitions
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── restaurant.py
│   │   ├── menu.py
│   │   └── order.py
│   ├── schemas/          # Pydantic request/response schemas
│   │   ├── __init__.py
│   │   ├── user.py
│   │   ├── restaurant.py
│   │   ├── menu.py
│   │   └── order.py
│   ├── routers/          # API route handlers
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── users.py
│   │   ├── restaurants.py
│   │   ├── menus.py
│   │   └── orders.py
│   ├── services/         # Business logic layer
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── user.py
│   │   ├── restaurant.py
│   │   ├── menu.py
│   │   └── order.py
│   └── dependencies.py  # FastAPI dependency injection
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   └── ...
├── alembic/              # DB migrations
│   ├── env.py
│   └── versions/
├── alembic.ini
├── pyproject.toml
├── poetry.lock
├── .env                  # Local env vars (not committed)
├── .env.example          # Template for .env
└── CLAUDE.md
```

## Conventions

### Code Style
- Use `black` for formatting (default config)
- Type hints on all function signatures
- Use `async def` for route handlers that do I/O
- Docstrings only where logic is non-obvious

### API Design
- RESTful endpoints under `/api/v1/` prefix
- Resource naming: plural nouns (e.g., `/api/v1/restaurants`)
- Use HTTP status codes correctly (201 for creation, 204 for deletion, etc.)
- Return consistent JSON response shapes
- Use FastAPI's `HTTPException` for error responses
- Pagination via `skip` and `limit` query params

### Database & Models
- SQLModel for table models (combines SQLAlchemy + Pydantic)
- Separate read/create/update schemas from table models
- Use Alembic for migrations — never modify DB schema manually
- All tables should have `id`, `created_at`, `updated_at` columns
- Use UUID for primary keys
- Foreign keys with proper relationships

### Architecture
- **Routers** → thin, handle HTTP concerns only (validation, status codes)
- **Services** → business logic, called by routers
- **Models** → database table definitions
- **Schemas** → request/response Pydantic models
- Dependency injection via FastAPI's `Depends()`
- Database sessions via dependency injection

### Environment
- All secrets/config in `.env` file
- Never hardcode database URLs, API keys, or secrets
- Use `pydantic-settings` or `python-dotenv` for config

### Testing
- pytest with httpx `AsyncClient` for API tests
- Test files mirror source structure: `tests/test_<module>.py`
- Use fixtures in `conftest.py` for DB session, test client, etc.

### Git
- Conventional commit messages: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`
- Keep commits focused and atomic

## Domain Context
Feast manages:
- **Users**: Customers and restaurant owners/staff
- **Restaurants**: Restaurant profiles, hours, locations
- **Menus**: Menu items with categories, prices, availability
- **Orders**: Customer orders with items, status tracking, payments

# Feast API

Backend for a restaurant order management system.

## Tech Stack

- **FastAPI** - Web framework
- **SQLModel** - ORM (SQLAlchemy + Pydantic)
- **PostgreSQL** - Database
- **Poetry** - Dependency management
- **Uvicorn** - ASGI server

## Setup

### Prerequisites

- Python 3.12+
- PostgreSQL
- Poetry

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd feast-api

# Install dependencies
poetry install

# Copy environment template
cp .env.example .env
# Edit .env with your database credentials

# Run database migrations
poetry run alembic upgrade head

# Start development server
uvicorn main:app --reload --port 8000
```

### Environment Variables

Create a `.env` file from `.env.example`:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/feast
SECRET_KEY=your-secret-key
DEBUG=true
```

## API Endpoints

Base URL: `http://localhost:8000/api/v1`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Welcome message |
| GET | `/health` | Health check |
| GET | `/about` | App info |

## Development

```bash
# Format code
poetry run black .

# Run tests
poetry run pytest

# Run tests with coverage
poetry run pytest --cov=app
```

## Project Structure

```
feast-api/
├── main.py           # App entry point
├── app/
│   ├── config.py     # Settings
│   ├── database.py   # DB connection
│   ├── models/       # SQLModel tables
│   ├── schemas/      # Request/response models
│   ├── routers/      # API routes
│   └── services/     # Business logic
├── tests/            # Test suite
├── alembic/          # DB migrations
└── pyproject.toml    # Dependencies
```

## License

Private

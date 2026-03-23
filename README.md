# README

# Quote App

A Monolithic Ruby on Rails application for importing and displaying energy supplier quote data from CSV files.

## Tech Stack

- **Backend:** Ruby on Rails 7, Ruby 3.2
- **Database:** PostgreSQL 14
- **Containerization:** Docker + Docker Compose

## Prerequisites

- [Docker](https://www.docker.com/get-started) and Docker Compose

## Quick Start
```bash
git clone <your-repo-url>
cd quote-portal
docker compose up --build
```

Visit http://localhost:3000

## Usage

1. Click **Import CSV** in the navigation
2. Upload your `quotes.csv` file
3. View imported records on the All Quotes page
4. Repeats will update records

## Expected CSV Format
```csv
"Customer","Supplier","Quote","Tax Included","State","Tax Rate"
"Acme Corp","Supplier A",0.0662,"Y","MA",7.5
```

## Running Tests
```bash
docker compose exec web bundle exec rspec --format documentation
docker compose exec -e RAILS_ENV=test web bundle exec rspec --format documentation
```

## Environment Variables

| Variable | Description |
|---|---|
| POSTGRES_DB | Database name |
| POSTGRES_USER | Database user |
| POSTGRES_PASSWORD | Database password |
| RAILS_MASTER_KEY | Rails credentials key |
| RAILS_ENV | Rails environment |

> In production, use a secrets manager such as HashiCorp Vault or AWS Secrets Manager instead of a `.env` file.

## Development

Run without Docker:
```bash
bundle install
rails db:create db:migrate
rails server
```
## Command used to generate Quote model
rails g scaffold Quote customer:string supplier:string quote:decimal tax_included:boolean state:string tax_rate:decimal

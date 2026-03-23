# README

# Quote App

Quote App is a Ruby on Rails application for importing and displaying energy supplier quote data from CSV files. The application is containerized with Docker and uses PostgreSQL as its database.

## Tech Stack

- Ruby 3.2.8
- Ruby on Rails 7.2.3
- PostgreSQL 14
- Docker / Docker Compose
- RSpec

## Prerequisites

- Docker and Docker Compose

## GIT Quick Start
```bash
git clone https://github.com/jlturner9212/quote_app
cd quote_app
docker compose up --build
```

## ZIP Quick Start
```bash
unzip quote_app.zip
cd quote_app
docker compose up --build
```

Visit http://localhost:3000

## Usage

1. Click **Import CSV** at the top of the page
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

## Development architecture approach and decisions
Rails monolith app no reason to deviate
service for handling csv import
validations on the quote model and database

## Assumptions and tradeoffs
Keep it simple and only use gems as necessary
uploading the list again should allow updates to quotes


## Command used to generate Quote model
rails g scaffold Quote customer:string supplier:string quote:decimal tax_included:boolean state:string tax_rate:decimal

## Validations
presence of customer and supplier
positive numeric quote value
boolean tax_included value
two-character state code
non-negative tax rate
uniqueness of supplier scoped to customer and state
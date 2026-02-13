# SolidBro

A web UI dashboard for managing SolidQueue jobs, queues, workers, and recurring tasks in Rails applications.

## Features

- **Job Management**: View all jobs with filtering by class name, queue name, and date ranges
- **Job Scopes**: Filter by status (All, Failed, In Progress, Blocked, Scheduled, Finished)
- **Pagination**: Built-in pagination using Pagy
- **Queue Management**: View queues with job counts
- **Worker Monitoring**: Monitor SolidQueue worker processes
- **Recurring Tasks**: View and manage recurring job tasks
- **Job Details**: Detailed job view with formatted arguments and exception information

## Installation

Add this line to your application's Gemfile:

```ruby
gem "solid_bro"
```

And then execute:
```bash
$ bundle install
```

## Setup

### 1. Mount the Engine

Add the engine to your main application's routes file (`config/routes.rb`):

```ruby
Rails.application.routes.draw do
  # Your existing routes...
  
  mount SolidBro::Engine => "/solid_bro"
end
```

This will make the dashboard available at `/solid_bro` in your application.

### 2. Configure SolidQueue (if not already done)

Make sure SolidQueue is configured in your application. Add to `config/application.rb`:

```ruby
config.active_job.queue_adapter = :solid_queue
```

### 3. Run Migrations

Ensure SolidQueue migrations are run:

```bash
rails solid_queue:install:migrations
rails db:migrate
```

## Usage

Once mounted, access the dashboard at:

- **Jobs**: `/solid_bro/jobs` (or `/solid_bro/` as the root)
- **Queues**: `/solid_bro/queues`
- **Workers**: `/solid_bro/workers`
- **Recurring Tasks**: `/solid_bro/recurring-tasks`

### Job Filtering

The jobs index supports filtering by:
- **Job class name**: Case-insensitive partial match
- **Queue name**: Case-insensitive partial match
- **Date range**: Filter by created_at (for all/failed/in_progress/blocked/scheduled) or finished_at (for finished jobs)

### Job Actions

- **Retry**: Retry a failed job (available on failed jobs)
- **Discard**: Delete a job from the queue

## Requirements

- Rails >= 7.0
- SolidQueue gem
- Pagy >= 8.0

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

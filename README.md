# pton.co [![Build Status](https://travis-ci.org/casey-chow/pton.co.svg?branch=master)](https://travis-ci.org/casey-chow/pton.co) [![codecov](https://codecov.io/gh/casey-chow/pton.co/branch/master/graph/badge.svg)](https://codecov.io/gh/casey-chow/pton.co) [![Inline docs](http://inch-ci.org/github/casey-chow/pton.co.svg)](http://inch-ci.org/github/casey-chow/pton.co)

pton.co is intended to be a simple URL shortener service for the Princeton community.

## Setup

This assumes you already have [Elixir](https://elixir-lang.org/install.html) installed
and a default Postgres setup.

```sh
mix deps.get
mix ecto.create
mix ecto.migrate
cd assets && npm install
cd ..
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

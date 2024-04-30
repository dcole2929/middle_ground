# Use an official Elixir runtime as a parent image
FROM elixir:1.13-alpine

# Install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install dependencies
RUN mix deps.get

# Compile the project
RUN mix do compile

# Expose port 4000 to the outside world
EXPOSE 4000

# Run the Phoenix server
CMD ["mix", "phx.server"]
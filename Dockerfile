FROM ruby:3.2

WORKDIR /app

# Copiar solo el Gemfile
COPY Gemfile ./

# Instalar dependencias
RUN bundle install

# Copiar el resto de la app
COPY . .

EXPOSE 4567

CMD ["ruby", "app.rb", "-p", "4567", "-o", "0.0.0.0"]

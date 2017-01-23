FROM ruby:2.4

# System dependencies: Add here any librairies needed for certain gems
RUN apt-get update \
  && apt-get install -y libpq-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Application working directory
WORKDIR /home/dovico

# WARNING The following line is important to keep bundle config
# inside the app directory
ENV  BUNDLE_APP_CONFIG /home/dovico/.bundle/
# Copy dependency file
COPY ./dovico-client.gemspec /home/dovico/dovico-client.gemspec
COPY ./lib/dovico/version.rb /home/dovico/lib/dovico/version.rb
COPY ./Gemfile /home/dovico/Gemfile

# Bundle
RUN bundle install

# Copy code
COPY ./ /home/dovico

# What to launch on container startup
ENTRYPOINT ["make"]
CMD        ["run"]

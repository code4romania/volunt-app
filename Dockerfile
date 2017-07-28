FROM ruby:2.4

# The home directory of the application.
#
# During development, make sure that the APP_DIR environment variable is
# identical to the variable in your docker-compose.override.yml file,
# otherwise things might not work as expected.
ENV APP_DIR="/opt/volunt-app"

# Create a non-root user
RUN groupadd -r app \
    && useradd -m -r -g app app
RUN mkdir -p ${APP_DIR} \
    && chown -R app:app ${APP_DIR}

USER app

# Move the the application folder to perform all the following tasks.
WORKDIR ${APP_DIR}

# Copy the Gemfile and Gemfile.lock files so `bundle install` can run when the
# container is initialized.
#
# The added benefit is that Docker will cache this file and will not trigger
# the bundle install unless the Gemfile changed on the filesystem.
COPY Gemfile* ./
RUN bundle install --jobs 4 --retry 5 --path ${HOME}/.bundle --binstubs

# Copy over the files, in case the Docker Compose file does not specify a
# mount point.
COPY . .

# Setup the Rails app to run when the container is created, using the CMD as
# extra params that can be overriden via the command-line or docker-compose.yml
#
# In this case, we're prefixing everything with `bundle exec` so we don't have
# to do this every time we start the container or when running commands.
ENTRYPOINT [ "bundle", "exec" ]
CMD [ "puma", "-C", "config/puma.rb" ]
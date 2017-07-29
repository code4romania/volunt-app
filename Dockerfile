FROM ruby:2.4

# Bundler options
#
# The default value is taken from Heroku's build options, so they should be
# good enough for most cases. For development, be sure to set a blank default
# in docker-compose.override.yml.
ARG bundler_opts="--without development:test \
                  --jobs 4 \
                  --deployment"

# The home directory of the application.
#
# During development, make sure that the APP_DIR environment variable is
# identical to the variable in your docker-compose.override.yml file,
# otherwise things might not work as expected.
ENV APP_DIR="/opt/voluntapp"

RUN groupadd -r app \
    && useradd -m -r -g app app \
    && mkdir -p ${APP_DIR}/tmp/pids

# Move the the application folder to perform all the following tasks.
WORKDIR ${APP_DIR}

# Copy the Gemfile and Gemfile.lock files so `bundle install` can run when the
# container is initialized.
#
# The added benefit is that Docker will cache this file and will not trigger
# the bundle install unless the Gemfile changed on the filesystem.
COPY Gemfile* ./
RUN bundle install ${bundler_opts}

# Copy over the files, in case the Docker Compose file does not specify a
# mount point.
#
# NOTE There is a bug in the way COPY works so it ignores the USER directive.
# The bottom line is that all the files will be copied as root anyway so it's
# better to change to the right user afterwards.
COPY . ./

# Change the ownership of all the app files to the app user so we can start
# the process as a regular user, not as root.
RUN chown -R app:app ${APP_DIR}

USER app:app

# Setup the Rails app to run when the container is created, using the CMD as
# extra params that can be overriden via the command-line or docker-compose.yml
#
# In this case, we're prefixing everything with `bundle exec` so we don't have
# to do this every time we start the container or when running commands.
ENTRYPOINT [ "bundle", "exec" ]
CMD [ "puma", "-C", "config/puma.rb" ]
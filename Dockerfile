FROM ruby:3.1

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		postgresql-client \
		nodejs \
	&& rm -rf /var/lib/apt/lists/*

RUN bundle config --global frozen 1

RUN gem install bundler

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg && \
    curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | apt-key add - && \
    echo "deb https://packages.doppler.com/public/cli/deb/debian any-version main" | tee /etc/apt/sources.list.d/doppler-cli.list && \
    apt-get update && \
    apt-get -y install doppler


## This works. cmd, no entrypoint
# CMD ["doppler", "run", "rake"]
##

#ENTRYPOINT ["/bin/bash", "-c"]
#CMD ["rake"]
#CMD "doppler run rake"

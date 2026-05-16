FROM ruby

RUN apt-get update && apt-get install -y nodejs
RUN gem install jekyll

ADD . /code
WORKDIR /code

CMD ["jekyll", "serve", "--host", "0.0.0.0", "--force_polling"]

EXPOSE 4000

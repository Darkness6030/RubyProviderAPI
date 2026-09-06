FROM ruby:3.4-alpine

WORKDIR /app
COPY bin ./bin
COPY lib ./lib
COPY test ./test
COPY examples/novapay/*.yaml ./examples/novapay/

RUN addgroup -S app && adduser -S app -G app && chown -R app:app /app
USER app

ENTRYPOINT ["ruby", "/app/bin/integrate"]
CMD ["--help"]

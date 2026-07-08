FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       sbcl \
       curl \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Quicklisp and Hunchentoot at image build time.
RUN curl -fsSL -o /tmp/quicklisp.lisp https://beta.quicklisp.org/quicklisp.lisp \
    && sbcl --noinform \
         --load /tmp/quicklisp.lisp \
         --eval "(quicklisp-quickstart:install)" \
         --eval "(ql:quickload :hunchentoot)" \
         --eval "(ql:add-to-init-file)" \
         --quit \
    && rm -f /tmp/quicklisp.lisp

WORKDIR /app/src
COPY src/ ./

# Render injects PORT; web_server.lisp reads it from the environment.
EXPOSE 8766

CMD ["sbcl", "--noinform", "--script", "main.lisp", "--web"]

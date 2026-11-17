#!/usr/bin/env python3
"""Local test listener. Binds 127.0.0.1 only and prints whatever it receives."""
import http.server


class Handler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        print(f"RECEIVED {len(body)} bytes:\n{body.decode(errors='replace')}", flush=True)
        self.send_response(204)
        self.end_headers()

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    print("listening on 127.0.0.1:8099", flush=True)
    http.server.HTTPServer(("127.0.0.1", 8099), Handler).serve_forever()

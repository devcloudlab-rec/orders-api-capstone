# orders-api

Small FastAPI orders service backed by sqlite.

## Run the tests

```bash
uv sync
uv run pytest -q
```

## Endpoints

- `GET /orders` lists the twenty seed orders
- `GET /orders/search?customer=` finds orders by customer name
- `GET /orders/{id}` fetches one order

Terraform for the export bucket lives in `infra/`.

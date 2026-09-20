FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_DEBUG=1
ENV DJANGO_ALLOWED_HOSTS=*
ENV POETRY_VERSION=1.8.5

WORKDIR /app

RUN pip install --no-cache-dir "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock ./

RUN poetry install \
    --only main \
    --no-root \
    --no-interaction \
    --no-ansi

COPY mysite ./mysite

WORKDIR /app/mysite

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn mysite.wsgi:application --bind 0.0.0.0:8000"]

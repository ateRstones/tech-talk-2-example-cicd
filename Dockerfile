FROM python:3.13

WORKDIR /app

COPY src/ /app
COPY requirements.txt /app/requirements.txt

RUN pip install -r /app/requirements.txt

CMD ["python", "-u", "app.py"]

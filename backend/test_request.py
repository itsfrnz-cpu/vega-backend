import requests

response = requests.post(
    "http://127.0.0.1:8000/chat",
    json={
        "message": "بیا روی پروژه‌مون کار کنیم"
    }
)

print("STATUS:", response.status_code)
print("TEXT:")
print(response.text)
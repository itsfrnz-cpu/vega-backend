from openai import OpenAI

client = OpenAI(
    base_url="https://api.avalai.ir/v1",
    api_key="aa-cyxtXkL0lzJlhYdFeMkIJFoASin9OhIUPbYr9kB1NwsZlyTo"
)

response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {
            "role": "user",
            "content": "سلام، خودت را معرفی کن."
        }
    ]
)

print(response.choices[0].message.content)
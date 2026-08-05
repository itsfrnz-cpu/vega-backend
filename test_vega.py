from openai import OpenAI


with open("prompts/vega_system.txt", "r", encoding="utf-8") as f:
    VEGA_SYSTEM_PROMPT = f.read()


client = OpenAI(
    base_url="https://api.avalai.ir/v1",
    api_key="aa-cyxtXkL0lzJlhYdFeMkIJFoASin9OhIUPbYr9kB1NwsZlyTo"
)


response = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {
            "role": "system",
            "content": VEGA_SYSTEM_PROMPT
        },
        {
            "role": "user",
            "content": "سلام، خودت رو معرفی کن."
        }
    ]
)


print(response.choices[0].message.content)
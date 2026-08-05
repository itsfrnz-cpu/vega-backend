import json


def parse_memory(response):
    try:
        data = json.loads(response)

        if data.get("remember"):
            if "category" not in data or "value" not in data:
                return {
                    "remember": False
                }

        return data

    except:
        return {
            "remember": False
        }
from openai import OpenAI


def should_remember(client: OpenAI, text: str):
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            temperature=0,
            response_format={"type": "json_object"},
            messages=[
                {
                    "role": "system",
                    "content": """
You decide whether a user's message should be stored as long-term memory.

Return ONLY JSON.

Example:

{
  "remember": true,
  "operations": [
    {
      "type": "add_preference",
      "section": "favorite_music",
      "value": "Taylor Swift"
    },
    {
      "type": "update_profile",
      "field": "language",
      "value": "Persian"
    }
  ]
}

Possible categories:

likes
dislikes
projects
goals
facts
preferences

If nothing is worth remembering:

{
  "remember": false
}
"""
                },
                {
                    "role": "user",
                    "content": text
                }
            ]
        )

        print(response.choices[0].message.content)

        return parse_memory(
            response.choices[0].message.content
        )

    except Exception as e:
        print("MEMORY_AI ERROR:", repr(e))
        raise
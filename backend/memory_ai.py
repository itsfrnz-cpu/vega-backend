import json


def parse_memory(response):
    try:
        return json.loads(response)
    except:
        return {
            "remember": False
        }
from openai import OpenAI


def should_remember(client: OpenAI, text: str):
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
  "category": "likes",
  "value": "Taylor Swift"
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

    return parse_memory(
        response.choices[0].message.content
    )
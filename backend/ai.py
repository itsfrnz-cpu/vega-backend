from openai import OpenAI
from config import AVALAI_API_KEY, AVALAI_BASE_URL
from memory import add_memory
from memory_ai import should_remember
from memory_search import get_relevant_memory

client = OpenAI(
    base_url=AVALAI_BASE_URL,
    api_key=AVALAI_API_KEY,
)
from pathlib import Path

PROMPT_PATH = Path(__file__).parent.parent / "prompts" / "vega_system.txt"


def load_prompt():
    return PROMPT_PATH.read_text(encoding="utf-8")


def chat(message: str):

    prompt = load_prompt()

    memory_result = should_remember(client, message)

    print("MEMORY RESULT:", memory_result)

    if memory_result.get("remember"):
        add_memory(
            memory_result["category"],
            memory_result["value"]
        )

    relevant_memory = get_relevant_memory(message)

    full_prompt = prompt

    if relevant_memory:
        full_prompt += (
            "\n\nMemory about Farnaz:\n"
            + str(relevant_memory)
        )

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": full_prompt,
            },
            {
                "role": "user",
                "content": message,
            },
        ],
    )

    return response.choices[0].message.content
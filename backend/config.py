from dotenv import load_dotenv
import os

load_dotenv()

AVALAI_BASE_URL = os.getenv("AVALAI_BASE_URL")
AVALAI_API_KEY = os.getenv("AVALAI_API_KEY")
import requests
import time
import re
from bs4 import BeautifulSoup

DEFAULT_BASE_URL = "https://nexa.zdelar.com"

ROOT_PAGES = [
    "/",
    "/movies",
    "/shows",
    "/latest",
]

visited = set()


def fetch(path):
    url = BASE_URL + path
    print(f"Visiting: {url}")

    try:
        res = requests.get(url, timeout=10)
        res.raise_for_status()
        return res.text
    except Exception as e:
        print(f"Failed: {url} -> {e}")
        return None


def extract_links(html):
    soup = BeautifulSoup(html, "html.parser")
    links = set()

    for a in soup.find_all("a", href=True):
        href = a["href"]

        match = re.match(r"^/(movies|shows)/(\d+)", href)
        if match:
            links.add(href)

    return links


def main():
    global BASE_URL

    user_input = input(f"Base URL [{DEFAULT_BASE_URL}]: ").strip()
    BASE_URL = user_input or DEFAULT_BASE_URL

    for page in ROOT_PAGES:
        html = fetch(page)
        if not html:
            continue

        links = extract_links(html)

        for link in links:
            if link in visited:
                continue

            visited.add(link)
            fetch(link)
            time.sleep(0.2)


if __name__ == "__main__":
    main()

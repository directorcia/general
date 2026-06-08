import re
import ssl
import urllib.request
from pathlib import Path

path = Path('CSP Masters/M365BP-Addons/resources.txt')
text = path.read_text(encoding='utf-8')
urls = list(dict.fromkeys(re.findall(r'https://[^\s)]+', text)))
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE
print(f'Total unique links: {len(urls)}')
for u in urls:
    try:
        req = urllib.request.Request(u, method='GET', headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, context=ctx, timeout=30) as r:
            print(f'OK {r.getcode()} | {u}')
    except Exception as e:
        print(f'FAIL | {u} | {type(e).__name__}: {e}')

import re
import json

with open("index.html", "r", encoding="utf-8") as f:
    html = f.read()

# Extract MUSICALS_DATA block
start_idx = html.find("const MUSICALS_DATA = [")
end_idx = html.find("];", start_idx)
js_data = html[start_idx:end_idx+2]

# Writing a parser to find objects
# Since it's JS literal array, we can parse it using regex or safe eval
# Let's extract each object using regex of { ... }
objects_raw = re.findall(r'\{\s*id:\s*"([^"]+)",\s*title:\s*"([^"]+)"(.*?)\}(?=\s*,\s*\{|\s*\])', js_data, re.DOTALL)

musicals = []
for obj in objects_raw:
    m_id = obj[0]
    m_title = obj[1]
    body = obj[2]
    
    start_date = re.search(r'startDate:\s*"([^"]+)"', body)
    end_date = re.search(r'endDate:\s*"([^"]+)"', body)
    theaters = re.search(r'theaters:\s*\[([^\]]+)\]', body)
    
    start_val = start_date.group(1) if start_date else ""
    end_val = end_date.group(1) if end_date else ""
    theaters_val = theaters.group(1).replace('"', '').strip() if theaters else ""
    
    musicals.append({
        "id": m_id,
        "title": m_title,
        "startDate": start_val,
        "endDate": end_val,
        "theaters": theaters_val
    })

print(json.dumps(musicals, ensure_ascii=False, indent=2))

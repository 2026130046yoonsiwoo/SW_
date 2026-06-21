import re
import subprocess
import os

try:
    with open('index.html', 'r', encoding='utf-8') as f:
        html = f.read()
    
    scripts = re.findall(r'<script>(.*?)</script>', html, re.DOTALL)
    if not scripts:
        print("No script tags found!")
        sys.exit(1)
        
    js_code = scripts[0]
    
    with open('temp.js', 'w', encoding='utf-8') as f:
        f.write(js_code)
        
    print("JS code extracted to temp.js")
    
    # Use python's compile function to check basic syntax (it won't check JS syntax directly, but we can call node if available)
    # Let's check using node if present
    try:
        res = subprocess.run(['node', '--check', 'temp.js'], capture_output=True, text=True)
        if res.returncode == 0:
            print("Syntax OK (Node)")
        else:
            print("Syntax Error (Node):")
            print(res.stderr)
    except FileNotFoundError:
        print("Node not found, attempting general JS syntax parsing in Python...")
        # Simple bracket matcher
        stack = []
        lines = js_code.split('\n')
        for idx, line in enumerate(lines):
            for char in line:
                if char in '{[(':
                    stack.append((char, idx+1))
                elif char in '}])':
                    if not stack:
                        print(f"Extra closing character '{char}' at line {idx+1}")
                    else:
                        top, line_num = stack.pop()
                        if (char == '}' and top != '{') or (char == ']' and top != '[') or (char == ')' and top != '('):
                            print(f"Mismatched '{top}' (line {line_num}) and '{char}' (line {idx+1})")
        if stack:
            print("Unclosed brackets:")
            for char, line_num in stack[:5]:
                print(f"  '{char}' at line {line_num}")
                
except Exception as e:
    print("Execution failed:", e)

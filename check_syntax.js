const fs = require('fs');

try {
    const html = fs.readFileSync('index.html', 'utf8');
    const startIdx = html.indexOf('<script>');
    const endIdx = html.lastIndexOf('</script>');
    
    if (startIdx === -1 || endIdx === -1) {
        console.log("No script tag found!");
        process.exit(1);
    }
    
    const js = html.substring(startIdx + 8, endIdx);
    fs.writeFileSync('temp.js', js, 'utf8');
    console.log("JS extracted to temp.js");
    
    // Check brackets balance
    const stack = [];
    const lines = js.split('\n');
    let hasMismatches = false;
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        for (let j = 0; j < line.length; j++) {
            const char = line[j];
            if (char === '{' || char === '[' || char === '(') {
                stack.push({ char, line: i + 1 });
            } else if (char === '}' || char === ']' || char === ')') {
                if (stack.length === 0) {
                    console.log(`Extra closing char '${char}' at line ${i + 1}`);
                    hasMismatches = true;
                } else {
                    const top = stack.pop();
                    if ((char === '}' && top.char !== '{') ||
                        (char === ']' && top.char !== '[') ||
                        (char === ')' && top.char !== '(')) {
                        console.log(`Mismatched '${top.char}' (line ${top.line}) and '${char}' (line ${i + 1})`);
                        hasMismatches = true;
                    }
                }
            }
        }
    }
    
    if (stack.length > 0) {
        console.log("Unclosed brackets:");
        stack.slice(0, 10).forEach(item => {
            console.log(`  '${item.char}' at line ${item.line}`);
        });
        hasMismatches = true;
    }
    
    if (!hasMismatches) {
        console.log("Brackets balance: OK");
    } else {
        console.log("Brackets balance: FAILED");
    }
    
    // Try evaluating using new Function (checks syntax)
    try {
        new Function(js);
        console.log("Syntax validation: OK");
    } catch(e) {
        console.log("Syntax validation: FAILED");
        console.error(e);
    }
    
} catch(e) {
    console.log("Failed to run syntax checker:", e);
}

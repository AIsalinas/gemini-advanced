#!/bin/bash
# Test installation simulation

echo "🧪 Testing Gemini Advanced installation..."

# Test 1: Check if repo is accessible
echo -n "1. GitHub repo accessible: "
if curl -s -o /dev/null -w "%{http_code}" https://github.com/tom28881/gemini-advanced | grep -q "200"; then
    echo "✅"
else
    echo "❌ FAILED"
    exit 1
fi

# Test 2: Check if install.sh is downloadable
echo -n "2. Install script downloadable: "
if curl -s -o /dev/null -w "%{http_code}" https://raw.githubusercontent.com/tom28881/gemini-advanced/main/install.sh | grep -q "200"; then
    echo "✅"
else
    echo "❌ FAILED"
    exit 1
fi

# Test 3: Check if main files exist
echo -n "3. Key files present: "
FILES=(
    "install.sh"
    "src/GEMINI.md"
    "bin/g"
    "bin/gth"
    "src/personas/architect.yaml"
)

all_good=true
for file in "${FILES[@]}"; do
    if ! curl -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/tom28881/gemini-advanced/main/$file" | grep -q "200"; then
        echo "❌ Missing: $file"
        all_good=false
    fi
done

if $all_good; then
    echo "✅"
fi

# Test 4: Simulate installation
echo -n "4. Installation simulation: "
TEMP_TEST=$(mktemp -d)
cd "$TEMP_TEST"

# Download and check
if curl -sSL https://raw.githubusercontent.com/tom28881/gemini-advanced/main/install.sh -o install.sh; then
    if [[ -f install.sh ]] && [[ -s install.sh ]]; then
        echo "✅"
    else
        echo "❌ Download failed"
    fi
else
    echo "❌ Curl failed"
fi

cd - > /dev/null
rm -rf "$TEMP_TEST"

echo ""
echo "📊 Summary: If all tests passed, installation should work!"
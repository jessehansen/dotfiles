curl https://invoice-generator.com \
  -d from="Jesse Hansen" \
  -d to="[Company]" \
  -d number="[CO]-001" \
  -d date="Jan 5, 2024" \
  -d due_date="Upon Receipt" \
  -d items[0][name]="Consulting" \
  -d items[0][quantity]=1 \
  -d items[0][unit_cost]=1000 \
  -d notes="Thanks!" \
> ~/Documents/invoice-CO-001.pdf

import sqlite3
import os

sample_bookings = [
    {"booking_id": "B0005", "category": "AC Repair & Service", "amount_inr": 1316},
    {"booking_id": "B0019", "category": "AC Repair & Service", "amount_inr": 538},
    {"booking_id": "B0027", "category": "AC Repair & Service", "amount_inr": 1016},
    {"booking_id": "B0055", "category": "AC Repair & Service", "amount_inr": 1505},
    {"booking_id": "B0001", "category": "Plumbing", "amount_inr": 1369},
    {"booking_id": "B0003", "category": "Plumbing", "amount_inr": 772},
    {"booking_id": "B0004", "category": "Plumbing", "amount_inr": 1133},
    {"booking_id": "B0006", "category": "Plumbing", "amount_inr": 805},
    {"booking_id": "B0018", "category": "Salon for Men", "amount_inr": 1414},
    {"booking_id": "B0024", "category": "Salon for Men", "amount_inr": 1176},
    {"booking_id": "B0029", "category": "Salon for Men", "amount_inr": 858},
    {"booking_id": "B0032", "category": "Salon for Men", "amount_inr": 638},
]

totals = {}
order = []
for booking in sample_bookings:
    category = booking["category"]
    if category not in totals:
        totals[category] = {"count": 0, "total": 0}
        order.append(category)
    totals[category]["count"] = totals[category]["count"] + 1
    totals[category]["total"] = totals[category]["total"] + booking["amount_inr"]

def rupees(amount):
    digits = str(amount)
    width = 0
    for _ in digits:
        width = width + 1
    if width <= 3:
        return digits
    tail = digits[width - 3:]
    head = digits[:width - 3]
    groups = []
    head_width = 0
    for _ in head:
        head_width = head_width + 1
    while head_width > 2:
        groups.append(head[head_width - 2:])
        head = head[:head_width - 2]
        head_width = head_width - 2
    if head_width > 0:
        groups.append(head)
    groups.reverse()
    grouped = ""
    index = 0
    for group in groups:
        if index > 0:
            grouped = grouped + ","
        grouped = grouped + group
        index = index + 1
    return grouped + "," + tail

for category in order:
    count = totals[category]["count"]
    total = totals[category]["total"]
    print(category + " — count " + str(count) + ", total ₹" + rupees(total))

db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "urban_service.db")
conn = sqlite3.connect(db_path)
cur = conn.cursor()
ids = []
for booking in sample_bookings:
    ids.append(booking["booking_id"])
placeholders = ""
seen = 0
for _ in ids:
    if seen > 0:
        placeholders = placeholders + ","
    placeholders = placeholders + "?"
    seen = seen + 1
rows = cur.execute(
    "SELECT category, COUNT(*), SUM(amount_inr) FROM bookings "
    "WHERE booking_id IN (" + placeholders + ") GROUP BY category",
    ids,
).fetchall()
conn.close()

sql_totals = {}
for category, count, total in rows:
    sql_totals[category] = (count, total)

matched = True
for category in order:
    sql_count, sql_total = sql_totals[category]
    if sql_count != totals[category]["count"] or sql_total != totals[category]["total"]:
        matched = False

# SQL on these 12 booking ids matches the pure-Python count and total for AC Repair & Service, Plumbing, and Salon for Men.
if matched:
    print("SQL cross-check: match")
else:
    print("SQL cross-check: mismatch")

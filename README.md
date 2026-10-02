# Urban Company Service-Ops Diagnostic and AI-Augmented Reporting Toolkit

One repository for the capstone. Part A builds the database and exports `city_category_summary.csv`. Part B reconciles that file in `kpi_workbook.xlsx`. Part C is the Tableau Public dashboard. Part D is the prompt pack and the escalation-agent specification.

Reconciled totals, after removing the three test bookings and inserting B9001, B9002, and B9003:

- Bookings: 600
- Revenue: ₹10,47,973
- SLA breaches: 79
- SLA breach rate: 13.2% (79 / 600)

## Tableau Public dashboard

Live dashboard: PASTE_YOUR_TABLEAU_PUBLIC_URL_HERE

The dashboard workbook is `urban_service_dashboard.twbx`. It connects to `city_category_summary.csv` only. Do not connect `bookings.csv`; that file is the pre-clean extract and its revenue is ₹796 off this total.

The workbook already contains:

- Total Revenue ₹10,47,973 and Total Bookings 600 at the top, plus SLA Breach Rate = SUM([sla_breaches]) / SUM([bookings_count]), which is 13.2% on the full extract.
- Parameter Month Focus with January, February, and March, used by the calculated field Month Focus Label. The reconciled extract covers 2026-01, 2026-02, and 2026-03 and has no separate month column, so the parameter labels the month under review.
- Revenue by category, sorted descending.
- A city map. Delhi NCR is plotted on Delhi.
- A City to Category drill-down.
- A city filter on every sheet, with the filter control visible.
- Currency in ₹ only.

Publish it with Tableau Public (the free edition): open `urban_service_dashboard.twbx`, choose Server, then Tableau Public, then Save to Tableau Public, and replace the placeholder above with the public URL.

## Repo map

- `generate_data.py` and the generated `urban_service.db`, `cities.csv`, `categories.csv`, `partners_import.csv`, `bookings.csv`
- `verify_output.txt`, `sanity_check.py`
- `01_dedup_and_joins.sql`, `02_insert_delete.sql`, `city_category_summary.csv`
- `kpi_workbook.xlsx`
- `DASHBOARD_STORY.md`
- `prompt_pack.md`
- `escalation_agent_spec.md`

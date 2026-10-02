# Urban Company Service-Ops Diagnostic and AI-Augmented Reporting Toolkit

One repository for the capstone. Part A builds the database and exports `city_category_summary.csv`. Part B reconciles that file in `kpi_workbook.xlsx`. Part C is the Tableau Public dashboard. Part D is the prompt pack and the escalation-agent specification.

Reconciled totals, after removing the three test bookings and inserting B9001, B9002, and B9003:

- Bookings: 600
- Revenue: ₹10,47,973
- SLA breaches: 79
- SLA breach rate: 13.2% (79 / 600)

## Tableau Public dashboard

Live dashboard: PASTE_YOUR_TABLEAU_PUBLIC_URL_HERE

Build this in Tableau Public (the free edition) from `city_category_summary.csv` only. Do not connect `bookings.csv`; that file is the pre-clean extract and its revenue is ₹796 off this total.

1. Connect to `city_category_summary.csv`. Confirm city and category are dimensions, and bookings_count, revenue_inr, and sla_breaches are measures.
2. Put two text KPIs at the top: Total Revenue ₹10,47,973 and Total Bookings 600, formatted as INR.
3. Calculated field `SLA Breach Rate` = `SUM([sla_breaches]) / SUM([bookings_count])`, formatted as a percentage. On the full extract it is 13.2%. Show it as a third KPI.
4. Create a parameter `Month Focus` with the values January, February, March. Create a calculated field `Month Focus Label` = `[Parameters].[Month Focus]` and place it in the dashboard title so the parameter is in use. The reconciled extract covers booking dates in 2026-01, 2026-02, and 2026-03 and has no separate month column, so the parameter labels the month under review rather than dropping rows.
5. Sheets: a bar chart of total revenue by category sorted descending; a map of total revenue by city, with Delhi NCR matched to Delhi; a City to Category drill-down hierarchy.
6. Add a city filter, show the filter legend, and set it to apply to every sheet on the dashboard.
7. Assemble one dashboard with horizontal and vertical containers, shared fonts and colors, and currency in ₹ or INR only.
8. Share the workbook on Tableau Public and replace the placeholder above with the public URL.

## Repo map

- `generate_data.py` and the generated `urban_service.db`, `cities.csv`, `categories.csv`, `partners_import.csv`, `bookings.csv`
- `verify_output.txt`, `sanity_check.py`
- `01_dedup_and_joins.sql`, `02_insert_delete.sql`, `city_category_summary.csv`
- `kpi_workbook.xlsx`
- `DASHBOARD_STORY.md`
- `prompt_pack.md`
- `escalation_agent_spec.md`

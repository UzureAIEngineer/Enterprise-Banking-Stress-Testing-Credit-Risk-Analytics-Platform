def local_explanation(r):

    stress_pct = (
        (r["stressed_ecl"] - r["base_ecl"])
        / r["base_ecl"]
        * 100
    )

    return f"""
### Portfolio Risk Assessment

The portfolio is classified as **{r['risk_segment']}** under the selected **{r['scenario_name']}** scenario.

Expected Credit Loss (ECL) increases from **INR {r['base_ecl']:,.2f}** to **INR {r['stressed_ecl']:,.2f}**.

This represents a stress impact of **{stress_pct:.2f}%**.

### Key Observation

The stressed scenario indicates increased default risk and reduced recovery assumptions, resulting in higher projected credit losses.

### Recommended Actions

• Continue monitoring higher-risk customer segments.

• Review portfolio concentration across products.

• Reassess mitigation and recovery strategies.

• Perform periodic stress testing and model monitoring.

### Executive Summary

The portfolio remains manageable but demonstrates sensitivity to adverse economic conditions and should remain under enhanced monitoring.
"""


def explain(r):
    return local_explanation(r)
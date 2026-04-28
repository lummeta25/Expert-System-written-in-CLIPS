# Diabetes Expert System (CLIPS)

A rule-based expert system written in CLIPS that assesses a patient's risk of diabetes based on clinical and lifestyle indicators. Patients are flagged as high risk if they meet more than 5 out of 8 diagnostic criteria.

---

## How It Works

The system uses two rules:

**`calculate-BMI`** — fires automatically for any patient entered with a BMI of `0.0`. It computes BMI from weight and height (`weight / height²`) and updates the patient fact in-place. This was an important fix during development — the initial version used `(modify 1 ...)` which hardcoded fact index 1, meaning only the first patient's BMI would update. The corrected version binds the matched fact to `?f` and uses `(modify ?f ...)` so it works for every patient regardless of insertion order.

**`diagnosis`** — fires after BMI is calculated. It counts how many of the 8 risk indicators the patient meets and flags them as high risk if the count exceeds 5.

---

## Diagnostic Criteria

| # | Indicator | Threshold |
|---|---|---|
| 1 | Age | > 25 |
| 2 | BMI | > 28 |
| 3 | Fasting blood sugar | ≥ 126 mg/dL |
| 4 | Family history of diabetes | Yes |
| 5 | Blurred vision | Yes |
| 6 | Tiredness | Yes |
| 7 | Low physical activity (< 3×/week) | Yes |
| 8 | Number of pregnancies | ≥ 3 |

A patient scoring **more than 5** is considered high risk.

---

## Design Decision: Symptom Counting

The initial diagnosis rule required **all** conditions to be met simultaneously. This caused male patients to never be diagnosed — their pregnancy count is always 0, so they could never satisfy the `≥ 3 pregnancies` condition.

The fix was to switch from an AND-all approach to a **symptom count threshold**. Each indicator contributes +1 to a running count, and the pregnancy condition becomes one optional factor rather than a hard requirement. This makes the system gender-neutral while still using pregnancy count as a valid signal for female patients.

---

## Sample Output

With 10 test patients loaded:

```
Patient Jack  has a high risk of diabetes (symptom count: 7).
Patient Carlos has a high risk of diabetes (symptom count: 8).
Patient Sam   has a high risk of diabetes (symptom count: 8).
Patient Nina  has a high risk of diabetes (symptom count: 6).
Patient Amira has a high risk of diabetes (symptom count: 6).
```

Patients like Emily, Lena, Tom, Mike, and Sophie scored ≤ 5 and were correctly not flagged.

---

## Files

| File | Description |
|---|---|
| `Project-C.clp` | Template definition and rules (`calculate-BMI`, `diagnosis`) |
| `project-C-facts.clp` | 10 test patients with pre-set clinical data |

---

## Running the System

1. Open CLIPS
2. Load the rules: `(load "Project-C.clp")`
3. Load the patient facts: `(load "project-C-facts.clp")`
4. Assert each patient fact, then run: `(run)`

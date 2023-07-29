# Thanh-Mai-Bui
Deliverables of programming projects, containing training and practical experiences

When doing Demand Planning Forecast, Demand PLanner needs to check if their forecast number is consistent with Historical Shipment, true order as well as align with Inventory Position.

If the forecast is too high, there is a risk of excess of INV, otherwise, there is a risk of shortage that leads to company's reputation damage.

This macro is used to highlight the forecast number, scanning 12k of SKUs, to find ones that not meet requirements.



We have 5 resulted Colors of Consensus FCST with different meanings as below:


Color & Meaning

Red & FCST = 0
Ended SKUs but FCST <> 0
Ended SKUs but TMD > 0
Pink & FCST = TMD
Avalable SKUs, but TMD >= FCST
Yellow
(only during 1st 15 days of the month)
Available SKUs, but TMD >= 80% of FCST
Orange
(only during last 7 days of the month)
Available SKUs, but TMD <= 70% of FCST
No Color
All above cases with TMD = 0
All other cases

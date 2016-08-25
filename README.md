# Cornerstone Metrics
Contains R calculations for weekly active user counts and percentages. 
## Features:
Allows filtering of internal users.

Allows subsetting of users before carrying out calculations.

## How to use:

Open the script calculate\_WAU\_metrics.r in an R session.

Set script parameters as needed.

Run it.

## Method:

For each week *W* specified in the parameter weeks\_to\_measure, and each champion group *G* (as defined in champion\_groups.csv)
calculate\_WAU\_metrics.r calculates the following:

1. count\_distinct\_existing\_users = The number of users from *G* whose account existed by the end of *W*
2. count\_distinct\_active\_users = The number of users from *G* who were active during week *W*
3. percent\_active\_users =  count\_distinct\_active\_users/count\_distinct\_existing\_users

This calculation is also performed on the set of all users. If the parameter remove\_internal\_users is set to T, then internal users are excluded
from all steps in the calculation.

Once all calculations are finished, a csv containing all results is saved to a location of the users choosing. 
(This option is specified by the save\_location parameter.)

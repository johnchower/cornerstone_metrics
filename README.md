# Cornerstone Metrics
Contains R calculations for weekly active user counts and percentages. 
## How to use:

1. Navigate to the following links, download the data, and place them in the subdirectory .../cornerstone\_metrics/looker\_csvs

  * [https://looker.gloo.us/x/G6PBZMs]
  * [https://looker.gloo.us/sql/k6vmzthtyydyx4]

2. Open the script calculate\_WAU\_metrics.r in an R session.

3. Set script parameters as needed, and save.

4. Run calculate\_WAU\_metrics.r

## Method:

For each week *W* specified in the parameter weeks\_to\_measure, and each champion group *G* (as defined in champion\_groups.csv)
calculate\_WAU\_metrics.r performs the following calculations:

1. count\_distinct\_existing\_users = The number of users from *G* whose account existed by the end of *W*
2. count\_distinct\_active\_users = The number of users from *G* who were active during week *W*
3. percent\_active\_users =  count\_distinct\_active\_users/count\_distinct\_existing\_users

This calculation is also performed on the set of all users. If the parameter remove\_internal\_users is set to T, then internal users are excluded
from all steps in the calculation.

Once all calculations are finished, a csv containing all results is saved to a location 
that the user specifies with the save\_location parameter.

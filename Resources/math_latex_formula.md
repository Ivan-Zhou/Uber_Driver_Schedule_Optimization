$R_{ij}=P(\text{new trip}) * \text{Minimum Number of Trips}$



$\text{Minimum Number of Trips} = \frac{7200s}{\text{Max Duration}}$



| Constraints                              | Explanation                              |
| ---------------------------------------- | ---------------------------------------- |
| $x_{i,j} \leq A_i, \forall i,j$          | Time Availability Constraint             |
| $x_{i,j} \leq B_j, \forall i,j$          | Region Preference Constraint             |
| $\sum_{i,j} x_{i,j}\leq T_{max},\forall i,j$ | Maximum Time Constraint                  |
| $\sum_j x_{i,j} \leq 1, \forall i,j$     | Serve only One Region at a Time          |
| $x_{i,j}\in {0,1}, A_i \in{0,1}, B_j \in{0,1}$ | Boolean Variables                        |
| $i\in I, j\in J$                         | $I$ is the time block set, and $J$ is the region set |



$min_x f^T x$ subject to:

- Elements in $x$ are integers
- $A*x\leq b$
- $Aeq*x = beq$
- $lb \leq x \leq ub$



$P_{\text{New Trip}} = P_{min} + \frac{P_{max}-P_{min}}{D_{max}-D_{min}}-D_{max}*(D_i-D_{min})$






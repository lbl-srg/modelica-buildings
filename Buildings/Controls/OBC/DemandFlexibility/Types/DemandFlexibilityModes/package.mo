within Buildings.Controls.OBC.DemandFlexibility.Types;
package DemandFlexibilityModes "Demand flexibility modes"
  constant Integer default = 1 "Default";
  constant Integer loadRebound = 3 "Load-rebound";
  constant Integer loadShed = 2 "Load-shed";
  constant Integer preCondition = 0 "Pre-condition, including pre-cool and pre-heat";


  annotation (Documentation(revisions="<html>
<ul>
<li>
June 22, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This package provides constants for indicating different demand flexibility
operation modes.
</p>
</html>"));
end DemandFlexibilityModes;

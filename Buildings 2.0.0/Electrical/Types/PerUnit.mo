within Buildings.Electrical.Types;
type PerUnit = Real (final quantity="Per unit", final unit="1", min=0)
  "Used to represent electric quantities with respect to reference value"
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
This type is used to declare whether an electric quantity such as voltage
is expressed in SI units or in per units (i.e., the value divided by its nominal
value).
</html>"));

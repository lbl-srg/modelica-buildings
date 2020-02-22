within Buildings.Applications.DHC.Loads.Types;
type PumpControlType = enumeration(
    ConstantSpeed
    "Constant speed",
    ConstantFlow
    "Constant flow rate (three-way valves)",
    ConstantHead
    "Constant pump head",
    LinearHead
    "Linear relationship between pump head and mass flow rate",
    ConstantDp
    "Constant pressure difference at given location")
  "Enumeration for the type of distribution pump control"
annotation(Documentation(info="<html>
<p>
Enumeration to define the type of distribution pump control.
</p>
</html>",
  revisions=
"<html>
<ul>
<li>
June 25, 2019, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));

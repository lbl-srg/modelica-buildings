within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses;
block WasteHeatEnthalpy
  "Waste heat specific enthalpy calculation"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit="degC")
    "Exhaust gas temperature inlet temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit="degC")
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput hWasHea(
    final unit="J/kg",
    final quantity="SpecificEnthalpy")
    "Waste heat specific enthalpy"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  // Waste heat specific enthalpy calculation:
  // With the exhaust temperature around 300~500 degC and the nominal ambient
  // temperature as 15 degC, the avaeraged specific heat of exhaust is 1.08 kJ/(kg-K),
  // see (Elshamy 2006)
  hWasHea = 1.08e3*(TExh - TAmb);
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 18, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the relative specific enthalpy value of waste heat based on
the ambient conditions.
</p>
<h4>References</h4>
<p>
Aly Elshamy, 2006.
<i><a href=\"file:///Users/jianjunhu/Downloads/malshadadi1,+Journal+manager,+1E.pdf/\">
Condensation Of Flue Gases In Boilers</a></i>.
Journal of Science & Technology Vol. (11) No.(1).
</p>
</html>"));
end WasteHeatEnthalpy;

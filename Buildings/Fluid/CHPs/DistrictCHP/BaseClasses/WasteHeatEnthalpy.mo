within GED.DistrictElectrical.CHP.BaseClasses;
block WasteHeatEnthalpy
  "Waste heat specific enthalpy calculation"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    final unit="degC",
    final quantity = "ThermodynamicTemperature")
    "Exhaust gas temperature inlet temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    final unit="degC",
    final quantity = "ThermodynamicTemperature")
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,
            -60},{-100,-20}}),
                          iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput wasEnt(
    final unit="J/kg",
    final quantity="SpecificEnthalpy")
    "Waste heat specific enthalpy"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

equation
  //Waste heat specific enthalpy calculation
  // Avaeraged specific heat of exhaust is 1.08 kJ/(kg-K)
    wasEnt = 1.08e3*(TExh-TAmb);
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 18, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the relative specific enthalpy value of waste heat based on the ambient conditions.
</p>
</html>"));
end WasteHeatEnthalpy;

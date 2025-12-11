within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses;
block SteamToExhaustMassFlowRatio
  "Ratio of mass flow rate beween the steam and the exhaust"
  extends Modelica.Blocks.Icons.Block;

  parameter Real a_SteMas[3]
    "Coefficients for steam mass flow correlation function";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    displayUnit="degC",
    final unit= "K",
    final quantity= "ThermodynamicTemperature")
    "Exhaust gas temperature inlet temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSte(
    displayUnit="degC",
    final unit= "K",
    final quantity= "ThermodynamicTemperature")
    "Superheated steam temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mu(
    final unit="1")
    "The ratio of the steam and exhaust mass flow rate"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Modelica.Units.NonSI.Temperature_degF TExh_degF
    "Exhaust gas temperature in degree Fahrenheit";
  Modelica.Units.NonSI.Temperature_degF TSte_degF
    "Superheated steam temperature in degree Fahrenheit";

algorithm
  TExh_degF := (TExh-273.15)*(9/5) +32;
  TSte_degF := (TSte-273.15)*(9/5) +32;

equation
  mu =Functions.SteamToExhaustMassFlowRatio(
    a=a_SteMas,
    TExh=TExh_degF,
    TSte=TSte_degF)
   "Ratio of mass flow rate between the steam and the exhaust";

annotation (defaultComponentName="rat",
Documentation(revisions="<html>
<ul>
<li>
March 18, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the ratio of mass flow rate between the steam and the exhaust.
</p>
<p>
It uses the function
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions.SteamToExhaustMassFlowRatio\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions.SteamToExhaustMassFlowRatio</a>
along with unit conversion.
</p>
</html>"));
end SteamToExhaustMassFlowRatio;

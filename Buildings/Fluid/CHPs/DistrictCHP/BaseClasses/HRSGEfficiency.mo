within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses;
block HRSGEfficiency
  "Efficiency of the Heat Recovery Steam Generator"
  extends Modelica.Blocks.Icons.Block;

  parameter Real TSta(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Exhaust stack temperature";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Exhaust gas temperature inlet temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta(final unit="1")
    "Steam turbine electrical generation efficiency"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Modelica.Units.NonSI.Temperature_degF TExh_degF
    "Exhaust gas temperature in degree Fahrenheit";
  Modelica.Units.NonSI.Temperature_degF TSta_degF
    "Exhaust stack temperature in degree Fahrenheit";
  Modelica.Units.NonSI.Temperature_degF TAmb_degF
    "Ambient temperature in degree Fahrenheit";

algorithm
  TExh_degF := (TExh-273.15)*(9/5) +32;
  TSta_degF := (TSta-273.15)*(9/5) +32;
  TAmb_degF := (TAmb-273.15)*(9/5) +32;

equation
  eta = Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions.HRSGEffectiveness(
    TExh=TExh_degF,
    TSta=TSta_degF,
    TAmb=TAmb_degF) "HRSG effectiveness calculation";
annotation (defaultComponentName="effHRSG",
Documentation(info="<html>
<p>
This block calculates the efficiency of the Heat Recovery Steam Generator (HRSG).
</p>
<p>
It uses the function
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions.HRSGEffectiveness\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions.HRSGEffectiveness</a>
along with unit conversion.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 18, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end HRSGEfficiency;

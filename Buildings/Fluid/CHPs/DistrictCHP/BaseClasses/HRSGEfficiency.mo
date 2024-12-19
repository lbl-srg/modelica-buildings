within GED.DistrictElectrical.CHP.BaseClasses;
block HRSGEfficiency
  "A block calculates the efficiency of HRSG"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.NonSI.Temperature_degC TSta
    "Exhaust stack temperature in Celsius";

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
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta_HRSG(
    final unit="1") "Steam turbine electrical generation efficiency"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Modelica.Units.NonSI.Temperature_degF TExh_degF
   "Exhaust gas temperature in degree Fahrenheit";
  Modelica.Units.NonSI.Temperature_degF TSta_degF
   "Exhaust stack temperature in degree Fahrenheit";
   Modelica.Units.NonSI.Temperature_degF TAmb_degF
   "Ambient temperature in degree Fahrenheit";

algorithm
  TExh_degF := TExh*(9/5) +32;
  TSta_degF := TSta*(9/5) +32;
  TAmb_degF := TAmb*(9/5) +32;

equation
  eta_HRSG =Functions.HRSGEffectiveness(
     TExh=TExh_degF,
     TSta=TSta_degF,
     TAmb=TAmb_degF)
    "HRSG effectiveness calculation";
annotation (Documentation(info="<html>
<p>
This block calculates the efficiency of the Heat Recovery Steam Generator (HRSG).
</p>
<p>
It uses the function <code>Functions.HRSGEffectiveness</code> along with unit conversion.
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

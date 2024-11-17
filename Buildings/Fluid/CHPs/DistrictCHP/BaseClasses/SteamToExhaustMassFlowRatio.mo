within GED.DistrictElectrical.CHP.BaseClasses;
block SteamToExhaustMassFlowRatio
  "A block to calculate the ratio of the steam to the exhaust mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  parameter Real a_SteMas[3]
  "Coefficients for steam mass flow correlation function";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    final unit="degC") "Exhaust gas temperature inlet temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mu(
    final unit="1") "The ratio of the steam and exhaust mass flow rate"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSte(
    final unit="degC")
    "Superheated steam temperature"
    annotation (Placement(transformation(extent={{-140,-60},
            {-100,-20}}), iconTransformation(extent={{-140,-60},{-100,-20}})));

protected
  Modelica.Units.NonSI.Temperature_degF TExh_degF
   "Exhaust gas temperature in degree Fahrenheit";
  Modelica.Units.NonSI.Temperature_degF TSte_degF
   "Superheated steam temperature in degree Fahrenheit";

algorithm
  TExh_degF := TExh*(9/5) +32;
  TSte_degF := TSte*(9/5) +32;

equation
  mu =Functions.SteamToExhaustMassFlowRatio(
     a=a_SteMas,
     TExh=TExh_degF,
     TSte=TSte_degF)
   "The ratio of steam and exhaust gas flow rate, which is a function of exhaust temperature";

  annotation (Documentation(revisions="<html>
<ul>
<li>
March 18, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the ratio of the steam to the exhaust mass flow rate.
</p>
<p>
It uses the function <code>Functions.SteamToExhaustMassFlowRatio</code> along with unit conversion.
</p>
</html>"));
end SteamToExhaustMassFlowRatio;

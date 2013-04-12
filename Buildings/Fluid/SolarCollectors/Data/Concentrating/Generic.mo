within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record Generic "SRCC rating information for concentrating collectors"
  extends Modelica.Icons.Record;
  parameter SolarCollectors.Types.Area ATyp "Gross or aperture area";
  parameter SolarCollectors.Types.DesignFluid Fluid
    "Specifies the fluid the heater is designed to use";
  parameter Modelica.SIunits.Area A "Area";
  parameter Modelica.SIunits.Volume V "Fluid volume";
  parameter Modelica.SIunits.Pressure dp_nominal "Pressure drop during test";
  parameter Real VperA_flow_nominal(unit="m/s")
    "Volume flow rate per area of test flow";
  parameter Real y_intercept "F'(ta)_en from ratings data";
  parameter Real IAMDiff
    "Incident angle modifier for diffuse radiation from ratings data";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer C1
    "Heat loss coefficient (C1) from ratings data";
  parameter Real C2(
  final unit = "W/(m2.K2)")
    "Temperature dependence of the heat losses (C2) from ratings data";
  parameter Real B0 "1st incident angle modifier coefficient";
  parameter Real B1 "2nd incident angle modifier coefficient";
  parameter Modelica.SIunits.Mass mDry "Dry weight";
  parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
  annotation (defaultComponentName="gas", Documentation(info="<html>
Generic record for solar information from SRCC certified solar collectors. This generic record is intended for concentrating solar collectors using data collected according to EN12975.
The implementation is according to 
<a href=\"http://www.solar-rating.org/ratings/og100.html\">SRCC OG-100 Directory, 
SRCC Certified Solar Collecotr Ratings</a>.
</html>", revisions="<html>
<ul>
<li>
Feb 28, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"));
end Generic;

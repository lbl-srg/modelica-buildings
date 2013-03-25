within Buildings.Fluid.SolarCollector.Data;
package Concentrating
  extends Modelica.Icons.MaterialPropertiesPackage;
  record GenericConcentrating
    "SRCC rating information for concentrating collectors"
    extends Modelica.Icons.Record;
    parameter Buildings.Fluid.SolarCollector.Types.Area ATyp
      "Gross or aperture area";
    parameter Buildings.Fluid.SolarCollector.Types.DesignFluid Fluid
      "Specifies the fluid the heater is desnigned to use";
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
Generic record for solar information from SRCC certified solar collecotr. This generic record is intended for concentrating solar collectors using data collected according to EN12975.
The implementation is according to 
<a href=\"http://www.solar-rating.org/ratings/og100.html\">SRCC OG-100 Directory, 
SRCC Certified Solar Collecotr Ratings</a>.
</html>",   revisions="<html>
<ul>
<li>
May 24, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
  end GenericConcentrating;

  record SRCC2011127A =
    Buildings.Fluid.SolarCollector.Data.Concentrating.GenericConcentrating (
      ATyp=Buildings.Fluid.SolarCollector.Types.Area.Aperture,
      Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
      A=3.364,
      dp_nominal=1069*1000,
      V= 4.4/1000,
      VperA_flow_nominal=24.1/(10^6),
      y_intercept = 0.720,
      IAMDiff = 0.133,
      C1 = 2.8312,
      C2 = 0.00119,
      B0=0,
      B1=0,
      mDry = 484,
      slope=0) "Cogenra Solar, SunDeck"
      annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011127A.<br>
    </p>
    </html>"));
end Concentrating;

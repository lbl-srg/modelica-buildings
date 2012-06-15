within Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate;
record Generic "SRCC rating information for glazed flat plate"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Area AGro "Gross area";
  parameter Modelica.SIunits.Area AApe "Net aperture area";
  parameter Modelica.SIunits.Mass mDry "Dry weight";
  parameter Modelica.SIunits.Volume V "Fluid volume";
  parameter Modelica.SIunits.Pressure dp_nominal "Test pressure";
  parameter Real VperA_flow_nominal(unit="m/s")
    "Volume flow rate per gross area of test flow";
  parameter Real C0 "1st collector constant in [-] for efficiency equation";
  parameter Real C1
    "2nd collector constant in W/(m2.K )for efficiency equation";
  parameter Real C2
    "3rd collector constant in W/(m2.K2) for efficiency equation";
  parameter Real B0 "1st incident angle modifer coefficient";
  parameter Real B1=0 "2nd incident angle modifer coefficient";

  annotation (defaultComponentName="gas", Documentation(info="<html>
Generic record for solar information from SRCC certified solar collecotr.
The implementation is according to 
<a href=\"http://www.solar-rating.org/ratings/og100.html\">SRCC OG-100 Directory, 
SRCC Certified Solar Collecotr Ratings</a>.
</html>", revisions="<html>
<ul>
<li>
May 24, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end Generic;

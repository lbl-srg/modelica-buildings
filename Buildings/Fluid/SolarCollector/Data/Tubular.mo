within Buildings.Fluid.SolarCollector.Data;
package Tubular
extends Modelica.Icons.MaterialPropertiesPackage;
  record GenericTubular "SRCC rating information for tubular collectors"
    extends Modelica.Icons.Record;
    parameter Buildings.Fluid.SolarCollector.Types.Area ATyp "Gross, Aperture";
    parameter Buildings.Fluid.SolarCollector.Types.DesignFluid Fluid
      "Specifies the fluid the heater is desnigned to use";
    parameter Modelica.SIunits.Area A "Area";
    parameter Modelica.SIunits.Mass mDry "Dry weight";
    parameter Modelica.SIunits.Volume V "Fluid volume";
    parameter Modelica.SIunits.Pressure dp_nominal "Pressure drop during test";
    parameter Real VperA_flow_nominal(unit="m/s")
      "Volume flow rate per area of test flow";
    parameter Real B0 "1st incident angle modifier coefficient";
    parameter Real B1=0 "2nd incident angle modifer coefficient";
    parameter Real y_intercept "Y intercept (Maximum efficiency)";
    parameter Real slope(unit = "W/(m2.K)") "Slope from rating data";
    parameter Real IAMDiff "Incidence angle modifier from EN12975 ratings data";
    parameter Real C1 "Heat loss coefficient from EN12974 ratings data";
    parameter Real C2
      "Temperature dependance of heat loss from EN12975 ratings data";
    annotation (defaultComponentName="gas", Documentation(info="<html>
Generic record for solar information from SRCC certified solar collectosr. This generic record is intended for tubular collectors using data collected according to ASHRAE93.
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
  end GenericTubular;

  record SRCC2012033A =
      Buildings.Fluid.SolarCollector.Data.Tubular.GenericTubular (
      ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
      Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
      A=4.673,
      mDry=111,
      V=2.3/1000,
      dp_nominal=1*1000,
      VperA_flow_nominal=20.1/(10^6),
      B0=1.3766,
      B1=-0.9294,
      y_intercept = 0.422,
      slope= - 1.864,
      IAMDiff = 0,
      C1 = 0,
      C2 = 0) "G.S. Inc., Suntask, SR30"
      annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012033A.<br>
    </p>
    </html>"));
  record SRCC2012019C =
      Buildings.Fluid.SolarCollector.Data.Tubular.GenericTubular (
      ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
      Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
      A=2.345,
      mDry=46,
      V=0.9/1000,
      dp_nominal=900*1000,
      VperA_flow_nominal=19.9/(10^6),
      B0=0.8413,
      B1=-0.5805,
      y_intercept = 0.446,
      slope= - 1.635,
      IAMDiff = 0,
      C1 = 0,
      C2 = 0) "Zhejiang Gaodele New Energy Co, Gaodele, GDL-SP58-1800-15"
      annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012019C.<br>
    </p>
    </html>"));
  record SRCC2012005D =
      Buildings.Fluid.SolarCollector.Data.Tubular.GenericTubular (
      ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
      Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
      A=3.431,
      mDry=73,
      V=2/1000,
      dp_nominal=900*1000,
      VperA_flow_nominal=11.1/(10^6),
      B0=1.1803,
      B1=-0.762,
      y_intercept = 0.371,
      slope= - 1.225,
      IAMDiff = 0,
      C1 = 0,
      C2 = 0) "Westech Solar Technology Wuxi Co, Westech, WT-B58-20"
      annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012005D.<br>
    </p>
    </html>"));
  record SRCC2011133G =
      Buildings.Fluid.SolarCollector.Data.Tubular.GenericTubular (
      ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
      Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
      A=3.624,
      mDry=68,
      V=2.6/1000,
      dp_nominal=900*1000,
      VperA_flow_nominal=17.9/(10^6),
      B0=0.125,
      B1=-0.0163,
      y_intercept = 0.609,
      slope= - 1.051,
      IAMDiff = 0,
      C1 = 0,
      C2 = 0) "Evosolar, EVOT-21"
      annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011133G.<br>
    </p>
    </html>"));
  record SRCC2011125E =
      Buildings.Fluid.SolarCollector.Data.Tubular.GenericTubular (
      ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
      Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
      A=3.860,
      mDry=77,
      V=2.6/1000,
      dp_nominal=900*1000,
      VperA_flow_nominal=8.4/(10^6),
      B0=0.1405,
      B1=-0.0298,
      y_intercept = 0.624,
      slope= - 0.975,
      IAMDiff = 0,
      C1 = 0,
      C2 = 0)
    "Kloben Sud S.r.l., Solar Collectors Sky Pro 1800, Sky Pro 18 CPC 58"
      annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011125E.<br>
    </p>
    </html>"));
end Tubular;

within Buildings.Fluid.SolarCollectors.BaseClasses;
block ASHRAESolarGain
  "Calculate the solar heat gain of a solar collector per ASHRAE Standard 93"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends SolarCollectors.BaseClasses.PartialParameters;
  Modelica.Blocks.Interfaces.RealInput HSkyDifTil(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Diffuse solar irradiation on a tilted surfce from the sky"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput HGroDifTil(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Diffuse solar irradiation on a tilted surfce from the ground"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](final unit="W")
    "Solar heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Real B0 "1st incident angle modifer coefficient";
  parameter Real B1 "2nd incident angle modifer coefficient";
  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));

  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in, group = "Shading"));
  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
  annotation(Placement(transformation(extent={{-140,-60},{-100,-100}},rotation=0)));
  parameter Modelica.SIunits.Angle til "Surface tilt";
protected
  final parameter Real iamSky( fixed = false)
    "Incident angle modifier for diffuse solar radiation from the sky";
  final parameter Real iamGro( fixed = false)
    "Incident angle modifier for diffuse solar radiation from the ground";
  Real iamBea "Incident angle modifier for director solar radiation";
  Real iam "weighted incident angle modifier";
  final parameter Modelica.SIunits.Angle incAngSky( fixed = false)
    "Incident angle of diffuse radiation from the sky";
  final parameter Modelica.SIunits.Angle incAngGro( fixed = false)
    "Incident angle of diffuse radiation from the ground";
  final parameter Real tilDeg(
  unit = "deg") = Modelica.SIunits.Conversions.to_deg(til)
    "Surface tilt angle in degrees";
  final parameter Modelica.SIunits.HeatFlux HTotMin = 1
    "Minimum HTot to avoid div/0";
  final parameter Real HMinDel = 0.001
    "Delta of the smoothing function for HTot";

  Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Inernally used shading coefficient";

initial equation
  // E+ Equ (557)
  incAngSky = Modelica.SIunits.Conversions.from_deg(59.68 - 0.1388*(tilDeg) + 0.001497*(tilDeg)^2);
  // Diffuse radiation from the sky
  // E+ Equ (555)
  iamSky = SolarCollectors.BaseClasses.IAM(
    incAngSky,
    B0,
    B1);
  // E+ Equ (558)
  incAngGro = Modelica.SIunits.Conversions.from_deg(90 - 0.5788*(tilDeg)+0.002693*(tilDeg)^2);
  // Diffuse radiation from the ground
  // E+ Equ (555)
  iamGro = SolarCollectors.BaseClasses.IAM(
    incAngGro,
    B0,
    B1);
equation

  connect(shaCoe_internal, shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal = shaCoe;
  end if;

  // E+ Equ (555)
  iamBea = Buildings.Utilities.Math.Functions.smoothHeaviside(1/3*Modelica.Constants.pi
     - incAng, Modelica.Constants.pi/60)*SolarCollectors.BaseClasses.IAM(
    incAng,
    B0,
    B1);
  // E+ Equ (556)
  iam = Buildings.Utilities.Math.Functions.smoothHeaviside(
      1/3*Modelica.Constants.pi-incAng,Modelica.Constants.pi/60)*((HDirTil*iamBea + HSkyDifTil*iamSky + HGroDifTil*iamGro)/
      Buildings.Utilities.Math.Functions.smoothMax((HDirTil + HSkyDifTil + HGroDifTil), HTotMin, HMinDel));
  // Modified from EnergyPlus Equ (559) by applying shade effect for direct solar radiation
  // Only solar heat gain is considered here
  for i in 1 : nSeg loop
    QSol_flow[i] = A_c/nSeg*(y_intercept*iam*(HDirTil*(1.0 - shaCoe_internal) + HSkyDifTil + HGroDifTil));
  end for;

  annotation (
    defaultComponentName="solHeaGai",
    Documentation(info="<html>
<p>
This component computes the solar heat gain of the solar thermal collector. It only calculates the solar heat gain without considering the heat loss
to the environment. This model uses ratings data according to ASHRAE93. The solar heat gain is calculated using Equations 555 - 559 in the referenced
EnergyPlus documentation.
</p>
<p>
The solar radiation absorbed by the panel is identified using Eq 559 from the EnergyPlus documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>Flow</sub>[i]=A<sub>c</sub>/nSeg (F<sub>R</sub>(&tau;&alpha;) K<sub>(&tau;&alpha;)<sub>net</sub></sub> (G<sub>Dir</sub> (1-shaCoe)+G<sub>Dif,Sky</sub>+G<sub>Dif,Gnd</sub>))
</p>
The solar radiation equation indicates that the collector is divided into multiple segments. The number of segments used in the simulation is specified
by the user (parameter: <code>nSeg</code>). The area of an individual segment is identified by dividing the collector area by the total number of segments. The term
<i>shaCoe</i> is used to define the percentage of the collector that is shaded.
</p>
<p>
The incidence angle modifier used in the solar radiation equation is found using Eq 556 from the EnergyPlus documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
K<sub>(&tau;&alpha;),net</sub>=(G<sub>beam</sub> K<sub>(&tau;&alpha;),beam</sub>+G<sub>sky</sub> K<sub>(&tau;&alpha;),sky</sub>+G<sub>gnd</sub> K<sub>(&tau;&alpha;),gnd</sub>) / (G<sub>beam</sub>+G<sub>sky</sub>+G<sub>gnd</sub>)
</p>
<p>
Each incidence angle modifier is calculated using Eq 555 from the EnergyPlus documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K<sub>(&tau;&alpha;),x</sub>=1+b<sub>0</sub> (1/cos(&theta;)-1)+b<sub>1</sub> (1/cos(&theta;)-1)<sup>2</sup>
</p>
<p>
In the above equation x can refer to beam, sky or ground.
</p>
<p>
<i>&theta;</i> is the incidence angle. For beam radiation <i>&theta;</i> is found via standard geometry. The incidence angle for sky and ground diffuse radiation are found
using, respectively, Eq 557 and 558 from the EnergyPlus documentation. They are:
</p>
<p align=\"center\" style=\"font-style:italic;\">
&theta;<sub>sky</sub>=59.68-0.1388 til+0.001497 til<sup>2</sup><br>
&theta;<sub>gnd</sub>=90.0-0.5788 til+0.002693 til<sup>2</sup>
</p>
<p>
These two equations must be evaluated in degrees. The necessary unit conversions are made internally, and the user does not need to worry about it. <i>Til</i>
is the surface tilt of the collector.
</p>

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.<br>
ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance of Solar Collectors (ANSI approved)
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 15, 2013, by Peter Grant:<br>
First implementation
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end ASHRAESolarGain;

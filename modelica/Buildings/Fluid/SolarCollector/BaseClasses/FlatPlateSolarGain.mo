within Buildings.Fluid.SolarCollector.BaseClasses;
block FlatPlateSolarGain
  "Calculate the solar heat gain of a flat plate solar collector"
  extends Modelica.Blocks.Interfaces.BlockIcon;
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
  Modelica.Blocks.Interfaces.RealInput TEnv(quantity="Temperature")
    "Dry buld temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput T(quantity="Temperature")
    "Mean temperature of the fluid"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
   Modelica.Blocks.Interfaces.RealInput HDirTil(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput Q(final unit="W") "Solar heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Modelica.SIunits.Area A "Gross area of the collector";
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "shading coefficient 0.0: no shading, 1.0: full shading";
  parameter Modelica.SIunits.Angle til "Surface tilt";
  parameter Real B0 "1st incident angle modifer coefficient";
  parameter Real B1 "2nd incident angle modifer coefficient";
  parameter Real C0 "1st collector constant in [-]";
  parameter Real C1 "2nd collector constant in W/(m2.K)";
  parameter Real C2 "3rd collector constant in W/(m2.K2)";

protected
  Real iamSky "Incident angle modifer for diffuse solar radiation from the sky";
  Real iamGro
    "Incident angle modifer for diffuse solar radiation from the ground";
  Real iamBea "Incident angle modifier for director solar radiation";
  Real iam "weighted incident angle modifier";
  Modelica.SIunits.Angle incAngSky
    "incident angle of diffuse radiation from the sky";
  Modelica.SIunits.Angle incAngGro
    "incident angle of diffuse radiation from the ground";
equation
  if incAng < 1/3*Modelica.Constants.pi then
    // Diffuse radiation from the sky
    // E+ Equ (557)
    incAngSky = 59.68/180*Modelica.Constants.pi - 0.1388*til + 0.001497*til^2;
    // E+ Equ (555)
    iamSky = Buildings.Fluid.SolarCollector.BaseClasses.IAM(
      incAngSky,
      B0,
      B1);
    // Diffuse radiation from the ground
    // E+ Equ (557)
    incAngGro = 90.0/180*Modelica.Constants.pi - 0.5788*til + 0.002693*til^2;
    // E+ Equ (555)
    iamGro = Buildings.Fluid.SolarCollector.BaseClasses.IAM(
      incAngGro,
      B0,
      B1);
    // E+ Equ (555)
    iamBea = Buildings.Fluid.SolarCollector.BaseClasses.IAM(
      incAng,
      B0,
      B1);
    iam = (HDirTil*iamBea + HSkyDifTil*iamSky + HGroDifTil*iamGro)/(HDirTil +
      HSkyDifTil + HGroDifTil);
  else
    incAngSky = 0;
    incAngGro = 0;
    iamSky = 0;
    iamGro = 0;
    iamBea = 0;
    iam = 0;
  end if;

  // Modified from EnergyPlus Equ (552) by applying shade effect for direct solar radiation
  Q = A*(C0*iam*(HDirTil*(1.0 - shaCoe) + HSkyDifTil + HGroDifTil) + C1*(T -
    TEnv) + C2*(T - TEnv)^2);
  annotation (
    defaultComponentName="solHeaGai",
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This component computes the useful heat gain of the flat plate solar thermal collector. 

It applies a quadratic correlation to calculate the thermal efficiency and the incident angle modifer. 
The parameters C0, C1 and C2 are listed in the Directory of SRCC (Solar Rating and Certification Corporation) Certified Solar Collector Ratings. If C2=0, then a first order equation will be used for the calculation.

</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
June 8, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end FlatPlateSolarGain;

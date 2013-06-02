within Buildings.Fluid.SolarCollectors.BaseClasses;
model EN12975SolarGain "Model calculating solar gains per the EN12975 standard"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends SolarCollectors.BaseClasses.PartialParameters;
  Modelica.Blocks.Interfaces.RealInput HSkyDifTil(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Diffuse solar irradiation on a tilted surfce from the sky"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-46},{-100,-6}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{-140,6},{-100,46}})));
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
         annotation(Dialog(enable = not use_shaCoe_in,group="Shading"));
  parameter Modelica.SIunits.Angle til "Surface tilt";
  parameter Real iamDiff "Incidence angle modifier for diffuse radiation";

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Time varying input for the shading coefficient"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-100}},rotation=0)));

protected
  Real iamBea "Incidence angle modifier for director solar radiation";
  Modelica.Blocks.Interfaces.RealInput shaCoe_internal "Internally used shaCoe";
equation

  connect(shaCoe_internal, shaCoe_in);

  // E+ Equ (555)
  iamBea = Buildings.Utilities.Math.Functions.smoothHeaviside(x=Modelica.Constants.pi
    /3 - incAng, delta=Modelica.Constants.pi/60)*
    SolarCollectors.BaseClasses.IAM(
    incAng,
    B0,
    B1);
  // Modified from EnergyPlus Equ (559) by applying shade effect for direct solar radiation
  // Only solar heat gain is considered here

  if not use_shaCoe_in then
    shaCoe_internal = shaCoe;
  end if;

  for i in 1 : nSeg loop
  QSol_flow[i] = A_c/nSeg*(y_intercept*(iamBea*HDirTil*(1.0 - shaCoe_internal) + iamDiff * HSkyDifTil));
  end for;
  annotation (
    defaultComponentName="solHeaGai",
    Documentation(info="<html>
<p>
This component computes the solar heat gain of the solar thermal collector. It only calculates the solar heat gain without considering the heat loss to 
the environment. This model performs calculations using ratings data from EN12975. The solar heat gain is calculated using Equation 559 in the 
referenced EnergyPlus documentation. The calculation is modified somewhat to use coefficients from EN12975.
</p>
<p>
The equation used to calculate solar gain is a modified version of Eq 559 from the EnergyPlus documentation. It is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q<sub>flow</sub>[i] = A<sub>c</sub>/nSeg F<sub>R</sub>(&tau;&alpha;) (K<sub>(&tau;&alpha;),beam</sub> G<sub>bea</sub> (1-shaCoe)+K<sub>Diff</sub> I<sub>sky</sub>)
</p>
<p>
The solar radiation equation indicates that the collector is divided into multiple segments. The number of segments used in the simulation is specified by the user parameter <code>nSeg</code>.
The area of an individual segment is identified by dividing the collector area by the total number of segments. The term <i>shaCoe</i> is used to define the percentage of the collector which is shaded.
The main difference between this model and the ASHRAE model is the handling of diffuse radiation. The ASHRAE model contains calculated incidence angle modifiers for both sky and ground diffuse radiation while
this model uses a coefficient from test data to for diffuse radiation.
</p>

<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.<br/>
CEN 2006, European Standard 12975-1:2006, European Committee for Standardization 
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 15, 2013, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Icon(graphics={Text(
          extent={{-48,-32},{36,-66}},
          lineColor={0,0,255},
          textString="%name")}));
end EN12975SolarGain;

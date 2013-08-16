within Buildings.Fluid.SolarCollectors.BaseClasses;
model EN12975SolarGain "Model calculating solar gains per the EN12975 standard"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  extends SolarCollectors.BaseClasses.PartialParameters;

  parameter Real B0 "1st incident angle modifer coefficient";
  parameter Real B1 "2nd incident angle modifer coefficient";
  parameter Boolean use_shaCoe_in = false
    "Enables an input connector for shaCoe"
    annotation(Dialog(group="Shading"));
  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in,group="Shading"));
  parameter Real iamDiff "Incidence angle modifier for diffuse radiation";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the system";
  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Time varying input for the shading coefficient"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}}, rotation=0)));

  Modelica.Blocks.Interfaces.RealInput HSkyDifTil(
    unit="W/m2", quantity="RadiantEnergyFluenceRate")
    "Diffuse solar irradiation on a tilted surfce from the sky"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil(
    unit="W/m2", quantity="RadiantEnergyFluenceRate")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](final unit="W")
    "Solar heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
     unit="K",
     displayUnit="degC",
     quantity="Temperature")
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

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
  QSol_flow[i] = A_c/nSeg*(y_intercept*(iamBea*HDirTil*(1.0 - shaCoe_internal) + iamDiff *
  HSkyDifTil))*Buildings.Utilities.Math.Functions.smoothHeaviside((Medium.T_max+1)-TFlu[i],1);
  end for;
  annotation (
    defaultComponentName="solGai",
    Documentation(info="<html>
      <p>
        This component computes the solar heat gain of the solar thermal collector. It 
        only calculates the solar heat gain without considering the heat loss to the 
        environment. This model performs calculations using ratings data from EN12975. 
        The solar heat gain is calculated using Equation 559 in the referenced EnergyPlus 
        documentation. The calculation is modified somewhat to use coefficients from EN12975.
      </p>
      <p>
        The equation used to calculate solar gain is a modified version of Eq 559 from 
        the EnergyPlus documentation. It is
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        Q<sub>Flow</sub>[i] = A<sub>c</sub>/nSeg F<sub>R</sub>(&tau;&alpha;) (K<sub>
        (&tau;&alpha;),Beam</sub> G<sub>Beam</sub> (1-shaCoe)+K<sub>Diff</sub> G<sub>
        Diff</sub>),
      </p>
      <p>
        where <i>Q<sub>Flow</sub>[i]</i> is the heat gained in each segment, <i>A<sub>
        c</sub></i> is the area of the collector, <code>nSeg</code> is the number of 
        segments in the collector, <i>F<sub>R</sub>(&tau;&alpha;)</i> is the maximum 
        efficiency of the collector, <i>K<sub>(&tau;&alpha;),Beam</sub> </i>is the 
        incidence angle modifier for beam radiation, <i>G<sub>Beam</sub></i> is the 
        current beam radiation on the collector, <code>shaCoe</code> is the shading 
        coefficient, <i>K<sub>Diff</sub></i> is the incidence angle modifier for 
        diffuse radiation and <i>G<sub>Diff</sub></i> is the diffuse
        radiation striking the surface.
      </p>
      <p>
        The solar radiation equation indicates that the collector is divided into 
        multiple segments. The number of segments used in the simulation is specified 
        using the parameter <code>nSeg</code>. The area of an individual segment is 
        identified by dividing the collector area by the total number of segments. The 
        parameter <code>shaCoe</code> is used to define the percentage of the collector 
        which is shaded. The main difference between this model and the ASHRAE model 
        is the handling of diffuse radiation. The ASHRAE model contains calculated 
        incidence angle modifiers for both sky and ground diffuse radiation
        while this model uses a coefficient from test data for diffuse radiation.
      </p>
      <p>
        The incidence angle modifier for beam radiation is calculated using Eq 555 
        from the EnergyPlus documentation, as
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        K<sub>(&tau;&alpha;),Beam</sub>=1+b<sub>0</sub> (1/cos(&theta;)-1)+b<sub>1</sub> 
        (1/cos(&theta;)-1)<sup>2</sup>,
      </p>
      <p>
        where <i>K<sub>(&tau;&alpha;),Beam</sub></i> is the incidence angle modifier 
        for beam radiation, <i>b<sub>0</sub></i> is the first incidence angle modifier 
        coefficient, <i>&theta;</i> is the incidence angle and <i>b<sub>1</sub></i> 
        is the second incidence angle modifier coefficient.
      </p>
      <p>
        This model reduces the heat gain rate to 0 W when the fluid temperature is 
        within 1 degree C of the maximum temperature of the medium model. The 
        calucation is performed using the 
        <a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
        Buildings.Utilities.Math.Functions.smoothHeaviside</a> function. 
      </p>
    <h4>References</h4>
      <p>
      <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, 
        October 13, 2011.<br/>
      CEN 2006, European Standard 12975-1:2006, European Committee for Standardization 
      </p>
    </html>",
    revisions="<html>
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
    Icon(graphics));
end EN12975SolarGain;

within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
partial model PartialInternalHEX
  "Partial model to implement the internal heat exchanger of a borehole segment"
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template
    borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium"
    annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  constant Real mSenFac=1
    "Factor for scaling the sensible thermal mass of the volume";
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material"
    annotation (Dialog(tab="Dynamics"));
  parameter Modelica.Units.SI.Length hSeg
    "Length of the internal heat exchanger";
  parameter Modelica.Units.SI.Volume VTubSeg=hSeg*Modelica.Constants.pi*(
      borFieDat.conDat.rTub - borFieDat.conDat.eTub)^2
    "Fluid volume in each tube";
  parameter Modelica.Units.SI.Temperature TFlu_start
    "Start value of fluid temperature" annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature TGro_start
    "Start value of grout temperature" annotation (Dialog(tab="Initialization"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cpMed=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Specific heat capacity of the fluid";
  parameter Modelica.Units.SI.ThermalConductivity kMed=
      Medium.thermalConductivity(Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Thermal conductivity of the fluid";
  parameter Modelica.Units.SI.DynamicViscosity muMed=Medium.dynamicViscosity(
      Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default)) "Dynamic viscosity of the fluid";
  parameter Real Rgb_val(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Real RCondGro_val(fixed=false)
    "Thermal resistance between: pipe wall to capacity in grout";
  parameter Real x(fixed=false) "Capacity location";
initial equation
  assert(borFieDat.conDat.rBor > borFieDat.conDat.xC + borFieDat.conDat.rTub and
         0 < borFieDat.conDat.xC - borFieDat.conDat.rTub,
         "The borehole geometry is not physical. Check the borefield data record
         to ensure that the shank spacing is larger than the outer tube radius
         and that the borehole radius is sufficiently large.");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Partial model to implement models simulating the thermal and fluid behaviour of a borehole segment.
</p>
<p>
The thermodynamic properties of the fluid circulating in the borehole are calculated
as protected parameters in this partial model: <i>c<sub>p</sub></i> (<code>cpMed</code>),
<i>k</i> (<code>kMed</code>) and <i>&mu;</i> (<code>muMed</code>). Additionally, the
following parameters are already declared as protected parameters and thus do not
need to be declared in models which extend this partial model:
</p>
<ul>
<li>
<code>Rgb_val</code> (Thermal resistance between grout zone and borehole wall)
</li>
<li>
<code>RCondGro_val</code> (Thermal resistance between pipe wall and capacity in grout)
</li>
<li>
<code>x</code> (Grout capacity location)
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to water and glycolWater.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
First implementation of partial model.
</li>
<li>
June 18, 2014, by Michael Wetter:<br/>
Added initialization for temperatures and derivatives of <code>capFil1</code>
and <code>capFil2</code> to avoid a warning during translation.
</li>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused parameters <code>B0</code> and <code>B1</code>.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation, added comments, replaced
<code>HeatTransfer.Windows.BaseClasses.ThermalConductor</code>
with resistance models from the Modelica Standard Library.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInternalHEX;

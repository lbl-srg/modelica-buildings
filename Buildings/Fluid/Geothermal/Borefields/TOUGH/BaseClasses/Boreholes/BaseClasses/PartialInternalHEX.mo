within Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.Boreholes.BaseClasses;
partial model PartialInternalHEX
  "Partial model to implement the internal heat exchanger of a borehole segment"
  parameter Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield.Template
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
<p>
Note that the model is same as
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialInternalHEX</a>,
except that different borefield data record is used.
</p>
</html>", revisions="<html>
<ul>
<li>
June 22, 2026, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInternalHEX;

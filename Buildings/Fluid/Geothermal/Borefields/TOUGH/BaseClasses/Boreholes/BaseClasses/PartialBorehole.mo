within Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.Boreholes.BaseClasses;
partial model PartialBorehole
  "Partial model to implement multi-segment boreholes"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    computeFlowResistance=dp_nominal > Modelica.Constants.eps);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  constant Real mSenFac(min=1)=1
   "Factor for scaling the sensible thermal mass of the volume";

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Temperature TGro_start[nSeg]
    "Start value of grout temperature" annotation (Dialog(tab="Initialization"));

  parameter Modelica.Units.SI.Temperature TFlu_start[nSeg]=TGro_start
    "Start value of fluid temperature" annotation (Dialog(tab="Initialization"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  parameter Buildings.Fluid.Geothermal.Borefields.TOUGH.Data.Borefield.Template borFieDat
    "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall[nSeg]
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

    annotation(Documentation(info="<html>
<p>
Partial model to implement models simulating geothermal U-tube boreholes modeled
as several borehole segments, with a uniform borehole wall boundary condition.
</p>
<p>
Note that the model is same as
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole</a>,
except that different borefield data record is used.
</p>
</html>", revisions="<html>
<ul>
<li>
June 22, 2026, by Jianjun Hu:<br/>
First implementation.
</ul>
</html>"),
Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{-68,76},{72,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-56},{64,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,54},{64,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,2},{64,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,76},{-60,-84}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{64,76},{74,-84}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}));
end PartialBorehole;

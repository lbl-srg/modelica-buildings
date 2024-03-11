within Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses;
partial model PartialBorefieldWithTough
  "Borefield model using single U-tube borehole heat exchanger configuration.Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal);

  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final dp_nominal=borFieDat.conDat.dp_nominal,
    final computeFlowResistance=(borFieDat.conDat.dp_nominal > Modelica.Constants.eps));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  constant Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the volume";

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  // Simulation parameters
  parameter Integer nSeg(min=1)=10
    "Number of segments to use in vertical discretization of the boreholes";

  // General parameters of borefield
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat "Borefield data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-80,-80},{-60,-60}})));

  // Temperature gradient in undisturbed soil
  parameter Modelica.Units.SI.Temperature TExt0_start=283.15
    "Initial far field temperature"
    annotation (Dialog(tab="Initialization", group="Soil"));
  parameter Modelica.Units.SI.Temperature TExt_start[nSeg]=
    {if z[i] >= z0 then TExt0_start + (z[i] - z0)*dT_dz else TExt0_start for i in 1:nSeg}
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Initialization", group="Soil"));

  parameter Modelica.Units.SI.Temperature TGro_start[nSeg]=TExt_start
    "Start value of grout temperature"
    annotation (Dialog(tab="Initialization", group="Filling material"));

  parameter Modelica.Units.SI.Temperature TFlu_start[nSeg]=TGro_start
    "Start value of fluid temperature"
    annotation (Dialog(tab="Initialization"));

  parameter Modelica.Units.SI.Height z0=10
    "Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Initialization", group="Temperature profile"));
  parameter Real dT_dz(final unit="K/m", min=0) = 0.01
    "Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Initialization", group="Temperature profile"));

  // Dynamics of filling material
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));

  Modelica.Blocks.Interfaces.RealOutput TBorAve(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit = "degC",
    start=TExt0_start)
    "Average borehole wall temperature in the borefield"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,34},{120,54}})));

  replaceable Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole borHol constrainedby
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole(
    redeclare final package Medium = Medium,
    final borFieDat=borFieDat,
    final nSeg=nSeg,
    final m_flow_nominal=m_flow_nominal/borFieDat.conDat.nBor,
    final dp_nominal=dp_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final computeFlowResistance=computeFlowResistance,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final mSenFac=mSenFac,
    final dynFil=dynFil,
    final TFlu_start=TFlu_start,
    final TGro_start=TGro_start) "Borehole"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.GroundResponse
    touRes(final nSeg=nSeg)
    "Ground response calculated by TOUGH simulator"
    annotation (Placement(transformation(extent={{8,40},{28,60}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-120,40},{-100,60}})));

protected
  parameter Modelica.Units.SI.Height z[nSeg]={borFieDat.conDat.hBor/nSeg*(i - 0.5) for i in 1:nSeg}
    "Distance from the surface to the considered segment";

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier masFloDiv(
    redeclare final package Medium = Medium,
    final k=borFieDat.conDat.nBor) "Division of flow rate"
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier masFloMul(
    redeclare final package Medium = Medium,
    final k=borFieDat.conDat.nBor) "Mass flow multiplier"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Buildings.Utilities.Math.Average AveTBor(nin=nSeg)
    "Average temperature of all the borehole segments"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Modelica.Blocks.Sources.Constant TBorHol_start[nSeg](
    k=TExt_start,
    y(each unit="K", each displayUnit="degC"))
    "Borehole outer wall start temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QBorHol[nSeg]
    "Heat flow rate of all segments of the borehole"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90, origin={0,-10})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature TemBorWal[nSeg]
    "Borewall temperature"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

equation
  connect(masFloMul.port_b, port_b)
    annotation (Line(points={{80,-40},{90,-40},{90,0},{100,0}},
        color={0,127,255}));
  connect(masFloDiv.port_b, port_a)
    annotation (Line(points={{-80,-40},{-90,-40},{-90,0},{-100,0}},
        color={0,127,255}));
  connect(masFloDiv.port_a, borHol.port_a)
    annotation (Line(points={{-60,-40},{-10,-40}}, color={0,127,255}));
  connect(borHol.port_b, masFloMul.port_a)
    annotation (Line(points={{10,-40},{60,-40}}, color={0,127,255}));
  connect(QBorHol.port_a, borHol.port_wall)
    annotation (Line(points={{-4.44089e-16,-20},{0,-20},{0,-30}}, color={191,0,0}));
  connect(QBorHol.port_b, TemBorWal.port) annotation (Line(points={{4.44089e-16,
          0},{0,0},{0,4},{90,4},{90,20},{80,20}},   color={191,0,0}));
  connect(AveTBor.y, TBorAve)
    annotation (Line(points={{81,50},{110,50}}, color={0,0,127}));
  connect(touRes.TBorWal, AveTBor.u) annotation (Line(points={{29,56},{44,56},{44,
          50},{58,50}}, color={0,0,127}));
  connect(touRes.TBorWal, TemBorWal.T) annotation (Line(points={{29,56},{40,56},
          {40,20},{58,20}}, color={0,0,127}));
  connect(TBorHol_start.y, touRes.TBorWal_start)
    annotation (Line(points={{-19,20},{0,20},{0,50},{7,50}}, color={0,0,127}));
  connect(QBorHol.Q_flow, touRes.QBor_flow) annotation (Line(points={{-11,-10},{
          -60,-10},{-60,56},{7,56}}, color={0,0,127}));
  connect(touRes.TOut, TOut) annotation (Line(points={{7,44},{-80,44},{-80,40},{
          -120,40}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),Documentation(info="<html>
<p>
This model simulates a borefield containing one or multiple boreholes
using the parameters in the <code>borFieDat</code> record.
</p>
<p>
Heat transfer to the soil is modeled using only one borehole heat exchanger
(To be added in an extended model). The
fluid mass flow rate into the borehole is divided to reflect the per-borehole
fluid mass flow rate. The borehole model calculates the dynamics within the
borehole itself using an axial discretization and a resistance-capacitance
network for the internal thermal resistances between the individual pipes and
between each pipe and the borehole wall.
</p>
<p>
The thermal interaction between the borehole wall and the surrounding soil
is modeled using
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse</a>,
which uses a cell-shifting load aggregation technique to calculate the borehole wall
temperature after calculating and/or read (from a previous calculation) the borefield's
thermal response factor.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBorefieldWithTough;

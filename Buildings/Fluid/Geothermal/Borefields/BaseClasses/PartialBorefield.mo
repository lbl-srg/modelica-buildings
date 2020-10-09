within Buildings.Fluid.Geothermal.Borefields.BaseClasses;
partial model PartialBorefield
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
  parameter Modelica.SIunits.Time tLoaAgg=300 "Time resolution of load aggregation";
  parameter Integer nCel(min=1)=5 "Number of cells per aggregation level";
  parameter Integer nSeg(min=1)=10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Boolean forceGFunCalc = false
    "Set to true to force the thermal response to be calculated at the start instead of checking whether this has been pre-computed"
    annotation (Dialog(tab="Advanced"));

  // General parameters of borefield
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat "Borefield data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-80,-80},{-60,-60}})));

  // Temperature gradient in undisturbed soil
  parameter Modelica.SIunits.Temperature TExt0_start=283.15
    "Initial far field temperature"
    annotation (Dialog(tab="Initialization", group="Soil"));
  parameter Modelica.SIunits.Temperature TExt_start[nSeg]=
    {if z[i] >= z0 then TExt0_start + (z[i] - z0)*dT_dz else TExt0_start for i in 1:nSeg}
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Initialization", group="Soil"));

  parameter Modelica.SIunits.Temperature TGro_start[nSeg]=TExt_start
    "Start value of grout temperature"
    annotation (Dialog(tab="Initialization", group="Filling material"));

  parameter Modelica.SIunits.Temperature TFlu_start[nSeg]=TGro_start
    "Start value of fluid temperature"
    annotation (Dialog(tab="Initialization"));

  parameter Modelica.SIunits.Height z0=10
    "Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Initialization", group="Temperature profile"));
  parameter Real dT_dz(final unit="K/m", min=0) = 0.01
    "Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Initialization", group="Temperature profile"));

  // Dynamics of filling material
  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));

  Modelica.Blocks.Interfaces.RealOutput TBorAve(final quantity="ThermodynamicTemperature",
                                                final unit="K",
                                                displayUnit = "degC",
                                                start=TExt0_start)
    "Average borehole wall temperature in the borefield"
    annotation (Placement(transformation(extent={{100,34},{120,54}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse groTemRes(
    final tLoaAgg=tLoaAgg,
    final nCel=nCel,
    final borFieDat=borFieDat,
    final forceGFunCalc=forceGFunCalc)
    "Ground temperature response"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

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

protected
  parameter Modelica.SIunits.Height z[nSeg]={borFieDat.conDat.hBor/nSeg*(i - 0.5) for i in 1:nSeg}
    "Distance from the surface to the considered segment";

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier masFloDiv(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    final k=1/borFieDat.conDat.nBor)
                                   "Division of flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Fluid.BaseClasses.MassFlowRateMultiplier masFloMul(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    final k=borFieDat.conDat.nBor) "Mass flow multiplier"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

  Modelica.Blocks.Math.Gain gaiQ_flow(k=borFieDat.conDat.nBor)
    "Gain to multiply the heat extracted by one borehole by the number of boreholes"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Utilities.Math.Average AveTBor(nin=nSeg)
    "Average temperature of all the borehole segments"
    annotation (Placement(transformation(extent={{50,34},{70,54}})));

  Modelica.Blocks.Sources.Constant TSoiUnd[nSeg](
    k = TExt_start,
    y(each unit="K",
      each displayUnit="degC"))
    "Undisturbed soil temperature"
    annotation (Placement(transformation(extent={{-40,14},{-20,34}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor QBorHol[nSeg]
    "Heat flow rate of all segments of the borehole"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,-10})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature TemBorWal[nSeg]
    "Borewall temperature"
    annotation (Placement(transformation(extent={{50,6},{70,26}})));

  Modelica.Blocks.Math.Add TSoiDis[nSeg](each final k1=1, each final k2=1)
    "Addition of undisturbed soil temperature and change of soil temperature"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  Modelica.Blocks.Math.Sum QTotSeg_flow(
    final nin=nSeg,
    final k = ones(nSeg))
    "Total heat flow rate for all segments of this borehole"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Modelica.Blocks.Routing.Replicator repDelTBor(final nout=nSeg)
    "Signal replicator for temperature difference of the borehole"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

equation
  connect(masFloMul.port_b, port_b)
    annotation (Line(points={{80,-40},{90,-40},{90,0},{100,0}},
                                                     color={0,127,255}));
  connect(masFloDiv.port_a, port_a)
    annotation (Line(points={{-80,-40},{-90,-40},{-90,0},{-100,0}},
                                                color={0,127,255}));
  connect(masFloDiv.port_b, borHol.port_a)
    annotation (Line(points={{-60,-40},{-10,-40}},     color={0,127,255}));
  connect(borHol.port_b, masFloMul.port_a)
    annotation (Line(points={{10,-40},{60,-40}},    color={0,127,255}));
  connect(QBorHol.port_a, borHol.port_wall)
    annotation (Line(points={{-4.44089e-16,-20},{0,-20},{0,-30}},
                                                        color={191,0,0}));
  connect(QBorHol.Q_flow, QTotSeg_flow.u)
    annotation (Line(points={{-10,-10},{-86,-10},{-86,80},{-62,80}},
                                                          color={0,0,127}));
  connect(groTemRes.delTBor, repDelTBor.u)
    annotation (Line(points={{41,80},{58,80}}, color={0,0,127}));
  connect(TSoiDis.u1, repDelTBor.y) annotation (Line(points={{8,36},{0,36},{0,
          60},{90,60},{90,80},{81,80}},
                        color={0,0,127}));
  connect(TSoiDis.u2, TSoiUnd.y) annotation (Line(points={{8,24},{-19,24}},
                         color={0,0,127}));
  connect(QTotSeg_flow.y, gaiQ_flow.u)
    annotation (Line(points={{-39,80},{-22,80}}, color={0,0,127}));
  connect(gaiQ_flow.y, groTemRes.QBor_flow)
    annotation (Line(points={{1,80},{19,80}}, color={0,0,127}));
  connect(TSoiDis.y, TemBorWal.T)
    annotation (Line(points={{31,30},{36,30},{36,16},{48,16}},
                                               color={0,0,127}));
  connect(QBorHol.port_b, TemBorWal.port) annotation (Line(points={{4.44089e-16,
          0},{0,0},{0,4},{80,4},{80,16},{70,16}},   color={191,0,0}));
  connect(TSoiDis.y, AveTBor.u) annotation (Line(points={{31,30},{36,30},{36,44},
          {48,44}}, color={0,0,127}));
  connect(AveTBor.y, TBorAve)
    annotation (Line(points={{71,44},{110,44}}, color={0,0,127}));
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
temperature after calculating and/or read (from a previous calculation) the borefield's thermal response factor.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2020, by Filip Jorissen:<br/>
Switched port connections for <code>masFloDiv</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/41\">#41</a>.
</li>
<li>
March 24, 2020, by Damien Picard:<br/>
Propagated flowReversal into <code>masFloDiv</code> and <code>masFloMul</code>.
</li>
<li>
June 7, 2019, by Massimo Cimmino:<br/>
Converted instances that are not of interest to user to be <code>protected</code>.
</li>
<li>
June 4, 2019, by Massimo Cimmino:<br/>
Added an output for the average borehole wall temperature.
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1107\">#1107</a>.
</li>
<li>
April 11, 2019, by Filip Jorissen:<br/>
Added <code>choicesAllMatching</code> for <code>borFieDat</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1117\">#1117</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to water and glycolWater.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
July 2018, by Alex Laferri&egrave;re:<br/>
Changed into a partial model and changed documentation to reflect the new approach
used by the borefield models.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBorefield;

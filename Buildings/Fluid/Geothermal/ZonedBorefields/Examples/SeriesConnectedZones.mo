within Buildings.Fluid.Geothermal.ZonedBorefields.Examples;
model SeriesConnectedZones "Description"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Temperature T_start=273.15
    "Initial temperature of the soil";
  final parameter Integer nZon(min=1) = borFieDat.conDat.nZon
    "Total number of independent bore field zones";

  Buildings.Fluid.Geothermal.ZonedBorefields.OneUTube borHol(
    redeclare package Medium = Medium,
    nSeg=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    borFieDat=borFieDat,
    TExt0_start=T_start,
    dT_dz=0,
    tLoaAgg=300,
    dynFil=true)
    "Borehole"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    T_start=T_start,
    allowFlowReversal=true,
    redeclare Buildings.Fluid.Movers.Data.Generic per,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal[1],
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    dp_nominal=60E3) "Circulation pump"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sensors.TemperatureTwoPort TBorFieIn(
    redeclare package Medium = Medium,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal[1],
    tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Sensors.TemperatureTwoPort TBorFieOut(
    redeclare package Medium = Medium,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal[1],
    tau=0) "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  parameter
    Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Example
    borFieDat(
    filDat=filDat,
    soiDat=soiDat,
    conDat=conDat) "Borefield data"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Sources.Boundary_ph sin(redeclare package Medium = Medium, nPorts=1)
    "Sink" annotation (Placement(transformation(extent={{80,20},{100,40}})));
  HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal[1],
    m_flow(start=borFieDat.conDat.mZon_flow_nominal[1]),
    p_start=100000,
    Q_flow_nominal=2*Modelica.Constants.pi*borFieDat.soiDat.kSoi*borFieDat.conDat.hBor
        *borFieDat.conDat.nBor) "Heater"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  parameter ZonedBorefields.Data.Configuration.Example conDat
    "Borefield configuration data"
    annotation (Placement(transformation(extent={{-58,-40},{-38,-20}})));
  parameter ZonedBorefields.Data.Filling.Bentonite filDat
    "Borehole filling data"
    annotation (Placement(transformation(extent={{-36,-40},{-16,-20}})));
  parameter ZonedBorefields.Data.Soil.SandStone soiDat
    "Soil data"
    annotation (Placement(transformation(extent={{-14,-40},{6,-20}})));

  Modelica.Blocks.Sources.Cosine heaRat(
    amplitude=0.75,
    f=1/(24*3600),
    offset=0.5)
    "Heating rate signal"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Blocks.Math.Sign sig
    "Sign of heating rate signal to determine flow direction"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.Blocks.Math.Gain gai(k=conDat.mZon_flow_nominal[1])
    "Gain for fluid mass flow rate" annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={10,26})));
equation
  connect(heaRat.y, hea.u) annotation (Line(points={{-49,20},{-38,20},{-38,6},{-32,
          6}}, color={0,0,127}));
  connect(hea.port_b, pum.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(pum.port_b, TBorFieIn.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(TBorFieIn.port_b, borHol.port_a[1])
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  connect(borHol.port_b[1:end - 1], borHol.port_a[2:end]) annotation (Line(
        points={{80,0},{86,0},{86,14},{54,14},{54,0},{60,0}}, color={0,127,255}));
  connect(borHol.port_b[end], TBorFieOut.port_a)
    annotation (Line(points={{80,0},{90,0}}, color={0,127,255}));
  connect(TBorFieOut.port_b, hea.port_a) annotation (Line(points={{110,0},{120,0},
          {120,60},{-80,60},{-80,0},{-30,0}}, color={0,127,255}));
  connect(sin.ports[1], TBorFieOut.port_b)
    annotation (Line(points={{100,30},{110,30},{110,0}}, color={0,127,255}));
  connect(heaRat.y, sig.u) annotation (Line(points={{-49,20},{-38,20},{-38,40},{
          -32,40}}, color={0,0,127}));
  connect(sig.y, gai.u)
    annotation (Line(points={{-9,40},{10,40},{10,33.2}}, color={0,0,127}));
  connect(gai.y, pum.m_flow_in) annotation (Line(points={{10,19.4},{10,15.7},{10,
          15.7},{10,12}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(extent={{-100,-60},{140,80}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Examples/SeriesConnectedZones.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example shows a borefield of 524 boreholes divided into 4 zones, as
configured in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Example</a>.
</p>
<p>
The total heat flow rate is cyclical, and the flow direction reverses when the
heating signal changes from injection and extraction.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=2592000., Tolerance=1e-6));
end SeriesConnectedZones;

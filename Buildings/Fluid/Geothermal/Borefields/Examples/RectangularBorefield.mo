within Buildings.Fluid.Geothermal.Borefields.Examples;
model RectangularBorefield "Example model of a rectangular borefield"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.Time tLoaAgg=300
    "Time resolution of load aggregation";

  parameter Modelica.Units.SI.Temperature TGro=283.15 "Ground temperature";
  parameter Modelica.Units.SI.Velocity v_nominal=1 "Nominal velocity";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=nBorHol*v_nominal*
      rTub^2*3.14*1000 "Nominal mass flow rate";
  parameter Modelica.Units.SI.Pressure dpBorFie_nominal=(hBor + (xBorFie +
      yBorFie)/2)*2 "Pressure losses for the entire borefield";
  parameter Modelica.Units.SI.Pressure dpHex_nominal=10000
    "Pressure drop heat exchanger";
  parameter Modelica.Units.SI.Pressure dp_nominal=dpBorFie_nominal +
      dpHex_nominal "Total pressure drop";

  parameter Modelica.Units.SI.Height hBor=100 "Total height of the borehole";
  parameter Modelica.Units.SI.Radius rTub=0.02 "Outer radius of the tubes";
  parameter Modelica.Units.SI.Length xBorFie=10 "Borefield length";
  parameter Modelica.Units.SI.Length yBorFie=30 "Borefield width";
  parameter Modelica.Units.SI.Length dBorHol=5 "Distance between two boreholes";

  final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol) "Number of boreholes in x-direction";
  final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol) "Number of boreholes in y-direction";
  final parameter Integer nBorHol = nXBorHol*nYBorHol "Number of boreholes";

  final parameter Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite filDat
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  final parameter Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone soiDat
    "Soil data" annotation (Placement(transformation(extent={{50,40},{70,60}})));
  final parameter Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template conDat(
    final borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
    final use_Rb=false,
    final mBor_flow_nominal=m_flow_nominal/(nXBorHol*nYBorHol),
    final mBorFie_flow_nominal=m_flow_nominal,
    final hBor=hBor,
    final dBor=1,
    final rBor=0.2,
    final rTub=rTub,
    final kTub=0.5,
    final eTub=0.002,
    final xC=0.05,
    final dp_nominal=dpBorFie_nominal,
    final cooBor = {{dBorHol*mod((i-1),nXBorHol), dBorHol*floor((i-1)/nXBorHol)} for i in 1:nBorHol})
    "Borefield configuration"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  final parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template
    borFieDat(
      final filDat=filDat,
      final soiDat=soiDat,
      final conDat=conDat) "Borefield parameters"
    annotation (Placement(transformation(extent={{60,74},{80,94}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFie(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=280.65,
    allowFlowReversal=false)
      "Geothermal borefield"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium, nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.HeatExchangers.Heater_T hea(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    m_flow(start=borFieDat.conDat.mBorFie_flow_nominal),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    dp_nominal=dpHex_nominal,
    allowFlowReversal=false)  "Heater"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant TSou(k=293.15)
    "Temperature of water that goes into the borefield"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation

  connect(hea.port_b, pum.port_a)
    annotation (Line(points={{-20,0},{0,0}},   color={0,127,255}));
  connect(TSou.y, hea.TSet) annotation (Line(points={{-59,30},{-52,30},{-52,8},{
          -42,8}}, color={0,0,127}));
  connect(pum.port_b, borFie.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(borFie.port_b, hea.port_a) annotation (Line(points={{60,0},{70,0},{70,
          -20},{-52,-20},{-52,0},{-40,0}}, color={0,127,255}));
  connect(pum.port_a, bou.ports[1])
    annotation (Line(points={{0,0},{0,-60},{-40,-60}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This example model illustrates how to configure the layout
of the boreholes for a rectangular borefield.
The configuration is
</p>
<pre>
cooBor = {{dBorHol*mod((i-1),nXBorHol), dBorHol*floor((i-1)/nXBorHol)} for i in 1:nBorHol}
</pre>
<p>
where <code>dBorHol</code> is the distance between the boreholes,
<code>nXBorHol</code> is the number of boreholes in the x-direction, and
<code>nBorHol</code> is the total number of boreholes.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/RectangularBorefield.mos"
        "Simulate and plot"),
  experiment(
      StopTime=2678400,Tolerance=1e-6));
end RectangularBorefield;

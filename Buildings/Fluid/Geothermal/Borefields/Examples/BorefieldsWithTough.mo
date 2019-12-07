within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsWithTough
  "Example model of single u-tube borefield with ground responses calculated by g-function and TOUGH simulation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.Temperature TGro = 283.15
    "Ground temperature";
  Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFieUTubDat(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube))
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source"
    annotation (Placement(transformation(extent={{-92,50},{-72,70}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub(
    redeclare package Medium = Medium,
    nCel=5,
    borFieDat=borFieUTubDat,
    tLoaAgg=300,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink"
    annotation (Placement(transformation(extent={{90,50},{70,70}},
        rotation=0)));

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source"
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub1(
    redeclare package Medium = Medium,
    nCel=2,
    borFieDat=borFieUTubDat,
    tLoaAgg=60,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration, high resolation setting for calculating ground response"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Sources.Boundary_pT  sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink"
    annotation (Placement(transformation(extent={{90,-10},{70,10}},
        rotation=0)));

  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source"
    annotation (Placement(transformation(extent={{-92,-70},{-72,-50}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn2(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTubeWithTough borFieUTubWitTou(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration, with ground response calculated by TOUGH"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut2(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}},
        rotation=0)));

equation
  connect(sou.ports[1], TUTubIn.port_a)
    annotation (Line(points={{-72,60},{-60,60}}, color={0,127,255}));
  connect(TUTubIn.port_b, borFieUTub.port_a)
    annotation (Line(points={{-40,60},{-10,60}}, color={0,127,255}));
  connect(borFieUTub.port_b, TUTubOut.port_a)
    annotation (Line(points={{10,60},{40,60}}, color={0,127,255}));
  connect(TUTubOut.port_b, sin.ports[1])
    annotation (Line(points={{60,60},{70,60}}, color={0,127,255}));
  connect(sou2.ports[1],TUTubIn2. port_a)
    annotation (Line(points={{-72,-60},{-60,-60}}, color={0,127,255}));
  connect(TUTubIn2.port_b, borFieUTubWitTou.port_a)
    annotation (Line(points={{-40,-60},{-10,-60}}, color={0,127,255}));
  connect(borFieUTubWitTou.port_b,TUTubOut2. port_a)
    annotation (Line(points={{10,-60},{40,-60}}, color={0,127,255}));
  connect(TUTubOut2.port_b,sin2. ports[1])
    annotation (Line(points={{60,-60},{70,-60}}, color={0,127,255}));
  connect(sou1.ports[1], TUTubIn1.port_a)
    annotation (Line(points={{-72,0},{-60,0}}, color={0,127,255}));
  connect(TUTubIn1.port_b, borFieUTub1.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(borFieUTub1.port_b, TUTubOut1.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(TUTubOut1.port_b, sin1.ports[1])
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));

annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/BorefieldsWithTough.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example shows same borefield but with three different ways to calculate the
ground response. Two of them use the g-function 
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse</a>
with different <code>nCel</code> (Number of cells per aggregation level) and
<code>tLoaAgg</code> (Time resolution of load aggregation). The third one calls
TOUGH simulator to calculate the ground response.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 06, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=36000,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-100,-140},{100,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end BorefieldsWithTough;

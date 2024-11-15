within Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.Examples;
model Borefields
  "Example model of single u-tube borefield with ground responses calculated by g-function and TOUGH simulation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Temperature TGro = 283.15
    "Ground temperature";

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin floRat(freqHz=1/21600,
      offset=1.2)
    "Mass flow rate to the borefield"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin watTem(
    amplitude=5,
    freqHz=1/10800,
    offset=273.15 + 10) "Water temperature to the borefield"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFieUTubDat(
    filDat=Buildings.Fluid.Geothermal.Borefields.Data.Filling.Bentonite(
        kFil=2.5,
        cFil=1000,
        dFil=2600),
    soiDat=Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(
        kSoi=2.5,
        cSoi=1000,
        dSoi=2600),
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube))
    annotation (Placement(transformation(extent={{90,90},{110,110}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_T_in=true)
              "Source"
    annotation (Placement(transformation(extent={{-62,50},{-42,70}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub(
    redeclare package Medium = Medium,
    show_T=true,
    nCel=5,
    borFieDat=borFieUTubDat,
    tLoaAgg=300,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{100,50},{80,70}},
        rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Source"
    annotation (Placement(transformation(extent={{-62,-70},{-42,-50}},
        rotation=0)));
  Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.OneUTube borFieUTubWitTou(
    redeclare package Medium = Medium,
    show_T=true,
    borFieDat=borFieUTubDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    samplePeriod=60)
    "Borefield with a U-tube borehole configuration, with ground response calculated by TOUGH"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{100,-70},{80,-50}},
        rotation=0)));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin ambTem(
    amplitude=5,
    freqHz=1/72000,
    offset=273.15 + 15)
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Source"
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}},
        rotation=0)));
  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub1(
    redeclare package Medium = Medium,
    show_T=true,
    nCel=10,
    borFieDat=borFieUTubDat,
    tLoaAgg=300,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut2(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{100,-10},{80,10}},
        rotation=0)));
equation
  connect(sou.ports[1], TUTubIn.port_a)
    annotation (Line(points={{-42,60},{-30,60}}, color={0,127,255}));
  connect(TUTubIn.port_b, borFieUTub.port_a)
    annotation (Line(points={{-10,60},{10,60}},  color={0,127,255}));
  connect(borFieUTub.port_b, TUTubOut.port_a)
    annotation (Line(points={{30,60},{50,60}}, color={0,127,255}));
  connect(TUTubOut.port_b, sin.ports[1])
    annotation (Line(points={{70,60},{80,60}}, color={0,127,255}));
  connect(borFieUTubWitTou.port_b,TUTubOut1. port_a)
    annotation (Line(points={{30,-60},{50,-60}}, color={0,127,255}));
  connect(TUTubOut1.port_b,sin1. ports[1])
    annotation (Line(points={{70,-60},{80,-60}}, color={0,127,255}));
  connect(floRat.y, sou.m_flow_in) annotation (Line(points={{-98,20},{-90,20},{-90,
          68},{-64,68}},       color={0,0,127}));
  connect(floRat.y,sou1. m_flow_in) annotation (Line(points={{-98,20},{-90,20},{
          -90,-52},{-64,-52}},   color={0,0,127}));
  connect(watTem.y, sou.T_in) annotation (Line(points={{-98,-20},{-80,-20},{-80,
          64},{-64,64}}, color={0,0,127}));
  connect(watTem.y,sou1. T_in) annotation (Line(points={{-98,-20},{-80,-20},{-80,
          -56},{-64,-56}}, color={0,0,127}));
  connect(ambTem.y, borFieUTubWitTou.TOut) annotation (Line(points={{-98,-90},{
          -20,-90},{-20,-55},{9,-55}},    color={0,0,127}));
  connect(borFieUTub1.port_b, TUTubOut2.port_a)
    annotation (Line(points={{30,0},{50,0}},color={0,127,255}));
  connect(TUTubOut2.port_b, sin2.ports[1])
    annotation (Line(points={{70,0},{80,0}}, color={0,127,255}));
  connect(floRat.y, sou2.m_flow_in) annotation (Line(points={{-98,20},{-90,20},{
          -90,8},{-64,8}},   color={0,0,127}));
  connect(watTem.y, sou2.T_in) annotation (Line(points={{-98,-20},{-80,-20},{-80,
          4},{-64,4}}, color={0,0,127}));
  connect(sou2.ports[1], borFieUTub1.port_a)
    annotation (Line(points={{-42,0},{10,0}},  color={0,127,255}));
  connect(sou1.ports[1], borFieUTubWitTou.port_a)
    annotation (Line(points={{-42,-60},{10,-60}},  color={0,127,255}));
annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/TOUGHResponse/Examples/Borefields.mos"
        "Simulate and plot"),
  experiment(StopTime=72000, Tolerance=1e-06),
  Documentation(info="<html>
<p>
This example shows same borefield but with three different ways to calculate the
ground response. Two of them use the g-function 
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse</a>
with different <code>nCel</code> (Number of cells per aggregation level) and
<code>tLoaAgg</code> (Time resolution of load aggregation). The third one calls
TOUGH simulator to calculate the ground response.
However in this example, the dummy function <code>def tough_avatar(heatFlux, T_out)</code>
is used to imitate the ground response calculated by TOUGH simulator.
</p>
<p>
Note the dummy function cannot run the ground modeling as TOUGH. It is created
to show the coupling workflow.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 8, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Borefields;

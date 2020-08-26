within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsWithToughConstant
  "Example model of single u-tube borefield with ground responses calculated by g-function and TOUGH simulation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.Temperature TGro = 283.15
    "Ground temperature";

  Controls.OBC.CDL.Continuous.Sources.Constant       floRat(k=3.6)
    "Mass flow rate to the borefield"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant       watTem(k=273.15 + 8)
                        "Water temperature to the borefield"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
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
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_T_in=true)
              "Source"
    annotation (Placement(transformation(extent={{-92,10},{-72,30}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub(
    redeclare package Medium = Medium,
    show_T=true,
    nCel=5,
    borFieDat=borFieUTubDat,
    tLoaAgg=300,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{70,10},{50,30}},
        rotation=0)));

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    use_T_in=true)
              "Source"
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Geothermal.Borefields.OneUTubeWithTough borFieUTubWitTou(
    redeclare package Medium = Medium,
    show_T=true,
    borFieDat=borFieUTubDat,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    samplePeriod=60)
    "Borefield with a U-tube borehole configuration, with ground response calculated by TOUGH"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{70,-40},{50,-20}},
        rotation=0)));

equation
  connect(sou.ports[1], TUTubIn.port_a)
    annotation (Line(points={{-72,20},{-60,20}}, color={0,127,255}));
  connect(TUTubIn.port_b, borFieUTub.port_a)
    annotation (Line(points={{-40,20},{-20,20}}, color={0,127,255}));
  connect(borFieUTub.port_b, TUTubOut.port_a)
    annotation (Line(points={{0,20},{20,20}},  color={0,127,255}));
  connect(TUTubOut.port_b, sin.ports[1])
    annotation (Line(points={{40,20},{50,20}}, color={0,127,255}));
  connect(sou1.ports[1],TUTubIn1. port_a)
    annotation (Line(points={{-72,-30},{-60,-30}}, color={0,127,255}));
  connect(TUTubIn1.port_b, borFieUTubWitTou.port_a)
    annotation (Line(points={{-40,-30},{-20,-30}}, color={0,127,255}));
  connect(borFieUTubWitTou.port_b,TUTubOut1. port_a)
    annotation (Line(points={{0,-30},{20,-30}},  color={0,127,255}));
  connect(TUTubOut1.port_b,sin1. ports[1])
    annotation (Line(points={{40,-30},{50,-30}}, color={0,127,255}));

  connect(floRat.y, sou.m_flow_in) annotation (Line(points={{-128,20},{-120,20},
          {-120,28},{-94,28}}, color={0,0,127}));
  connect(floRat.y,sou1. m_flow_in) annotation (Line(points={{-128,20},{-120,20},
          {-120,-22},{-94,-22}}, color={0,0,127}));
  connect(watTem.y, sou.T_in) annotation (Line(points={{-128,-20},{-110,-20},{
          -110,24},{-94,24}},
                         color={0,0,127}));
  connect(watTem.y,sou1. T_in) annotation (Line(points={{-128,-20},{-110,-20},{
          -110,-26},{-94,-26}},
                           color={0,0,127}));
annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/BorefieldsWithToughConstant.mos"
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
      StopTime=72000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Diagram(coordinateSystem(extent={{-180,-140},{100,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end BorefieldsWithToughConstant;

within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsDemo
  "Example model with several borefield configurations operating simultaneously"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.Time tLoaAgg=300
    "Time resolution of load aggregation";

  parameter Modelica.SIunits.Temperature TGro = 283.15
    "Ground temperature";
  Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFieUTubDat(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube))
    annotation (Placement(transformation(extent={{70,22},{90,42}})));

  Buildings.Fluid.Geothermal.Borefields.OneUTube borFieUTub(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    tLoaAgg=tLoaAgg,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-92,50},{-72,
            70}},      rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,50},{70,70}},
                   rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TUTubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Data.Borefield.Example                                       borFieUTubDat1(conDat=
        Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(borCon=
        Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube))
    annotation (Placement(transformation(extent={{70,-78},{90,-58}})));
  OneUTubeDemo                                   borFieUTub1(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat1,
    dynFil=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro)
    "Borefield with a U-tube borehole configuration"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Sources.MassFlowSource_T                 sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.mBorFie_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-92,-50},{-72,
            -30}},     rotation=0)));
  Sensors.TemperatureTwoPort                 TUTubIn1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Sources.Boundary_pT                 sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,-50},{70,-30}},
                   rotation=0)));
  Sensors.TemperatureTwoPort                 TUTubOut1(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation
  connect(sou.ports[1], TUTubIn.port_a)
    annotation (Line(points={{-72,60},{-60,60}},   color={0,127,255}));
  connect(TUTubIn.port_b, borFieUTub.port_a)
    annotation (Line(points={{-40,60},{-10,60}},   color={0,127,255}));
  connect(borFieUTub.port_b, TUTubOut.port_a)
    annotation (Line(points={{10,60},{40,60}},            color={0,127,255}));
  connect(TUTubOut.port_b, sin.ports[1])
    annotation (Line(points={{60,60},{70,60}},            color={0,127,255}));
  connect(sou1.ports[1], TUTubIn1.port_a)
    annotation (Line(points={{-72,-40},{-60,-40}}, color={0,127,255}));
  connect(TUTubIn1.port_b, borFieUTub1.port_a)
    annotation (Line(points={{-40,-40},{-10,-40}}, color={0,127,255}));
  connect(borFieUTub1.port_b, TUTubOut1.port_a)
    annotation (Line(points={{10,-40},{40,-40}}, color={0,127,255}));
  connect(TUTubOut1.port_b, sin1.ports[1])
    annotation (Line(points={{60,-40},{70,-40}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/Borefields.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example shows three different borefields, each with a different configuration
(single U-tube, double U-tube in parallel, and double U-tube in series) and compares
the thermal behaviour of the circulating fluid in each case.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=36000,Tolerance=1e-6));
end BorefieldsDemo;

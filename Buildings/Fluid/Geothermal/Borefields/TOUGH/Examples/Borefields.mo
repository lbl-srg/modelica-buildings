within Buildings.Fluid.Geothermal.Borefields.TOUGH.Examples;
model Borefields
  "Example model of single u-tube borefield with ground responses calculated by g-function and TOUGH simulation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Temperature TGro = 283.15
    "Ground temperature";

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example borFieUTubDat(
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

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin floRat(
    freqHz=1/21600,
    offset=1.2)
    "Mass flow rate to the borefield"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin watTem(
    amplitude=5,
    freqHz=1/10800,
    offset=273.15 + 10) "Water temperature to the borefield"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=0)));
  Buildings.Fluid.Geothermal.Borefields.TOUGH.OneUTube borFieUTubWitTou(
    redeclare package Medium = Medium,
    show_T=true,
    borFieDat=borFieUTubDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=TGro,
    nTouSeg=33,
    nSeg=10,
    nInt=10,
    samplePeriod=60)
    "Borefield with a U-tube borehole configuration, with ground response calculated by TOUGH"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieUTubDat.conDat.mBorFie_flow_nominal,
    tau=0) "Outlet temperature of the borefield with UTube configuration"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{100,-10},{80,10}}, rotation=0)));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin ambTem(
    amplitude=5,
    freqHz=1/72000,
    offset=273.15 + 15)
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
equation
  connect(borFieUTubWitTou.port_b, TOut.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(TOut.port_b, sin.ports[1])
    annotation (Line(points={{60,0},{80,0}}, color={0,127,255}));
  connect(floRat.y, sou.m_flow_in) annotation (Line(points={{-98,20},{-80,20},{-80,
          8},{-62,8}}, color={0,0,127}));
  connect(watTem.y, sou.T_in) annotation (Line(points={{-98,-40},{-80,-40},{-80,
          4},{-62,4}}, color={0,0,127}));
  connect(ambTem.y, borFieUTubWitTou.TOut) annotation (Line(points={{-98,60},{-20,
          60},{-20,4},{-1,4}}, color={0,0,127}));
  connect(sou.ports[1], borFieUTubWitTou.port_a)
    annotation (Line(points={{-40,0},{0,0}}, color={0,127,255}));
annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/TOUGH/Examples/Borefields.mos"
        "Simulate and plot"),
  experiment(StopTime=72000, Tolerance=1e-06),
  Documentation(info="<html>
<p>
This example shows the borefield ground thermal response that is modeled by the
TOUGH simulator.
However in this example, the dummy function <code>def tough_avatar(heatFlux, T_out, nInt)</code>
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

within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.Examples.BaseClasses;
partial model PartialBorehole "Partial model for borehole example models"
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Temperature T_start=273.15 + 22
    "Initial soil temperature";

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  replaceable Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole borHol
    constrainedby
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    dp_nominal=borFieDat.conDat.dp_nominal,
    nSeg=nSeg,
    TGro_start={T_start for i in 1:nSeg},
    TFlu_start={Medium.T_default for i in 1:nSeg})
    "Borehole connected to a discrete ground model" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,0})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDat.conDat.mBor_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-76,-10},{
            -56,10}}, rotation=0)));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{90,-12},{70,
            8}},  rotation=0)));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBorIn(m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
      redeclare package Medium = Medium,
    tau=0) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorOut(m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
      redeclare package Medium = Medium,
    tau=0) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTem[nSeg](each T=T_start)
    "Prescribed temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,70})));
equation
  connect(sou.ports[1], TBorIn.port_a)
    annotation (Line(points={{-56,0},{-50,0}}, color={0,127,255}));
  connect(TBorIn.port_b, borHol.port_a) annotation (Line(points={{-30,0},{-14,0},
          {-14,1.77636e-015}}, color={0,127,255}));
  connect(borHol.port_b, TBorOut.port_a) annotation (Line(points={{14,
          1.77636e-015},{14,0},{30,0}}, color={0,127,255}));
  connect(TBorOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{70,0},{70,-2}}, color={0,127,255}));

  connect(borHol.port_wall, preTem.port) annotation (Line(points={{1.77636e-15,14},
          {0,14},{0,70},{-40,70}}, color={191,0,0}));
  annotation(Documentation(info="<html>
<p>
This partial model is used for examples using boreholes models which extend
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.Examples.BaseClasses.PartialBorehole\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.Examples.BaseClasses.PartialBorehole</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 9, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBorehole;

within Buildings.Fluid.Storage.Examples;
model StratifiedLoadingUnloading "Test model for stratified tank"
  extends Modelica.Icons.Example;
  import Buildings;

 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
 constant Integer nSeg = 7 "Number of segments in tank";
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    p=300000 + 5000,
    T=273.15 + 40,
    redeclare package Medium = Medium,
    use_T_in=false,
    nPorts=2)             annotation (Placement(transformation(extent={{-80,-20},
            {-60,0}},  rotation=0)));
  Sources.MassFlowSource_T sin_1(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    nPorts=1,
    m_flow=-0.028,
    use_m_flow_in=true)
                   annotation (Placement(transformation(extent={{48,-2},{28,18}},
                     rotation=0)));
  Buildings.Fluid.Storage.StratifiedEnhanced tanEnh(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    m_flow_nominal=1*1000/3600/4,
    VTan=0.1,
    nSeg=nSeg,
    vol(medium(T(start=ones(nSeg)*273.15 + {50,26.8425,26.6594,26.65958,26.6596,26.6596,26.6596}))),
    show_T=true) "Tank"        annotation (Placement(transformation(extent={{-14,-2},
            {6,18}},  rotation=0)));

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Sources.MassFlowSource_T sin_2(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    nPorts=1,
    m_flow=-0.028,
    use_m_flow_in=true)
                   annotation (Placement(transformation(extent={{50,-40},{30,-20}},
                     rotation=0)));
  Buildings.Fluid.Storage.Stratified tan(
    redeclare package Medium = Medium,
    hTan=3,
    dIns=0.3,
    m_flow_nominal=1*1000/3600/4,
    VTan=0.1,
    nSeg=nSeg,
    vol(medium(T(start=ones(nSeg)*273.15 + {50,26.8425,26.6594,26.65958,26.6596,26.6596,26.6596}))),
    show_T=true) "Tank"        annotation (Placement(transformation(extent={{-10,-40},
            {10,-20}},rotation=0)));

  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=10*0.028,
    offset=-5*0.028,
    period=7200)
    annotation (Placement(transformation(extent={{60,42},{80,62}})));
equation
  connect(sou_1.ports[1], tanEnh.port_a)
                                      annotation (Line(
      points={{-60,-8},{-30,-8},{-30,8},{-14,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tanEnh.port_b, sin_1.ports[1])
                                      annotation (Line(
      points={{6,8},{28,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_b, sin_2.ports[1])    annotation (Line(
      points={{10,-30},{30,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_a, sou_1.ports[2])    annotation (Line(
      points={{-10,-30},{-30,-30},{-30,-12},{-60,-12}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(pulse.y, sin_1.m_flow_in) annotation (Line(
      points={{81,52},{90,52},{90,16},{48,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, sin_2.m_flow_in) annotation (Line(
      points={{81,52},{90,52},{90,-22},{50,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                     graphics),
                      Commands(file="StratifiedLoadingUnloading.mos" "run"),
    Documentation(info="<html>
This test model compares two tank models. The only difference between
the two tank models is that one uses the third order upwind discretization
scheme that reduces numerical diffusion that is induced when connecting 
volumes in series.
</html>"),
    experiment(StopTime=36000),
    experimentSetupOutput);
end StratifiedLoadingUnloading;

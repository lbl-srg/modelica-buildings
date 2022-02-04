within Buildings.Fluid.Storage.Plant.Examples;
model ChillerAndTankWithRemoteCharging "(Draft)"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Fluid.Storage.Plant.ChillerAndTankWithRemoteCharging cat(
    redeclare final package Medium=Medium,
    final m_flow_nominal1=1,
    final m_flow_nominal2=1,
    final p_CHWS_nominal=sin.p,
    final p_CHWR_nominal=sou.p,
    final T_CHWS_nominal=sin.T,
    final T_CHWR_nominal=sou.T)
    "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-16,-10},{16,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    p=300000,
    T=285.15,
    nPorts=1)
    "Source, CHW return line"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    p=800000,
    T=280.15,
    nPorts=1)
    "Sink, CHW supply line"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,0})));
  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0*3600,1; 0.25*3600,1;
        0.25*3600,-1; 0.5*3600,-1; 0.5*3600,0; 0.75*3600,0; 0.75*3600,1; 1*3600,
        1]) "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.BooleanTable booFloDir(table={0,3600/6*5})
    "Flow direction"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.BooleanTable booOnOffLin(table={0,1200,3600})
    "Plant online/offline"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(sou.ports[1], cat.port_a)
    annotation (Line(points={{-50,0},{-30,0},{-30,0},{-16,0}},
                                               color={0,127,255}));
  connect(cat.port_b, sin.ports[1]) annotation (Line(points={{16,0},{33,0},{33,4.44089e-16},
          {50,4.44089e-16}}, color={0,127,255}));

  connect(set_mTan_flow.y, cat.us_mTan_flow) annotation (Line(points={{-19,70},{
          -11.2,70},{-11.2,11}}, color={0,0,127}));
  connect(booOnOffLin.y, cat.onOffLin) annotation (Line(points={{-59,-30},{-19.2,
          -30},{-19.2,-7}}, color={255,0,255}));
  connect(booFloDir.y,cat.booFloDir)  annotation (Line(points={{-59,30},{-19.2,30},
          {-19.2,7}}, color={255,0,255}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end ChillerAndTankWithRemoteCharging;

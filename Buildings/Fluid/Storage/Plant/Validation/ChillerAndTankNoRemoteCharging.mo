within Buildings.Fluid.Storage.Plant.Validation;
model ChillerAndTankNoRemoteCharging "(Draft)"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";

  Buildings.Fluid.Storage.Plant.ChillerAndTankNoRemoteCharging cat(
    redeclare final package Medium=Medium,
    final m1_flow_nominal=1,
    final m2_flow_nominal=1,
    final p_CHWS_nominal=p_CHWS_nominal,
    final p_CHWR_nominal=p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal)
    "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1)
    "Source representing CHW return line"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    final p=p_CHWS_nominal,
    final T=T_CHWS_nominal,
    nPorts=1) "Sink representing CHW supply line"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,0})));
  Modelica.Blocks.Sources.TimeTable set_mPum2_flow(table=[0*3600,1; 0.25*3600,1;
        0.25*3600,-1; 0.5*3600,-1; 0.5*3600,0; 0.75*3600,0; 0.75*3600,1; 1*3600,
        1]) "Secondary mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Blocks.Sources.Constant set_mPum1_flow(k=cat.m1_flow_nominal)
    "Primary pump mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
equation
  connect(sou.ports[1], cat.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(cat.port_b, sin.ports[1]) annotation (Line(points={{10,0},{30,0},{30,
          4.44089e-16},{50,4.44089e-16}},
                             color={0,127,255}));

  connect(set_mPum2_flow.y, cat.set_mPum2_flow) annotation (Line(points={{-49,
          30},{-16,30},{-16,6},{-11,6}}, color={0,0,127}));
  connect(set_mPum1_flow.y, cat.set_mPum1_flow)
    annotation (Line(points={{-49,70},{-3,70},{-3,11}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end ChillerAndTankNoRemoteCharging;

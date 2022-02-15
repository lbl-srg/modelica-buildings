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

  Buildings.Fluid.Storage.Plant.ChillerAndTank cat(
    redeclare final package Medium=Medium,
    final allowRemoteCharging=false,
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
  Modelica.Blocks.Sources.TimeTable set_mPum2_flow(table=[0,1; 900,1; 900,-1;
        1800,-1; 1800,0; 2700,0; 2700,1; 3600,1])
            "Secondary mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Constant set_mPum1_flow(k=cat.m1_flow_nominal)
    "Primary pump mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.Continuous.LimPID conPID_Pum2(
    Td=1,
    k=1,
    Ti=15) "PI controller for the secondary pump" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,70})));
  Modelica.Blocks.Math.Gain gain2(k=1/cat.m2_flow_nominal) "Gain"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,90})));
equation
  connect(sou.ports[1], cat.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(cat.port_b, sin.ports[1]) annotation (Line(points={{10,0},{30,0},{30,
          4.44089e-16},{50,4.44089e-16}},
                             color={0,127,255}));

  connect(gain2.y, conPID_Pum2.u_m)
    annotation (Line(points={{-21,90},{-50,90},{-50,82}},
                                                   color={0,0,127}));
  connect(cat.mTan_flow, gain2.u) annotation (Line(points={{9,-11},{14,-11},{14,
          90},{2,90}},
                    color={0,0,127}));
  connect(set_mPum2_flow.y, conPID_Pum2.u_s)
    annotation (Line(points={{-79,70},{-62,70}},             color={0,0,127}));
  connect(set_mPum1_flow.y, cat.set_mPum1_flow) annotation (Line(points={{-39,
          30},{-18,30},{-18,9},{-11,9}}, color={0,0,127}));
  connect(conPID_Pum2.y, cat.yPum2)
    annotation (Line(points={{-39,70},{-7,70},{-7,11}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ChillerAndTankNoRemoteCharging;

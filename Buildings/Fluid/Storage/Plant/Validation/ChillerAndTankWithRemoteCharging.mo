within Buildings.Fluid.Storage.Plant.Validation;
model ChillerAndTankWithRemoteCharging
  "(Draft)"
  //Operation modes implemented in time tables:
  //      plant   | chiller | tank       | flow direction | tank flow rate
  //   1. offline   off       off          N/A              0
  //   2. offline   on        charging     N/A              -1
  //   3. online    on        charging     normal           -1
  //   4. online    on        off          normal           0
  //   5. online    on        discharging  normal           1
  //   6. online    off       discharging  normal           1
  //   7. online    off       charging     reverse          -1

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

  Buildings.Fluid.Storage.Plant.ChillerAndTankWithRemoteCharging cat(
    redeclare final package Medium=Medium,
    pum1(m_flow_start=0),
    final m1_flow_nominal=1,
    final m2_flow_nominal=1,
    final p_CHWS_nominal=p_CHWS_nominal,
    final p_CHWR_nominal=p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal)
    "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    p=p_CHWR_nominal,
    T=T_CHWR_nominal,
    nPorts=1)
    "Source, CHW return line"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,0})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    p=p_CHWS_nominal,
    T=T_CHWS_nominal,
    nPorts=1)
    "Sink, CHW supply line"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={60,0})));
  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,
        -1; 3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7
        *6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.BooleanTable booFloDir(table={0,3600/7*6})
    "Flow direction (true = normal, false = reverse)"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.BooleanTable booOnOffLin(table={3600/7*2})
    "Plant online/offline (true = online, false = offline)"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*5,1; 3600/7*5,0]) "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(sou.ports[1], cat.port_a)
    annotation (Line(points={{-50,0},{-8,0}},  color={0,127,255}));
  connect(cat.port_b, sin.ports[1]) annotation (Line(points={{12,0},{35,0},{35,4.44089e-16},
          {50,4.44089e-16}}, color={0,127,255}));

  connect(booOnOffLin.y, cat.onOffLin) annotation (Line(points={{-59,-30},{-20,
          -30},{-20,-9},{-10,-9}},
                            color={255,0,255}));
  connect(booFloDir.y,cat.booFloDir)  annotation (Line(points={{-59,30},{-40,30},
          {-40,-4},{-10,-4},{-10,-5}},
                      color={255,0,255}));
  connect(set_mTan_flow.y, cat.set_mTan_flow)
    annotation (Line(points={{-59,70},{-32,70},{-32,4},{-10,4},{-10,5},{-9,5}},
                                                        color={0,0,127}));
  connect(set_mChi_flow.y, cat.set_mPum1_flow)
    annotation (Line(points={{-19,90},{-9,90},{-9,9}},  color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end ChillerAndTankWithRemoteCharging;

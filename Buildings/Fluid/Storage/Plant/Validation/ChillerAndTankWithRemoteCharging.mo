within Buildings.Fluid.Storage.Plant.Validation;
model ChillerAndTankWithRemoteCharging
  "(Draft)"
/* 
    Operation modes implemented in time tables:
        plant   | chiller | tank       | flow direction | tank flow rate
     1. offline   off       off          N/A              0
     2. offline   on        charging     N/A              -1
     3. online    on        charging     normal           -1
     4. online    on        off          normal           0
     5. online    on        discharging  normal           1
     6. online    off       discharging  normal           1
     7. online    off       charging     reverse          -1
*/

  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";

  Buildings.Fluid.Storage.Plant.ChillerAndTank cat(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final allowRemoteCharging=true,
    final mChi_flow_nominal=1,
    final mTan_flow_nominal=1,
    final p_CHWS_nominal=p_CHWS_nominal,
    final p_CHWR_nominal=p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium2,
    p=p_CHWR_nominal,
    T=T_CHWR_nominal,
    nPorts=1)
    "Source, CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-30})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium2,
    p=p_CHWS_nominal,
    T=T_CHWS_nominal,
    nPorts=1)
    "Sink, CHW supply line"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,-30})));
  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,
        -1; 3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7
        *6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.BooleanTable booFloDir(table={0,3600/7*6})
    "Flow direction: True = normal; False = reverse"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.BooleanTable booOnOff(table={3600/7*2})
    "True = online; False = offline"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*5,1; 3600/7*5,0]) "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW(
    redeclare final package Medium = Medium1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,30})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW(
    redeclare package Medium = Medium1,
    m_flow=1,
    T=305.15,
    nPorts=1) "Source representing CDW supply line"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation

  connect(booOnOff.y, cat.booOnOff) annotation (Line(points={{-59,-70},{-10,-70},
          {-10,-9}},          color={255,0,255}));
  connect(booFloDir.y,cat.booFloDir)  annotation (Line(points={{-59,0},{-56,0},
          {-56,-2},{-10,-2}},
                      color={255,0,255}));
  connect(set_mTan_flow.y, cat.set_mTan_flow)
    annotation (Line(points={{-59,60},{-14,60},{-14,2},{-9,2}},
                                                        color={0,0,127}));
  connect(set_mChi_flow.y, cat.set_mPum1_flow)
    annotation (Line(points={{-59,90},{-9,90},{-9,9}},  color={0,0,127}));
  connect(cat.port_b2, sin.ports[1]) annotation (Line(points={{-8,-6},{-54,-6},
          {-54,-30},{-60,-30}}, color={0,127,255}));
  connect(sou.ports[1], cat.port_a2) annotation (Line(points={{60,-30},{18,-30},
          {18,-6},{12,-6}}, color={0,127,255}));
  connect(cat.port_a1, souCDW.ports[1]) annotation (Line(points={{-8,6},{-54,6},
          {-54,30},{-60,30}}, color={0,127,255}));
  connect(sinCDW.ports[1], cat.port_b1) annotation (Line(points={{60,30},{18,30},
          {18,6},{12,6}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ChillerAndTankWithRemoteCharging;

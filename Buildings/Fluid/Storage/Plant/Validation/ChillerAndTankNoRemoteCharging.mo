within Buildings.Fluid.Storage.Plant.Validation;
model ChillerAndTankNoRemoteCharging
  "(Draft) Validation model of the plant not allowing remote charging"
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
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final allowRemoteCharging=false,
    final mEva_flow_nominal=1,
    final mCon_flow_nominal=1,
    final mTan_flow_nominal=1,
    final dp_nominal=p_CHWS_nominal-p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal,
    final preDroTan(final dp_nominal=cat.dp_nominal*0.1),
    final valCha(final dpValve_nominal=cat.dp_nominal*0.1),
    final valDis(final dpValve_nominal=cat.dp_nominal*0.1),
    final cheValPumPri(final dpValve_nominal=cat.dp_nominal*0.1,
                       final dpFixed_nominal=cat.dp_nominal*0.1),
    final cheValPumSec(final dpValve_nominal=cat.dp_nominal*0.1,
                       final dpFixed_nominal=cat.dp_nominal*0.1))
    "Plant with chiller and tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium2,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1)
    "Source representing CHW return line"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-30})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium2,
    final p=p_CHWS_nominal,
    final T=T_CHWS_nominal,
    nPorts=1) "Sink representing CHW supply line"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,-30})));
  Modelica.Blocks.Sources.TimeTable set_mPumSec_flow(table=[0,1; 900,1; 900,-1;
        1800,-1; 1800,0; 2700,0; 2700,1; 3600,1])
    "Secondary mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Constant set_mPumPri_flow(k=cat.m1_flow_nominal)
    "Primary pump mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.Continuous.LimPID conPID_PumSec(
    Td=1,
    k=1,
    Ti=15) "PI controller" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,50})));
  Modelica.Blocks.Math.Gain gain2(k=1/cat.m2_flow_nominal) "Gain"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,70})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW(
    redeclare package Medium = Medium1,
    m_flow=1,
    T=305.15,
    nPorts=1) "Source representing CDW supply line"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW(
    redeclare final package Medium = Medium1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,30})));
equation

  connect(gain2.y, conPID_PumSec.u_m)
    annotation (Line(points={{-21,70},{-50,70},{-50,62}}, color={0,0,127}));
  connect(cat.mTan_flow, gain2.u) annotation (Line(points={{11,-2},{16,-2},{16,70},
          {2,70}},  color={0,0,127}));
  connect(set_mPumSec_flow.y, conPID_PumSec.u_s)
    annotation (Line(points={{-79,50},{-62,50}}, color={0,0,127}));
  connect(set_mPumPri_flow.y, cat.set_mPumPri_flow) annotation (Line(points={{-59,
          0},{-16,0},{-16,10},{-11,10}}, color={0,0,127}));
  connect(conPID_PumSec.y, cat.yPumSec)
    annotation (Line(points={{-39,50},{-8,50},{-8,11}}, color={0,0,127}));
  connect(sin.ports[1], cat.port_b2) annotation (Line(points={{-60,-30},{-16,
          -30},{-16,-6},{-10,-6}}, color={0,127,255}));
  connect(sou.ports[1], cat.port_a2) annotation (Line(points={{60,-30},{16,-30},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(souCDW.ports[1], cat.port_a1) annotation (Line(points={{-60,30},{-20,
          30},{-20,6},{-10,6}}, color={0,127,255}));
  connect(cat.port_b1, sinCDW.ports[1]) annotation (Line(points={{10,6},{54,6},
          {54,30},{60,30}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/ChillerAndTankNoRemoteCharging.mos"
        "Simulate and plot"),
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
(Draft) This is a validation model where the plant is configured not to allow
remotely charging the tank.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ChillerAndTankNoRemoteCharging;

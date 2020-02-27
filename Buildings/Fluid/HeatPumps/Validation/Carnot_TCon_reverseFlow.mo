within Buildings.Fluid.HeatPumps.Validation;
model Carnot_TCon_reverseFlow
  "Test model for heat pump based on Carnot efficiency and condenser outlet temperature control signal"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal=100E3
    "Evaporator heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=QCon_flow_nominal/
      dTCon_nominal/4200 "Nominal mass flow rate at condenser";

  Modelica.Blocks.Sources.Constant TConLvg(k=273.15 + 40)
    "Control signal for condenser leaving temperature"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp2_default=
      Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      Medium2.p_default,
      Medium2.T_default,
      Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";
  Modelica.Blocks.Sources.Ramp mCon_flow(
    duration=60,
    startTime=1800,
    height=-2*m1_flow_nominal,
    offset=m1_flow_nominal) "Mass flow rate for condenser"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Carnot_TCon heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    m1_flow_nominal=m1_flow_nominal,
    show_T=true,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    QCon_flow_nominal=QCon_flow_nominal,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal=6000,
    dp2_nominal=6000) "Heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    use_m_flow_in=true,
    T=293.15)
    annotation (Placement(transformation(extent={{-52,-4},{-32,16}})));
  Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    use_T_in=false,
    use_m_flow_in=true,
    T=288.15)
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={50,30})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    nPorts=1,
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-50,-30})));
  Modelica.Blocks.Math.Gain mEva_flow(k=-1/cp2_default/dTEva_nominal)
    "Evaporator mass flow rate"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Math.Add QEva_flow(k2=-1) "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation
  connect(sou1.ports[1],heaPum. port_a1) annotation (Line(
      points={{-32,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1],heaPum. port_a2) annotation (Line(
      points={{40,-6},{10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin2.ports[1],heaPum. port_b2) annotation (Line(
      points={{-40,-30},{-20,-30},{-20,-6},{-10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QEva_flow.y,mEva_flow. u) annotation (Line(points={{61,-40},{76,-40},{
          76,-60},{20,-60},{20,-80},{38,-80}},  color={0,0,127}));
  connect(heaPum.port_b1,sin1. ports[1]) annotation (Line(points={{10,6},{30,6},
          {30,30},{40,30}}, color={0,127,255}));
  connect(mEva_flow.y, sou2.m_flow_in) annotation (Line(points={{61,-80},{80,-80},
          {80,2},{62,2}},               color={0,0,127}));
  connect(TConLvg.y, heaPum.TSet) annotation (Line(points={{-29,40},{-20,40},{
          -20,9},{-12,9}}, color={0,0,127}));
  connect(mCon_flow.y, sou1.m_flow_in) annotation (Line(points={{-69,10},{-60,
          10},{-60,14},{-54,14}}, color={0,0,127}));
  connect(heaPum.QCon_flow, QEva_flow.u1) annotation (Line(points={{11,9},{20,9},
          {20,-34},{38,-34}}, color={0,0,127}));
  connect(QEva_flow.u2, heaPum.P) annotation (Line(points={{38,-46},{16,-46},{16,
          0},{11,0}},    color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/Carnot_TCon_reverseFlow.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that simulates a heat pump whose efficiency is scaled based on the
Carnot cycle.
The heat pump takes as an input the condenser leaving water temperature.
The condenser mass flow rate is computed in such a way that it has
a temperature difference equal to <code>dTCon_nominal</code>.
</p>
<p>
This example checks the correct behavior if a mass flow rate attains zero.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for 
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
November 25, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TCon_reverseFlow;

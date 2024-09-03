within Buildings.Fluid.HeatPumps.Examples;
model Carnot_TCon
  "Test model for heat pump based on Carnot efficiency and condenser outlet temperature control signal"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-5
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal=100E3
    "Evaporator heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=QCon_flow_nominal/
      dTCon_nominal/4200 "Nominal mass flow rate at condenser";

  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    m1_flow_nominal=m1_flow_nominal,
    show_T=true,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    use_eta_Carnot_nominal=true,
    QCon_flow_nominal=QCon_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000) "Heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    m_flow=m1_flow_nominal,
    T=293.15)
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    use_T_in=false,
    use_m_flow_in=true,
    T=288.15)
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Modelica.Blocks.Sources.Ramp TConLvg(
    duration=60,
    startTime=1800,
    height=15,
    offset=273.15 + 35) "Control signal for condenser leaving temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Gain mEva_flow(k=-1/cp2_default/dTEva_nominal)
    "Evaporator mass flow rate"
    annotation (Placement(transformation(extent={{34,-88},{54,-68}})));
  Modelica.Blocks.Math.Add QEva_flow(k2=-1) "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{32,-48},{52,-28}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium2,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,28},{40,48}})));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp2_default=
      Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      Medium2.p_default,
      Medium2.T_default,
      Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";

equation
  connect(sou1.ports[1], heaPum.port_a1) annotation (Line(
      points={{-40,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], heaPum.port_a2) annotation (Line(
      points={{40,-6},{10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QEva_flow.y,mEva_flow. u) annotation (Line(points={{53,-38},{64,-38},
          {64,-58},{24,-58},{24,-78},{32,-78}}, color={0,0,127}));
  connect(TConLvg.y, heaPum.TSet) annotation (Line(points={{-59,50},{-20,50},{
          -20,9},{-12,9}}, color={0,0,127}));
  connect(mEva_flow.y, sou2.m_flow_in) annotation (Line(points={{55,-78},{74,
          -78},{74,-10},{74,2},{62,2}}, color={0,0,127}));
  connect(QEva_flow.u1, heaPum.QCon_flow) annotation (Line(points={{30,-32},{20,
          -32},{20,9},{11,9}}, color={0,0,127}));
  connect(QEva_flow.u2, heaPum.P) annotation (Line(points={{30,-44},{16,-44},{16,
          0},{11,0}},    color={0,0,127}));
  connect(sin2.ports[1], heaPum.port_b2) annotation (Line(points={{-40,-30},{-20,
          -30},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{30,6},
          {30,38},{40,38}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/Carnot_TCon.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that simulates a chiller whose efficiency is scaled based on the
Carnot cycle.
The chiller takes as an input the evaporator leaving water temperature.
The condenser mass flow rate is computed in such a way that it has
a temperature difference equal to <code>dTEva_nominal</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 10, 2023, by Michael Wetter:<br/>
Removed binding of parameter with same value as the default.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1692\">#1692</a>.
</li>
<li>
May 2, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
November 25, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TCon;

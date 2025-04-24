within Buildings.Fluid.Chillers.Validation;
model Carnot_TEva_reverseFlow
  "Test model for chiller based on Carnot efficiency and evaporator outlet temperature control signal"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal=-100E3
    "Evaporator heat flow rate";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=QEva_flow_nominal/
      dTEva_nominal/4200 "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=m2_flow_nominal*(
      COPc_nominal + 1)/COPc_nominal
    "Nominal mass flow rate at condenser water wide";

  Buildings.Fluid.Chillers.Carnot_TEva chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    use_eta_Carnot_nominal=true,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    show_T=true,
    QEva_flow_nominal=QEva_flow_nominal,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal=6000,
    dp2_nominal=6000) "Chiller model"
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(nPorts=1,
    redeclare package Medium = Medium1,
    m_flow=m1_flow_nominal,
    use_T_in=false,
    use_m_flow_in=true,
    T=298.15)
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(nPorts=1,
    redeclare package Medium = Medium2,
    m_flow=m2_flow_nominal,
    use_T_in=false,
    use_m_flow_in=true,
    T=295.15)
    annotation (Placement(transformation(extent={{70,-16},{50,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={80,30})));
  Buildings.Fluid.Sources.Boundary_pT sin2(nPorts=1,
    redeclare package Medium = Medium2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-80,-30})));
  Modelica.Blocks.Sources.Constant TEvaLvg(k=273.15 + 10)
    "Control signal for evaporator leaving temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Gain mCon_flow(k=-1/cp1_default/dTEva_nominal)
    "Condenser mass flow rate"
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
  Modelica.Blocks.Math.Add QCon_flow(k2=-1) "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp1_default=
      Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      Medium1.p_default,
      Medium1.T_default,
      Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
  Modelica.Blocks.Sources.Ramp mEva_flow(
    duration=60,
    startTime=1800,
    height=-2*m2_flow_nominal,
    offset=m2_flow_nominal) "Mass flow rate for evaporator"
    annotation (Placement(transformation(extent={{98,-8},{78,12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConEnt(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    tau=0) "Temperature sensor for fluid entering condenser"
    annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    tau=0) "Temperature sensor for fluid leaving condenser"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaEnt(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    tau=0) "Temperature sensor for fluid entering evaporator"
    annotation (Placement(transformation(extent={{46,-16},{26,4}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaLvg(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal,
    tau=0) "Temperature sensor for fluid leaving evaporator"
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));
equation
  connect(TEvaLvg.y, chi.TSet) annotation (Line(points={{-19,40},{-12,40},{-12,10},
          {-12,9},{-4,9}},
                  color={0,0,127}));
  connect(chi.P, QCon_flow.u1) annotation (Line(points={{19,0},{24,0},{24,-54},{
          38,-54}}, color={0,0,127}));
  connect(chi.QEva_flow, QCon_flow.u2) annotation (Line(points={{19,-9},{22,-9},
          {22,-66},{38,-66}}, color={0,0,127}));
  connect(QCon_flow.y, mCon_flow.u) annotation (Line(points={{61,-60},{70,-60},{
          70,-80},{-98,-80},{-98,14},{-92,14}}, color={0,0,127}));
  connect(mCon_flow.y, sou1.m_flow_in)
    annotation (Line(points={{-69,14},{-62,14}},          color={0,0,127}));
  connect(mEva_flow.y, sou2.m_flow_in)
    annotation (Line(points={{77,2},{72,2}},        color={0,0,127}));
  connect(sou1.ports[1], senTConEnt.port_a)
    annotation (Line(points={{-40,6},{-30,6}}, color={0,127,255}));
  connect(senTConEnt.port_b, chi.port_a1)
    annotation (Line(points={{-10,6},{-2,6}}, color={0,127,255}));
  connect(chi.port_b1, senTConLvg.port_a) annotation (Line(points={{18,6},{30,6},
          {30,30},{40,30}}, color={0,127,255}));
  connect(senTConLvg.port_b, sin1.ports[1])
    annotation (Line(points={{60,30},{70,30}}, color={0,127,255}));
  connect(sou2.ports[1], senTEvaEnt.port_a)
    annotation (Line(points={{50,-6},{46,-6}}, color={0,127,255}));
  connect(senTEvaEnt.port_b, chi.port_a2)
    annotation (Line(points={{26,-6},{18,-6}}, color={0,127,255}));
  connect(sin2.ports[1], senTEvaLvg.port_b)
    annotation (Line(points={{-70,-30},{-50,-30}}, color={0,127,255}));
  connect(senTEvaLvg.port_a, chi.port_b2) annotation (Line(points={{-30,-30},{-10,
          -30},{-10,-6},{-2,-6}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_TEva_reverseFlow.mos"
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
<p>
This example checks the correct behavior if a mass flow rate attains zero.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 9, 2024, by Hongxiang Fu:<br/>
Added two-port temperature sensors to replace <code>sta_*.T</code>
in reference results. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1913\">IBPSA #1913</a>.
</li>
<li>
February 10, 2023, by Michael Wetter:<br/>
Removed binding of parameter with same value as the default.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1692\">#1692</a>.
</li>
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
end Carnot_TEva_reverseFlow;

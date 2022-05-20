within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model DiversionCircuitOpenLoop
  "Model illustrating the operation of three-way valves with constant speed pump"
  extends Modelica.Icons.Example;

  replaceable model ThreeWayValve =
      Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Boolean is_bypBal = false
    "Set to true for a balancing valve in the bypass";

  parameter Modelica.Units.SI.MassFlowRate mTer_flow_nominal = 1
    "Terminal unit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure dpTer_nominal(
    final min=0,
    displayUnit="Pa") = 5E4
    "Terminal unit pressure drop at design conditions";
  parameter Modelica.Units.SI.Pressure dpValve_nominal(
    final min=0,
    displayUnit="Pa") = dpTer_nominal
    "Control valve pressure drop at design conditions";
  parameter Modelica.Units.SI.Pressure dpPip_nominal(
    final min=0,
    displayUnit="Pa") = 1E4
    "Pipe section pressure drop at design conditions";
  parameter Real kSizPum(
    final min=1,
    final unit="1") = 1.0
    "Pump head oversizing coefficient";
  final parameter Modelica.Units.SI.Pressure dpPum_nominal(
    final min=0,
    displayUnit="Pa")=
    (2 * dpPip_nominal + dpTer_nominal + dpValve_nominal) * kSizPum
    "Pump head at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal = 2 * mTer_flow_nominal
    "Pump mass flow rate at design conditions";

  parameter Modelica.Units.SI.Pressure p_min = 2E5
    "Circuit minimum pressure";

  parameter Modelica.Units.SI.PressureDifference dpBal2_nominal(
    final min=0,
    displayUnit="Pa") = if is_bypBal then dpTer_nominal else 0
    "Secondary balancing valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TAirEnt_nominal = 20 + 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal = 60 + 273.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal = 50 + 273.15
    "Hot water leaving temperature at design conditions";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    final T=TLiqEnt_nominal,
    nPorts=3)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-70})));
  Movers.SpeedControlled_y pum(
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    per(pressure(
      V_flow={0,1,2} * mPum_flow_nominal / 996,
      dp(displayUnit="Pa") = {1.5, 1, 0} * dpPum_nominal)),
    inputType=Buildings.Fluid.Types.InputType.Constant)
    "Circulation pump"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  ActiveNetworks.Diversion con(
    redeclare replaceable ThreeWayValve val(fraK=1),
    redeclare final package Medium=MediumLiq,
    final use_lumFloRes=false,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mTer_flow_nominal,
    final dpSec_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpPum_nominal - dpPip_nominal - dpTer_nominal - dpValve_nominal,
    final dpBal2_nominal=dpBal2_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load loa(
    redeclare final package MediumLiq = MediumLiq,
    final dpLiq_nominal=dpTer_nominal,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant fraLoa(k=1)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ope(duration=100)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  ActiveNetworks.Diversion con1(
    redeclare replaceable ThreeWayValve val(fraK=1),
    final use_lumFloRes=false,
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mTer_flow_nominal,
    final dpSec_nominal=dpTer_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpBal1_nominal=dpPum_nominal - 2 * dpPip_nominal - dpTer_nominal - dpValve_nominal,
    final dpBal2_nominal=dpBal2_nominal)
    "Hydronic connection"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses.Load loa1(
    redeclare final package MediumLiq = MediumLiq,
    final dpLiq_nominal=dpTer_nominal,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    k=10) "Load"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  FixedResistances.PressureDrop res(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mPum_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mTer_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Sensors.RelativePressure dp(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Sensors.RelativePressure dp1(
    redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Sources.RealExpression ope1(y=1 - ope.y)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  connect(ref.ports[1], pum.port_a) annotation (Line(points={{-21.3333,-60},{
          -100,-60},{-100,-40},{-70,-40}},
                            color={0,127,255}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{4,30},{4,40},{0,40},
          {0,60}},      color={0,127,255}));
  connect(loa.port_b, con.port_a2) annotation (Line(points={{20,60},{20,40},{16,
          40},{16,29.8}}, color={0,127,255}));
  connect(fraLoa.y, loa.u) annotation (Line(points={{-68,80},{-20,80},{-20,66},{
          -2,66}},
        color={0,0,127}));
  connect(con1.port_b2, loa1.port_a) annotation (Line(points={{64,30},{64,40},{60,
          40},{60,60}}, color={0,127,255}));
  connect(con1.port_a2, loa1.port_b) annotation (Line(points={{76,29.8},{76,40},
          {80,40},{80,60}}, color={0,127,255}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-68,80},{40,80},{40,66},{58,
          66}}, color={0,0,127}));
  connect(ope.y, con.y) annotation (Line(points={{-68,40},{-60,40},{-60,20},{-2,
          20}}, color={0,0,127}));
  connect(pum.port_b, res.port_a)
    annotation (Line(points={{-50,-40},{-30,-40}}, color={0,127,255}));
  connect(res.port_b, res1.port_a)
    annotation (Line(points={{-10,-40},{30,-40}}, color={0,127,255}));
  connect(res.port_b, dp.port_a)
    annotation (Line(points={{-10,-40},{0,-40},{0,-20}},   color={0,127,255}));
  connect(dp.port_b, ref.ports[2]) annotation (Line(points={{20,-20},{20,-60},{-20,
          -60}}, color={0,127,255}));
  connect(dp1.port_a, res1.port_b)
    annotation (Line(points={{60,-20},{60,-40},{50,-40}}, color={0,127,255}));
  connect(dp1.port_a, con1.port_a1) annotation (Line(points={{60,-20},{60,0},{64,
          0},{64,10}}, color={0,127,255}));
  connect(con1.port_b1, dp1.port_b) annotation (Line(points={{76,10},{76,0},{80,
          0},{80,-20}},  color={0,127,255}));
  connect(dp1.port_b, ref.ports[3]) annotation (Line(points={{80,-20},{80,-60},
          {-18.6667,-60}},color={0,127,255}));
  connect(con.port_b1, dp.port_b) annotation (Line(points={{16,10},{16,2},{20,2},
          {20,-20}}, color={0,127,255}));
  connect(con.port_a1, dp.port_a) annotation (Line(points={{4,10},{4,2},{0,2},{0,
          -20}},     color={0,127,255}));
  connect(ope1.y, con1.y) annotation (Line(points={{-69,0},{40,0},{40,20},{58,
          20}}, color={0,0,127}));
   annotation (experiment(
    StopTime=200,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionCircuitOpenLoop.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of a diversion circuit to modulate
the heat flow rate transmitted to a constant load.
Two identical secondary circuits are connected to a primary circuit 
with a constant speed pump.
The valve of the circuit closest to the pump is actuated
from fully closed to fully open position.
The valve of the remote circuit closest is actuated 
with a complementary control signal.
</p>
<ul>
<li> 
Secondary and valve flow resistances are not lumped together
so that the valve authority can be computed as
<code>val.res1.dp / val.res2.dp</code> when the valve is
fully open.
</li>
<li> 
The design conditions are defined without considering
any load diversity.
</li>
<li> 
Each circuit is balanced at design conditions.
</li>
<li> 
The bypass branch of the three-way valve is balanced at
design conditions if the parameter <code>is_bypBal</code>
is set to <code>true</code>. Otherwise no fixed flow
resistance is considered in the bypass branch, only the 
variable flow resistance corresponding to the control valve.
</li> 
</ul>
<p>
When simulated with the default parameter values, this example 
shows the following points.
</p>
<ul>
<li> 
The overflow caused by the unbalanced bypass branch when the valve
is fully closed (see plot #1).
This creates a concomitant flow shortage in the other circuit with the
valve fully open. 
However, the flow shortage (<i>6%</i>) is of a much lower amplitude than the overflow
(<i>27%</i>).
Indeed the equivalent flow resistance seen by the pump is lower than at
design conditions, leading a shift of the operating point of the pump
towards a flow rate value higher than design, which partly compensates
for the overflow.
</li> 
<li>
The impact on the heat flow rate transferred to the load is even is of an
even lower amplitude (<i>2%</i>) due to the emission characteristic of the
terminal unit.
</li>
</ul>
<p>
Those observations are confirmed by a sensitivity study to the following
parameters.
</p>
<ul>
<li>
Ratio of the terminal unit pressure drop to the pump head at 
design conditions: 
<i>&psi; = &Delta;p<sub>J-A</sub> / &Delta;p<sub>pump</sub></i> 
varying from <i>0.1</i> to <i>0.4</i>  
</li>
<li>
Ratio of the control valve authority: 
<i>&beta; = &Delta;p<sub>A-AB</sub> / &Delta;p<sub>J-AB</sub></i> 
varying from <i>0.1</i> to <i>0.7</i>  
</li>
<li>
Balanced bypass branch:
<code>is_bypBal</code> switched from <code>false</code> to <code>true</code>
</li>
<li>
Valve characteristic:
<code>ThreeWayValve</code> switched from equal percentage-linear (EL) to
linear-linear (LL).
</li>
<br/>
</ul>
<p>
<img alt=\"Diversion circuit bypass flow rate\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionCircuitOpenLoop_mBypass.png\"/>
</p>
<p>
<img alt=\"Diversion circuit direct flow rate\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionCircuitOpenLoop_mDirect.png\"/>
</p>
<p>
<img alt=\"Diversion circuit pump flow rate\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionCircuitOpenLoop_mPump.png\"/>
</p>
<p>
<img alt=\"Diversion circuit heat flow rate fully open\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionCircuitOpenLoop_Q100.png\"/>
</p>
<p>
<img alt=\"Diversion circuit heat flow rate 10% open\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DiversionCircuitOpenLoop_Q10.png\"/>
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})));
end DiversionCircuitOpenLoop;

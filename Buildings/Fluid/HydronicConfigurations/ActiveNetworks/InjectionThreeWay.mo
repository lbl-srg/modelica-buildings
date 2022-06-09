within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionThreeWay "Injection circuit with three-way valve"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=0.3e4,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.ThreeWay,
    final have_bypFix=true,
    final have_pum=true);

  Buildings.Fluid.HydronicConfigurations.Components.ThreeWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    final energyDynamics=energyDynamics,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal={0, 0},
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3)
    "Control valve"
    annotation (
      choicesAllMatching = true,
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-40})));
  FixedResistances.Junction jun(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3)) "Junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-40})));
  FixedResistances.Junction junBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  FixedResistances.Junction junBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m2_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
  FixedResistances.PressureDrop bal1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-80})));
  FixedResistances.PressureDrop bal2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dpBal2_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,30})));
  Buildings.Fluid.HydronicConfigurations.Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPumMod,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=perPum)
    "Pump"
    annotation (
      choicesAllMatching = true,
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort T2Sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit supply temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  Controls.PIDWithOperatingMode ctl(
    final reverseActing=typFun==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti) if have_ctl
    "Controller"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(
    final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch on/off"
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{50,22},{30,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant One(final k=1)
    if typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant
    "one"
    annotation (Placement(transformation(extent={{50,70},{30,90}})));
  Sensors.TemperatureTwoPort T2Ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then 0
         else 1) "Consumer circuit return temperature sensor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,60})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(final nin=2)
    "Select measured signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-80})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant ctlVar(
    final k=Integer(typCtl))
    "Controlled variable selector"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
equation
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-50,-40},{50,-40}}, color={0,127,255}));
  connect(junBypRet.port_2, val.port_1)
    annotation (Line(points={{60,-10},{60,-30},{60,-30}}, color={0,127,255}));
  connect(junBypSup.port_3, junBypRet.port_3)
    annotation (Line(points={{-50,0},{50,0}}, color={0,127,255}));
  connect(jun.port_2, junBypSup.port_1)
    annotation (Line(points={{-60,-30},{-60,-10}}, color={0,127,255}));
  connect(port_a1, jun.port_1)
    annotation (Line(points={{-60,-100},{-60,-50}}, color={0,127,255}));
  connect(port_b1, bal1.port_b)
    annotation (Line(points={{60,-100},{60,-90}}, color={0,127,255}));
  connect(bal1.port_a, val.port_2)
    annotation (Line(points={{60,-70},{60,-50}}, color={0,127,255}));
  connect(bal2.port_b, junBypRet.port_1)
    annotation (Line(points={{60,20},{60,10}}, color={0,127,255}));
  connect(junBypSup.port_2, pum.port_a)
    annotation (Line(points={{-60,10},{-60,30}}, color={0,127,255}));
  connect(pum.port_b, T2Sup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(T2Sup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(mod, ctl.mod) annotation (Line(points={{-120,80},{-20,80},{-20,-80},{34,
          -80},{34,-72}},
        color={255,127,0}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-80,-40},{-80,-60},
          {28,-60}},  color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-20},{80,-20},
          {80,-40},{72,-40}}, color={0,0,127}));
  connect(mod, isEna.u)
    annotation (Line(points={{-120,80},{-12,80}}, color={255,127,0}));
  connect(isEna.y, swi.u2) annotation (Line(points={{12,80},{16,80},{16,40},{12,
          40}}, color={255,0,255}));
  connect(yPum, swi.u1) annotation (Line(points={{-120,40},{-80,40},{-80,56},{20,
          56},{20,48},{12,48}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{28,32},{12,32}}, color={0,0,127}));
  connect(swi.y, pum.y)
    annotation (Line(points={{-12,40},{-32,40},{-32,40},{-48,40}},
                                                 color={0,0,127}));
  connect(One.y, swi.u1) annotation (Line(points={{28,80},{20,80},{20,48},{12,48}},
        color={0,0,127}));
  connect(port_a2, T2Ret.port_a)
    annotation (Line(points={{60,100},{60,70}}, color={0,127,255}));
  connect(T2Ret.port_b, bal2.port_a)
    annotation (Line(points={{60,50},{60,40}}, color={0,127,255}));
  connect(extIndSig.y, ctl.u_m) annotation (Line(points={{-40,-92},{-40,-96},{40,
          -96},{40,-72}}, color={0,0,127}));
  connect(T2Sup.T, extIndSig.u[1]) annotation (Line(points={{-49,60},{-40.5,60},
          {-40.5,-68}},    color={0,0,127}));
  connect(T2Ret.T, extIndSig.u[2])
    annotation (Line(points={{49,60},{-39.5,60},{-39.5,-68}},
                                                          color={0,0,127}));
  connect(ctl.y, val.y) annotation (Line(points={{52,-60},{80,-60},{80,-40},{72,
          -40}}, color={0,0,127}));
  connect(ctlVar.y, extIndSig.index)
    annotation (Line(points={{-68,-80},{-52,-80}}, color={255,127,0}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{67,-46},{67,-50},
          {90,-50},{90,-60},{120,-60}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{-51,52},{-51,54},{80,54},{80,
          60},{120,60}}, color={0,0,127}));
  connect(pum.y_actual, yPum_actual) annotation (Line(points={{-53,52},{80,52},
          {80,40},{120,40}}, color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionThreeWayValve.svg")}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Lumped flow resistance includes control valve only.
Primary balancing valve always modeled as a distinct
flow resistance.
</p>
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature different from the primary circuit
(for instance underfloor heating systems).
The reduced flow through the control valve due to the intermediary 
bypass allows selecting a smaller valve for the same design pressure drop.
The pressure drop through the control valve is compensated by the primary pump, 
reducing the secondary pump head.
The control valve authority is close to <i>1</i> (<i>&Delta;p<sub>A-AB</sub> &asymp;
&Delta;p<sub>J-AB</sub></i>) so the sizing is only based on a 
minimum pressure drop of <i>3</i> kPa at design flow rate.
</p>
<p>
The balancing procedure should ensure that the three-way valve is fully
open at design conditions. This gives the following relationship
between the primary and secondary mass flow rate, involving the secondary
supply and return temperature and the primary supply temperature.
</p>
<p>
<i>
m&#775;<sub>1, design</sub> = m&#775;<sub>2, design</sub> *
(T<sub>2, sup, design</sub> - T<sub>2, ret, design</sub>) / 
(T<sub>1, sup, design</sub> - T<sub>2, ret, design</sub>)
</i>
</p>
<p>
Improper balancing is not detrimental to the consumer circuit operation:
the control valve compensates for the elevated pressure differential
by working at a lower opening fraction in average.
However, the primary circuit operation is degraded with a lower <i>&Delta;T</i>
and a higher mass flow rate. See
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionThreeWayValve\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionThreeWayValve</a>
for a numerical illustration of improper balancing.
</p>
<h4>
Parameterization
</h4>
<p>
By default the secondary pump is parameterized with <code>m2_flow_nominal</code> 
and <code>dp2_nominal</code> at maximum speed.
The partner valve <code>bal2</code> is therefore configured with zero
pressure drop.
</p>
</html>"));
end InjectionThreeWay;

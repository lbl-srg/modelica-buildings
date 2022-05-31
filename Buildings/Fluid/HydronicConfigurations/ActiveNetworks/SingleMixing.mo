within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model SingleMixing "Single mixing circuit"
  extends
    Buildings.Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
      dat(m1_flow_nominal=m2_flow_nominal),
      final have_bypFix=false,
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
    final dpFixed_nominal=if use_lumFloRes then {dpBal1_nominal, 0} else {0,0},
    final flowCharacteristics1=dat.flowCharacteristics1,
    final flowCharacteristics3=dat.flowCharacteristics3)
    "Control valve"
    annotation (
      choicesAllMatching = true,
      Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,-40})));
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
    final dp_nominal=fill(0, 3))
    "Junction"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-40})));
  FixedResistances.PressureDrop bal1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-70})));
  FixedResistances.PressureDrop bal2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dpBal2_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,50})));
  Buildings.Fluid.HydronicConfigurations.Components.Pump pum(
    redeclare final package Medium = Medium,
    final typ=typPumMod,
    final m_flow_nominal=m2_flow_nominal,
    final dp_nominal=dp2_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=dat.pum)
    "Pump"
    annotation (
      choicesAllMatching = true,
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState then 0 else 1)
    "Secondary supply temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  Controls.PIDWithOperatingMode ctl(
    final reverseActing=typFun==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=dat.ctl.controllerType,
    final k=dat.ctl.k,
    final Ti=dat.ctl.Ti,
    final Ni=dat.ctl.Ni,
    final y_reset=dat.ctl.y_reset) if have_ctl
    "Controller"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold isEna(
    final t=Controls.OperatingModes.disabled)
    "Returns true if enabled"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch on/off"
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{50,22},{30,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant One(final k=1)
    if typPum==Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleConstant
    "one"
    annotation (Placement(transformation(extent={{50,60},{30,80}})));
equation
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{50,-40},{-50,-40}}, color={0,127,255}));
  connect(port_b1, bal1.port_b)
    annotation (Line(points={{60,-100},{60,-80}}, color={0,127,255}));
  connect(port_a2, bal2.port_a)
    annotation (Line(points={{60,100},{60,60}}, color={0,127,255}));
  connect(pum.port_b, TSup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(TSup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(ctl.y, val.y) annotation (Line(points={{12,-20},{20,-20},{20,-60},{-80,
          -60},{-80,-40},{-72,-40}},
                 color={0,0,127}));
  connect(mod, ctl.mod) annotation (Line(points={{-120,80},{-90,80},{-90,-56},{-6,
          -56},{-6,-32}},
        color={255,127,0}));
  connect(TSup.T, ctl.u_m) annotation (Line(points={{-49,60},{-20,60},{-20,-36},
          {0,-36},{0,-32}}, color={0,0,127}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-94,-40},{-94,-20},
          {-12,-20}}, color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,-40},{-72,
          -40}},              color={0,0,127}));
  connect(mod, isEna.u)
    annotation (Line(points={{-120,80},{-42,80}}, color={255,127,0}));
  connect(isEna.y, swi.u2) annotation (Line(points={{-18,80},{26,80},{26,40},{12,
          40}}, color={255,0,255}));
  connect(yPum, swi.u1) annotation (Line(points={{-120,40},{-84,40},{-84,56},{20,
          56},{20,48},{12,48}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{28,32},{12,32}}, color={0,0,127}));
  connect(swi.y, pum.y)
    annotation (Line(points={{-12,40},{-48,40}}, color={0,0,127}));
  connect(One.y, swi.u1) annotation (Line(points={{28,70},{20,70},{20,48},{12,48}},
        color={0,0,127}));
  connect(jun.port_2, bal1.port_a)
    annotation (Line(points={{60,-50},{60,-60}}, color={0,127,255}));
  connect(bal2.port_b, jun.port_1)
    annotation (Line(points={{60,40},{60,-30},{60,-30}}, color={0,127,255}));
  connect(val.port_2, pum.port_a)
    annotation (Line(points={{-60,-30},{-60,30}}, color={0,127,255}));
  connect(val.port_1, port_a1)
    annotation (Line(points={{-60,-50},{-60,-100}}, color={0,127,255}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/SingleMixing.svg")}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Variable primary
</p>
    
<p>
This is a typical configuration for constant flow secondary circuits that
have a design supply temperature identical to the primary circuit.

The control valve authority is close to <i>1</i> (<i>&Delta;p<sub>A-AB</sub> &asymp;
&Delta;p<sub>J-AB</sub></i>) so the sizing is only based on a 
minimum pressure drop of <i>3</i> kPa at design flow rate.
</p>
<p>
The balancing procedure should ensure that the 
primary pressure differential is compensated for by the primary balancing valve.
Otherwise, the flow may reverse in the bypass branch and the mixing function of
the three-way valve cannot be achieved.
Valve authority = Δp_V / (Δp1 + Δp_Vbyp) (independent of the balancing valve Δp). For good authority Δp_V~Δp1 which must be compensated for by the secondary pump. 
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
end SingleMixing;

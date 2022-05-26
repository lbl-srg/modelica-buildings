within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model InjectionThreeWayValve "Injection circuit with three-way valve"
  extends
    Buildings.Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
      dat(dpValve_nominal=dpSec_nominal),
      final have_pum=true);

  replaceable Actuators.Valves.ThreeWayEqualPercentageLinear val
    constrainedby Actuators.Valves.ThreeWayEqualPercentageLinear(
      redeclare final package Medium=Medium,
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
      final m_flow_nominal=m_flow_nominal,
      final dpValve_nominal=dpValve_nominal,
      final dpFixed_nominal={dpSec_nominal, dpBal2_nominal} .*
        (if use_lumFloRes then {1, 1} else {0, 1}))
    "Control valve"
    annotation (Placement(
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
    final m_flow_nominal=m_flow_nominal .* {1,-1,-1},
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
    final m_flow_nominal=m_flow_nominal .* {1,-1,1},
    final dp_nominal=fill(0, 3)) "Junction" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  FixedResistances.Junction jun2(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m_flow_nominal .* {1,-1,-1},
    final dp_nominal=fill(0, 3)) "Junction"
     annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
  FixedResistances.PressureDrop bal1(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpBal1_nominal)
    "Primary balancing valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-70})));
  FixedResistances.PressureDrop bal2(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpBal2_nominal)
    "Primary balancing valve" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,50})));
  replaceable Movers.SpeedControlled_y pum
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    redeclare final package Medium = Medium,
    final per=dat.pum)
    "Pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,40})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    tau=if energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState then 0 else 1)
    "Secondary supply temperature sensor" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,60})));
  .Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea if have_y1Pum
    "Convert input signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Controls.PIDWithOperatingMode ctl(
    final reverseActing=typFun==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating,
    final yMin=0,
    final yMax=1,
    final controllerType=dat.controllerType,
    final k=dat.k,
    final Ti=dat.Ti,
    final Ni=dat.Ni,
    final y_reset=dat.y_reset) if have_ctl
    "Controller"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(jun.port_3, val.port_3)
    annotation (Line(points={{-50,-40},{50,-40}}, color={0,127,255}));
  connect(jun2.port_2, val.port_1)
    annotation (Line(points={{60,-10},{60,-30},{60,-30}}, color={0,127,255}));
  connect(junBypSup.port_3, jun2.port_3)
    annotation (Line(points={{-50,0},{50,0}}, color={0,127,255}));
  connect(jun.port_2, junBypSup.port_1)
    annotation (Line(points={{-60,-30},{-60,-10}}, color={0,127,255}));
  connect(port_a1, jun.port_1)
    annotation (Line(points={{-60,-100},{-60,-50}}, color={0,127,255}));
  connect(port_b1, bal1.port_b)
    annotation (Line(points={{60,-100},{60,-80}}, color={0,127,255}));
  connect(bal1.port_a, val.port_2)
    annotation (Line(points={{60,-60},{60,-50}}, color={0,127,255}));
  connect(port_a2, bal2.port_a)
    annotation (Line(points={{60,100},{60,60}}, color={0,127,255}));
  connect(bal2.port_b, jun2.port_1)
    annotation (Line(points={{60,40},{60,10}}, color={0,127,255}));
  connect(junBypSup.port_2, pum.port_a)
    annotation (Line(points={{-60,10},{-60,30}}, color={0,127,255}));
  connect(pum.port_b, TSup.port_a)
    annotation (Line(points={{-60,50},{-60,50}}, color={0,127,255}));
  connect(TSup.port_b, port_b2)
    annotation (Line(points={{-60,70},{-60,100}}, color={0,127,255}));
  connect(y1Pum, booToRea.u) annotation (Line(points={{-120,80},{-92,80}},
                     color={255,0,255}));
  connect(booToRea.y, pum.y) annotation (Line(points={{-68,80},{-66,80},{-66,68},
          {-80,68},{-80,40},{-72,40}},
                     color={0,0,127}));
  connect(yPum, pum.y)
    annotation (Line(points={{-120,40},{-72,40}}, color={0,0,127}));
  connect(ctl.y, val.y) annotation (Line(points={{12,-20},{80,-20},{80,-40},{72,
          -40}}, color={0,0,127}));
  connect(mod, ctl.mod) annotation (Line(points={{-120,-80},{-6,-80},{-6,-32}},
        color={255,127,0}));
  connect(TSup.T, ctl.u_m) annotation (Line(points={{-49,60},{-20,60},{-20,-60},
          {0,-60},{0,-32}}, color={0,0,127}));
  connect(set, ctl.u_s) annotation (Line(points={{-120,-40},{-80,-40},{-80,-20},
          {-12,-20}}, color={0,0,127}));
  connect(yVal, val.y) annotation (Line(points={{-120,0},{-80,0},{-80,20},{80,20},
          {80,-40},{72,-40}}, color={0,0,127}));
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
</html>"));
end InjectionThreeWayValve;

within Buildings.Fluid.HydronicConfigurations.Components;
model ThreeWayValve "Container class for three-way valves"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1);
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
    rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic
    typCha=Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Valve characteristic"
    annotation (Dialog(group="Configuration"), Evaluate=true);

  parameter Buildings.Fluid.Actuators.Valves.Data.Generic flowCharacteristics1(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for direct flow path at port_1"
     annotation (
     Dialog(enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
     choicesAllMatching=true, Placement(transformation(extent={{-30,-68},{-10,-48}})));
  parameter Buildings.Fluid.Actuators.Valves.Data.Generic flowCharacteristics3(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for bypass flow path at port_3"
    annotation (
    Dialog(enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
    choicesAllMatching=true, Placement(transformation(extent={{10,-68},{30,-48}})));

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal[2](
    each displayUnit="Pa")={0,0}
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation (Dialog(group="Nominal condition"));

  parameter Real R = 50 "Rangeability, R=50...100 typically"
    annotation(Dialog(
      enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage));
  parameter Real delta0 = 0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(
      enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage));

  parameter Real fraK(min=0, max=1) = 1.0
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)";
  parameter Real[2] l(each min=0, each max=1) = {0.0001, 0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));

  parameter Boolean[2] linearized = {false, false}
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_1"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_2"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_3"
   annotation(Dialog(tab="Advanced"));
  parameter Boolean verifyFlowReversal = false
    "=true, to assert that the flow does not reverse when portFlowDirection_* does not equal Bidirectional"
    annotation(Dialog(tab="Advanced"));

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));


  final parameter Modelica.Units.SI.PressureDifference dp3Valve_nominal(
    displayUnit="Pa")=dpValve_nominal/fraK^2
    "Bypass branch valve pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dp3Fixed_nominal(
    displayUnit="Pa")=dpFixed_nominal[2]
    "Bypass branch fixed pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dp3_nominal(
    displayUnit="Pa")=dp3Valve_nominal + dp3Fixed_nominal
    "Bypass branch total pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  // Variables
  Modelica.Units.SI.MassFlowRate m1_flow = port_1.m_flow
    "Mass flow rate in direct branch";
  Modelica.Units.SI.MassFlowRate m2_flow = -1 * port_2.m_flow
    "Mass flow rate in common branch";
  Modelica.Units.SI.MassFlowRate m3_flow = port_3.m_flow
    "Mass flow rate in bypass branch";
  Modelica.Units.SI.PressureDifference dp1(displayUnit="Pa") = port_1.p - port_2.p
    "Pressure drop across direct branch";
  Modelica.Units.SI.PressureDifference dp3(displayUnit="Pa") = port_3.p - port_2.p
    "Pressure drop across bypass branch";

  Modelica.Fluid.Interfaces.FluidPort_a port_1(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    m_flow(min=if (portFlowDirection_1 == Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_1== Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "First port, typically inlet"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    m_flow(min=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "Second port, typically outlet"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_3(
    redeclare final package Medium=Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default),
    m_flow(min=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
           max=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    "Third port, can be either inlet or outlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(final unit="1")
    "Input control signal"
    annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(extent={{-20,-20},{20,
            20}},
        rotation=-90,
        origin={0,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y_actual
    "Actual actuator position"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{40,50},{80,90}})));

  Actuators.Valves.ThreeWayEqualPercentageLinear valEquLin(
    redeclare final package Medium = Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final R=R,
    final delta0=delta0,
    final l=l,
    final fraK=fraK,
    final deltaM=deltaM,
    final tau=tau,
    final from_dp=from_dp,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final verifyFlowReversal=verifyFlowReversal,
    final linearized=linearized,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final use_strokeTime=use_inputFilter,
    final strokeTime=riseTime,
    final init=init,
    final y_start=y_start) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Three-way valve with equal percentage and linear characteristics"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Actuators.Valves.ThreeWayLinear valLinLin(
    redeclare final package Medium = Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final l=l,
    final fraK=fraK,
    final deltaM=deltaM,
    final tau=tau,
    final from_dp=from_dp,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final verifyFlowReversal=verifyFlowReversal,
    final linearized=linearized,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final use_strokeTime=use_inputFilter,
    final strokeTime=riseTime,
    final init=init,
    final y_start=y_start) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Linear
    "Three-way valve with linear characteristics"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Actuators.Valves.ThreeWayTable valTab(
    redeclare final package Medium = Medium,
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final fraK=fraK,
    final deltaM=deltaM,
    final tau=tau,
    final from_dp=from_dp,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final verifyFlowReversal=verifyFlowReversal,
    final linearized=linearized,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final use_strokeTime=use_inputFilter,
    final strokeTime=riseTime,
    final init=init,
    final y_start=y_start) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table
    "Three-way valve with table-specified characteristics"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));

initial equation
  assert(typCha<>Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.PressureIndependent,
    "In " + getInstanceName() +
    ": The pressure independent option is only available for two-way valves.");

equation

  connect(y, valEquLin.y)
    annotation (Line(points={{0,120},{0,12}}, color={0,0,127}));
  connect(valEquLin.y_actual, y_actual)
    annotation (Line(points={{5,7},{90,7},{90,60},{120,60}}, color={0,0,127}));
  connect(port_3, valEquLin.port_3)
    annotation (Line(points={{0,-100},{0,-10}}, color={0,127,255}));
  connect(valEquLin.port_2, port_2)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_1, valEquLin.port_1)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(port_1, valLinLin.port_1) annotation (Line(points={{-100,0},{-80,0},{-80,
          40},{-70,40}}, color={0,127,255}));
  connect(y, valLinLin.y) annotation (Line(points={{0,120},{0,60},{-60,60},{-60,
          52}}, color={0,0,127}));
  connect(valLinLin.port_3, port_3) annotation (Line(points={{-60,30},{-60,-80},
          {0,-80},{0,-100}}, color={0,127,255}));
  connect(y, valTab.y) annotation (Line(points={{0,120},{0,60},{60,60},{60,-28}},
        color={0,0,127}));
  connect(valTab.port_1, port_1) annotation (Line(points={{50,-40},{-80,-40},{-80,
          0},{-100,0}}, color={0,127,255}));
  connect(port_3, valTab.port_3) annotation (Line(points={{0,-100},{0,-80},{60,
          -80},{60,-50}}, color={0,127,255}));
  connect(valTab.port_2, port_2) annotation (Line(points={{70,-40},{80,-40},{80,
          0},{100,0}}, color={0,127,255}));
  connect(valTab.y_actual, y_actual) annotation (Line(points={{65,-33},{90,-33},
          {90,60},{120,60}}, color={0,0,127}));
  connect(valLinLin.y_actual, y_actual) annotation (Line(points={{-55,47},{90,47},
          {90,60},{120,60}}, color={0,0,127}));
  connect(valLinLin.port_2, port_2) annotation (Line(points={{-50,40},{80,40},{
          80,0},{100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="val",
    Icon(graphics={
        Line(
          points={{0,48},{0,108}}),
        Line(
          points={{0,70},{40,70}}),
        Rectangle(
          visible=use_inputFilter,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-20,94},{22,48}},
          textColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-40,126},{-160,76}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(y, format=".2f"))),
    Rectangle(
      extent={{-100,40},{100,-40}},
      lineColor={0,0,0},
      fillPattern=FillPattern.HorizontalCylinder,
      fillColor={192,192,192}),
    Rectangle(
      extent={{-100,22},{100,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.HorizontalCylinder,
      fillColor={0,127,255}),
    Rectangle(
      extent={{-60,40},{60,-40}},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Polygon(
      points={{0,0},{-76,60},{-76,-60},{0,0}},
      lineColor={0,0,0},
      fillColor=DynamicSelect({0,0,0}, y*{255,255,255}),
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{0,0},{76,60},{76,-60},{0,0}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{-40,-56},{40,-100}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={192,192,192}),
    Rectangle(
      extent={{-22,-56},{22,-100}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={0,127,255}),
    Polygon(
          points={{0,0},{60,-76},{-60,-76},{0,0}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({0,0,0}, (1-y)*{255,255,255}),
          fillPattern=FillPattern.Solid),
    Line(
      visible=use_inputFilter,
      points={{-30,40},{30,40}}),
            Line(
      points={{0,40},{0,0}}),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
This is a container class for three-way valve models from 
<a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a>.
</p>
<p>
The parameter <code>typCha</code> allows configuring the model 
by selecting the valve characteristic to be used based on the enumeration 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic\">
Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic</a>.
</p>
<p>
The default setting for the ratio of
the <i>Kvs</i> coefficient between the bypass branch and the
direct branch is <code>fraK=1.0</code>, see
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.UsersGuide.ControlValves\">
Buildings.Fluid.HydronicConfigurations.UsersGuide.ControlValves</a>
for the justification.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThreeWayValve;

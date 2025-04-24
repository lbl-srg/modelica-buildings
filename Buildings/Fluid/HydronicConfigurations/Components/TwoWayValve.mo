within Buildings.Fluid.HydronicConfigurations.Components;
model TwoWayValve "Container class for two-way valves"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1);
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
    rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  parameter Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic
    typCha=Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Valve characteristic"
    annotation (Dialog(group="Configuration"), Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0) = 0 "Pressure drop of pipe and other resistances that are in series"
    annotation (Dialog(group="Nominal condition"));

  parameter Real l(min=1e-10, max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  parameter Buildings.Fluid.Actuators.Valves.Data.Generic flowCharacteristics(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics"
    annotation (
    Dialog(enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table),
    choicesAllMatching=true, Placement(transformation(extent={{-20,-68},{0,-48}})));

  parameter Real R=50
    "Rangeability, R=50...100 typically"
    annotation(Dialog(
      enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(
      enable=typCha==Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close valve"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve"));
  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to open or close valve"
    annotation (Dialog(
      tab="Dynamics",
      group="Time needed to open or close valve",
      enable=use_strokeTime));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=use_strokeTime));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Time needed to open or close valve",enable=use_strokeTime));

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

  Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare final package Medium = Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final R=R,
    final delta0=delta0,
    final l=l,
    final deltaM=deltaM,
    final from_dp=from_dp,
    final allowFlowReversal=allowFlowReversal,
    final linearized=linearized,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=y_start) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.EqualPercentage
    "Two-way valve with equal percentage characteristic"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Actuators.Valves.TwoWayLinear valLin(
    redeclare final package Medium = Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final l=l,
    final deltaM=deltaM,
    final from_dp=from_dp,
    final allowFlowReversal=allowFlowReversal,
    final linearized=linearized,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=y_start) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Linear
    "Two-way valve with linear characteristic"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Actuators.Valves.TwoWayTable valTab(
    redeclare final package Medium = Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final deltaM=deltaM,
    final from_dp=from_dp,
    final allowFlowReversal=allowFlowReversal,
    final linearized=linearized,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=y_start,
    final flowCharacteristics=flowCharacteristics) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.Table
    "Two-way valve with table-specified characteristic"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Actuators.Valves.TwoWayPressureIndependent valPre(
    redeclare final package Medium = Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final rhoStd=rhoStd,
    final dpFixed_nominal=dpFixed_nominal,
    final l=l,
    final deltaM=deltaM,
    final from_dp=from_dp,
    final allowFlowReversal=allowFlowReversal,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final y_start=y_start) if typCha == Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic.PressureIndependent
    "Pressure-independent two-way valve"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
initial equation
  assert(dpFixed_nominal > -Modelica.Constants.eps, "In " + getInstanceName() +
  ": Model requires dpFixed_nominal >= 0 but received dpFixed_nominal = "
    + String(dpFixed_nominal) + " Pa.");
equation
  connect(y, valEqu.y)
    annotation (Line(points={{0,120},{0,80},{-20,80},{-20,12}},
                                              color={0,0,127}));
  connect(valEqu.y_actual, y_actual)
    annotation (Line(points={{-15,7},{90,7},{90,60},{120,60}},
                                                             color={0,0,127}));
  connect(port_a, valEqu.port_a)
    annotation (Line(points={{-100,0},{-30,0}}, color={0,127,255}));
  connect(valEqu.port_b, port_b)
    annotation (Line(points={{-10,0},{100,0}},color={0,127,255}));
  connect(port_a, valTab.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -40},{10,-40}}, color={0,127,255}));
  connect(port_a, valLin.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          40},{-70,40}}, color={0,127,255}));
  connect(valLin.port_b, port_b) annotation (Line(points={{-50,40},{80,40},{80,0},
          {100,0}}, color={0,127,255}));
  connect(valLin.y_actual, y_actual) annotation (Line(points={{-55,47},{90,47},{
          90,60},{120,60}}, color={0,0,127}));
  connect(y, valLin.y) annotation (Line(points={{0,120},{0,80},{-60,80},{-60,52}},
        color={0,0,127}));
  connect(y, valTab.y) annotation (Line(points={{0,120},{0,80},{20,80},{20,-28}},
        color={0,0,127}));
  connect(valTab.port_b, port_b) annotation (Line(points={{30,-40},{80,-40},{80,
          0},{100,0}}, color={0,127,255}));
  connect(valTab.y_actual, y_actual) annotation (Line(points={{25,-33},{90,-33},
          {90,60},{120,60}}, color={0,0,127}));
  connect(port_a, valPre.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -80},{50,-80}}, color={0,127,255}));
  connect(valPre.port_b, port_b) annotation (Line(points={{70,-80},{80,-80},{80,
          0},{100,0}}, color={0,127,255}));
  connect(y, valPre.y) annotation (Line(points={{0,120},{0,80},{60,80},{60,-68}},
        color={0,0,127}));
  connect(valPre.y_actual, y_actual) annotation (Line(points={{65,-73},{90,-73},
          {90,60},{120,60}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,10},{-100,10}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,10},{-100,10}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{0,48},{0,108}}),
        Line(
          points={{0,70},{40,70}}),
        Rectangle(
          visible=use_strokeTime,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_strokeTime,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_strokeTime,
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
    Line(
      visible=use_strokeTime,
      points={{-30,40},{30,40}}),
    Line(
      points={{0,40},{0,0}}),      Text(
          extent={{-74,20},{-36,-24}},
          textColor=DynamicSelect({255,255,255}, (1-y)*{255,255,255}),
          fillPattern=FillPattern.Solid,
          textString="%%")}), Documentation(revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a container class for two-way valve models from
<a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a>.
Note that the models
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPolynomial\">
Buildings.Fluid.Actuators.Valves.TwoWayPolynomial</a>
and
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening\">
Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening</a>
are not represented.
</p>
<p>
The parameter <code>typCha</code> allows configuring the model
by selecting the valve characteristic to be used based on the enumeration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic\">
Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic</a>.
</p>
</html>"));
end TwoWayValve;

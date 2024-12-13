within Buildings.Fluid.HydronicConfigurations.Components;
model Pump "Container class for circulating pumps"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal(
      final min=Modelica.Constants.small),
    show_T=false,
    port_a(
      h_outflow(start=h_outflow_start)),
    port_b(
      h_outflow(start=h_outflow_start),
      p(start=p_start),
      final m_flow(max = if allowFlowReversal then +Modelica.Constants.inf else 0)));

  parameter Buildings.Fluid.HydronicConfigurations.Types.Pump typ=
    Buildings.Fluid.HydronicConfigurations.Types.Pump.VariableInput
    "Type of secondary pump"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Buildings.Fluid.HydronicConfigurations.Types.PumpModel typMod=
    Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Speed
    "Type of pump model"
    annotation(Dialog(group="Configuration",
    enable=typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
    Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pump head at design conditions"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic(
      pressure(
        V_flow={0, 1, 2} * m_flow_nominal / rho_default,
        dp={1.14, 1, 0.42} * dp_nominal))
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Dialog(enable=typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
      Placement(transformation(extent={{-94,-94},{-74,-74}})));

  parameter Buildings.Fluid.Types.InputType inputType=
    Buildings.Fluid.Types.InputType.Continuous
    "Control input type"
    annotation(Dialog(
      group="Control",
      enable=typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation(Dialog(
      enable=typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None));

  // Classes used to implement the filtered speed
  parameter Boolean use_riseTime=true
    "Set to true to continuously change motor speed"
    annotation(Dialog(tab="Dynamics", group="Motor speed",
    enable=typ <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None));
  parameter Modelica.Units.SI.Time riseTime=30
    "Time needed to change motor speed between zero and full speed" annotation (
      Dialog(
      tab="Dynamics",
      group="Motor speed",
      enable=typ <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None and
          use_riseTime));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Motor speed",
    enable=typ <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None and
          use_riseTime));

  // Variables
  Modelica.Units.SI.VolumeFlowRate VMachine_flow = V_flow.V_flow
    "Volume flow rate";
  Modelica.Units.SI.PressureDifference dpMachine(displayUnit="Pa") = port_b.p - port_a.p
    "Pressure rise";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(
    final unit="1")
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Pump.VariableInput
    "Analog control signal"
    annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(extent={{-20,-20},{20,
            20}},
        rotation=-90,
        origin={0,120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1
    if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Start signal"
    annotation (Placement(transformation(
          extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60}),
     iconTransformation(extent={{-20,-20},{20,
            20}},
        rotation=0,
        origin={-52,70})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y_actual(
    final unit="1") if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Actual pump input value that is used for computations"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    quantity="Power",
    final unit="W") if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,70},{140,110}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));

  Movers.FlowControlled_dp pumDp(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=addPowerToMedium,
    final use_riseTime=use_riseTime,
    final riseTime=riseTime,
    final init=init,
    final per=per) if typ <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None
     and typMod == Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Head
    "Pump with ideally controlled head as input signal"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Movers.SpeedControlled_y pumSpe(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=addPowerToMedium,
    final use_riseTime=use_riseTime,
    final riseTime=riseTime,
    final init=init,
    final per=per) if typ <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None
     and typMod == Buildings.Fluid.HydronicConfigurations.Types.PumpModel.Speed
    "Pump with ideally controlled normalized speed as input"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

  Movers.FlowControlled_m_flow pumFlo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=addPowerToMedium,
    final use_riseTime=use_riseTime,
    final riseTime=riseTime,
    final init=init,
    final per=per) if typ <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None
     and typMod == Buildings.Fluid.HydronicConfigurations.Types.PumpModel.MassFlowRate
    "Pump with ideally controlled mass flow rate as input"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Sensors.VolumeFlowRate V_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Volume flow rate"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter scaHea(
    final k=dp_nominal)
    if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Scale control input to design head" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,30})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter scaSpe(
    final k=per.speed_nominal)
    if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Scale control input to design speed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,30})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter scaFlo(
    final k=m_flow_nominal)
    if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Scale control input to design flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,30})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0.0)
               "Zero"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    if typ<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Switch on/off"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,60})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant One(final k=1.0)
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput
    "one"
    annotation (Placement(transformation(extent={{60,70},{40,90}})));
  FixedResistances.LosslessPipe noPum(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Pump.None
    "Direct fluid pass-through in case of no pump" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,-80})));
protected
  final parameter Modelica.Units.SI.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";

  final parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
    T=T_start,
    p=p_start,
    X=X_start) "Medium state at start values";

  final parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_start=
      Medium.specificEnthalpy(sta_start) "Start value for outflowing enthalpy";

equation
  connect(pumDp.port_b, port_b) annotation (Line(points={{-10,0},{100,0}},
                    color={0,127,255}));
  connect(pumSpe.port_b, port_b)
    annotation (Line(points={{30,-20},{80,-20},{80,0},{100,0}},
                                               color={0,127,255}));
  connect(pumDp.heatPort, heatPort) annotation (Line(points={{-20,-6.8},{-20,
          -96},{0,-96},{0,-100}},
                             color={191,0,0}));
  connect(pumSpe.heatPort, heatPort) annotation (Line(points={{20,-26.8},{20,
          -96},{0,-96},{0,-100}},
                             color={191,0,0}));
  connect(pumFlo.heatPort, heatPort) annotation (Line(points={{60,-46.8},{60,
          -114},{-14,-114},{-14,-100},{0,-100}},
                             color={191,0,0}));
  connect(pumFlo.port_b, port_b) annotation (Line(points={{70,-40},{80,-40},{80,
          0},{100,0}}, color={0,127,255}));
  connect(pumDp.P, P) annotation (Line(points={{-9,9},{86,9},{86,90},{120,90}},
        color={0,0,127}));
  connect(pumDp.y_actual, y_actual) annotation (Line(points={{-9,7},{88,7},{88,
          70},{120,70}},    color={0,0,127}));
  connect(pumSpe.P, P) annotation (Line(points={{31,-11},{86,-11},{86,90},{120,
          90}},
        color={0,0,127}));
  connect(pumSpe.y_actual, y_actual) annotation (Line(points={{31,-13},{88,-13},
          {88,70},{120,70}},
                         color={0,0,127}));
  connect(pumFlo.P, P) annotation (Line(points={{71,-31},{86,-31},{86,90},{120,
          90}}, color={0,0,127}));
  connect(pumFlo.y_actual, y_actual) annotation (Line(points={{71,-33},{88,-33},
          {88,70},{120,70}}, color={0,0,127}));
  connect(port_a, V_flow.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(V_flow.port_b, pumSpe.port_a)
    annotation (Line(points={{-70,0},{-60,0},{-60,-20},{10,-20}},
                                               color={0,127,255}));
  connect(V_flow.port_b, pumDp.port_a)
    annotation (Line(points={{-70,0},{-30,0}},  color={0,127,255}));
  connect(V_flow.port_b, pumFlo.port_a)
    annotation (Line(points={{-70,0},{-60,0},{-60,-40},{50,-40}},
                                                          color={0,127,255}));
  connect(scaHea.y, pumDp.dp_in)
    annotation (Line(points={{-20,18},{-20,12}}, color={0,0,127}));
  connect(scaSpe.y, pumSpe.y)
    annotation (Line(points={{20,18},{20,-8}},   color={0,0,127}));
  connect(scaFlo.y, pumFlo.m_flow_in)
    annotation (Line(points={{60,18},{60,-28}}, color={0,0,127}));
  connect(zer.y, swi.u3) annotation (Line(points={{-38,80},{-8,80},{-8,72}},
                color={0,0,127}));
  connect(y, swi.u1)
    annotation (Line(points={{0,120},{0,92},{8,92},{8,72}}, color={0,0,127}));
  connect(y1, swi.u2) annotation (Line(points={{-120,60},{-20,60},{-20,74},{0,
          74},{0,72}},
                   color={255,0,255}));
  connect(swi.y, scaHea.u) annotation (Line(points={{-2.22045e-15,48},{
          -2.22045e-15,46},{-20,46},{-20,42}},
                color={0,0,127}));
  connect(swi.y, scaSpe.u) annotation (Line(points={{-2.22045e-15,48},{
          -2.22045e-15,46},{20,46},{20,42}},
                color={0,0,127}));
  connect(swi.y, scaFlo.u)
    annotation (Line(points={{0,48},{0,46},{60,46},{60,42}}, color={0,0,127}));
  connect(One.y, swi.u1)
    annotation (Line(points={{38,80},{8,80},{8,72}}, color={0,0,127}));
  connect(V_flow.port_b, noPum.port_a)
    annotation (Line(points={{-70,0},{-60,0},{-60,-80},{-10,-80}},
                                                           color={0,127,255}));
  connect(noPum.port_b, port_b) annotation (Line(points={{10,-80},{80,-80},{80,0},
          {100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="pum",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,16},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Line(
          points={{0,70},{100,70}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,90},{100,90}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-50},{54,0},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Text(extent={{42,86},{92,72}},
          textColor={0,0,127},
          textString="y_actual"),
        Line(
          points={{0,100},{0,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          visible=use_riseTime,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_riseTime,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_riseTime,
          extent={{-20,92},{22,46}},
          textColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Text(extent={{64,106},{114,92}},
          textColor={0,0,127},
          textString="P"),
        Ellipse(
          extent={{4,16},{36,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199})}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a container class for pump models from
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>.
</p>
<p>
Two parameters allow configuring the model.
</p>
<ul>
<li>
The parameter <code>typ</code> enables selecting the type of pump
based on the enumeration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.Pump\">
Buildings.Fluid.HydronicConfigurations.Types.Pump</a>.
If \"No pump\" is selected the model resolves into a simple
fluid direct pass-through.
</li>
<li>
The parameter <code>typMod</code> enables selecting the type of pump
model based on the enumeration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.PumpModel\">
Buildings.Fluid.HydronicConfigurations.Types.PumpModel</a>.
</li>
</ul>
<p>The model takes the following input variables that are conditional
to the parameter <code>typ</code>.</p>
<table summary=\"Input variables\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ************ -->
<tr>
<th>Variable</th>
<th>Type (unit)</th>
<th>Condition</th>
<th>Description</th>
</tr>
<!-- ************ -->
<tr>
<td><code>y1</code></td>
<td>Boolean</td>
<td>Only available if <code>typ&lt;&gt;None</code></td>
<td>Start signal</td>
</tr>
<!-- ************ -->
<tr>
<td><code>y</code></td>
<td>Real (-)</td>
<td>Only available if <code>typ==VariableInput</code></td>
<td>Analog control signal. Whatever the type of pump model (specified with <code>typMod</code>) the container class takes a non-dimensional input between <i>0</i> and <i>1</i>.</td>
</tr>
<!-- ************ -->
</table>
</html>", revisions="<html>
<ul>
<li>
April 4, 2023, by Hongxiang Fu:<br/>
Deleted the mover with <code>Nrpm</code> signal.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pump;

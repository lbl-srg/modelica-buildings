within Buildings.Fluid.Storage.Plant.BaseClasses;
model InterlockedValves
  "Two valves in parallel with opposite nominal flow directions that are interlocked with each other"
  extends PartialBranchPorts;

  parameter Modelica.Units.SI.PressureDifference dpValToNet_nominal(
    final displayUnit="Pa")=
    0.1*nom.dp_nominal "Nominal pressure drop of valToNet when fully open";
  parameter Modelica.Units.SI.PressureDifference dpValFroNet_nominal(
    final displayUnit="Pa")=
    0.1*nom.dp_nominal "Nominal pressure drop of valFroNet when fully open";
  parameter Real tValToNetClo=0.01 "Threshold that ValToNet is considered closed";
  parameter Real tValFroNetClo=0.01 "Threshold that ValFroNet is considered closed";

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valToNet(
    redeclare final package Medium = Medium,
    final dpValve_nominal=dpValToNet_nominal,
    use_inputFilter=true,
    y_start=0,
    m_flow_nominal=nom.m_flow_nominal)
    "Valve whose nominal flow direction is to the district network"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valFroNet(
    redeclare final package Medium = Medium,
    final dpValve_nominal=dpValFroNet_nominal,
    use_inputFilter=true,
    y_start=0,
    m_flow_nominal=nom.mTan_flow_nominal)
    "Valve whose nominal flow direction is from the district network"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Blocks.Interfaces.RealInput yVal[2] "Real inputs for valve position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));
  Buildings.Fluid.Storage.Plant.Controls.Interlock conInt(
    final t1=tValToNetClo,
    final t2=tValFroNetClo)
    "Valve interlock"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_aFroChi, valToNet.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(valToNet.port_b, port_bToNet)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_aFroNet, valFroNet.port_a)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(valFroNet.port_b, port_bToChi)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(conInt.u1_in, yVal[1]) annotation (Line(points={{-12,8},{-60,8},{-60,
          90},{0,90},{0,107.5}}, color={0,0,127}));
  connect(conInt.u2_in, yVal[2]) annotation (Line(points={{-12,-4},{-60,-4},{
          -60,90},{0,90},{0,112.5}}, color={0,0,127}));
  connect(conInt.y1, valToNet.y)
    annotation (Line(points={{11,4},{20,4},{20,72},{0,72}}, color={0,0,127}));
  connect(valFroNet.y, conInt.y2) annotation (Line(points={{0,-48},{20,-48},{20,
          -4},{11,-4}}, color={0,0,127}));
  connect(conInt.u1_actual, valToNet.y_actual) annotation (Line(points={{-12,4},
          {-20,4},{-20,40},{14,40},{14,68},{5,68},{5,67}}, color={0,0,127}));
  connect(conInt.u2_actual, valFroNet.y_actual) annotation (Line(points={{-12,
          -8},{-20,-8},{-20,-52},{-5,-52},{-5,-53}}, color={0,0,127}));
  annotation (Icon(graphics={
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-100,-60},{100,-60}},
                                          color={28,108,200}),
        Polygon(
          points={{0,60},{-30,80},{-30,40},{0,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{0,50},{0,-52}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Polygon(
          points={{-10,0},{8,10},{8,-10},{-10,0}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,60},{30,80},{30,40},{0,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{0,-60},{-30,-40},{-30,-80},{0,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{0,-60},{30,-40},{30,-80},{0,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open)}),
defaultComponentName = "intVal",
    Documentation(info="<html>
<p>
This model has two valves in parallel with opposite nominal flow direction
that are interlocked with each other. For each valve, its control input is
overriden with zero if the other valve is at least open with a threshold value
to prevent a short circuit.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end InterlockedValves;

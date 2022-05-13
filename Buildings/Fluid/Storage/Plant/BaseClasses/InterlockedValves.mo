within Buildings.Fluid.Storage.Plant.BaseClasses;
model InterlockedValves
  "Two valves in parallel with opposite nominal flow directions that are interlocked with each other"
  extends PartialBranchPorts;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valToNet(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Valve whose nominal flow direction is to the district network"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valFroNet(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal)
    "Valve whose nominal flow direction is from the district network"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValToNetClo(t=0.01)
    "= true if valve closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,30})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValFroNet
    "True: let signal pass through; false: outputs zero" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-30})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValFroNetClo(t=0.01)
    "= true if valve closed" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-30})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValToNet
    "True: let signal pass through; false: outputs zero" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,30})));
  Modelica.Blocks.Interfaces.RealInput yVal[2] "Real inputs for valve position"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));
equation
  connect(port_aFroChi, valToNet.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(valToNet.port_b, port_bToNet)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_aFroNet, valFroNet.port_a)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(valFroNet.port_b, port_bToChi)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(valToNet.y_actual, isValToNetClo.u) annotation (Line(points={{5,67},{
          4,67},{4,72},{50,72},{50,42}}, color={0,0,127}));
  connect(isValToNetClo.y, swiValFroNet.u2)
    annotation (Line(points={{50,18},{50,-18}}, color={255,0,255}));
  connect(swiValFroNet.y, valFroNet.y)
    annotation (Line(points={{50,-42},{50,-48},{0,-48}}, color={0,0,127}));
  connect(zero.y, swiValFroNet.u3) annotation (Line(points={{-1.9984e-15,19},{-1.9984e-15,
          0},{42,0},{42,-18}}, color={0,0,127}));
  connect(valFroNet.y_actual, isValFroNetClo.u) annotation (Line(points={{-5,
          -53},{-6,-53},{-6,-48},{-50,-48},{-50,-42}}, color={0,0,127}));
  connect(swiValToNet.y, valToNet.y)
    annotation (Line(points={{-50,42},{-50,72},{0,72}}, color={0,0,127}));
  connect(zero.y, swiValToNet.u3) annotation (Line(points={{-1.9984e-15,19},{-1.9984e-15,
          0},{-42,0},{-42,18}}, color={0,0,127}));
  connect(isValFroNetClo.y, swiValToNet.u2)
    annotation (Line(points={{-50,-18},{-50,18}}, color={255,0,255}));
  connect(swiValToNet.u1, yVal[1]) annotation (Line(points={{-58,18},{-58,0},{
          -70,0},{-70,96},{0,96},{0,107.5}}, color={0,0,127}));
  connect(swiValFroNet.u1, yVal[2]) annotation (Line(points={{58,-18},{58,0},{
          70,0},{70,96},{0,96},{0,112.5}}, color={0,0,127}));
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
Documentation pending.
</p>
</html>"));
end InterlockedValves;

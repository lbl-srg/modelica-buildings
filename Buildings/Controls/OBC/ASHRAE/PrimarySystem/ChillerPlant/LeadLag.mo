within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block LeadLag "Defines lead-lag equipment rotation"

  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";

  parameter Real overlap(unit = "s") = 15
    "Staging runtime hysteresis detla";

  parameter Real stagingRuntime(unit = "h") = 240
    "Staging runtime";

  CDL.Interfaces.BooleanInput uDevSta[num] "Current devices operation status"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Logical.Timer tim[num]
    "Measures time spent loaded at the current role (lead or lag)"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  CDL.Continuous.Hysteresis hys[num](
    uLow=stagingRuntime,
    uHigh=stagingRuntime + overlap)
    "Stagin runtime hysteresis"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  CDL.Logical.Change cha[num]
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Logical.And and2[num]
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Interfaces.BooleanInput uDevRol[num]
    "Current devices operation role (lead = 1, lag = 0)" annotation (Placement(
        transformation(extent={{-220,-100},{-180,-60}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  CDL.Logical.MultiOr mulOr(nu=2)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Logical.Not not1[num]
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Logical.LogicalSwitch logSwi[num]
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
equation
  connect(uDevSta, tim.u) annotation (Line(points={{-200,0},{-160,0},{-160,30},{
          -122,30}}, color={255,0,255}));
  connect(tim.y, hys.u)
    annotation (Line(points={{-99,30},{-82,30}}, color={0,0,127}));
  connect(hys.y, tim.u0) annotation (Line(points={{-59,30},{-50,30},{-50,10},{-130,
          10},{-130,22},{-122,22}}, color={255,0,255}));
  connect(uDevSta, cha.u) annotation (Line(points={{-200,0},{-160,0},{-160,-30},
          {-122,-30}}, color={255,0,255}));
  connect(hys.y, and2.u1) annotation (Line(points={{-59,30},{-30,30},{-30,0},{-22,
          0}}, color={255,0,255}));
  connect(cha.y, and2.u2) annotation (Line(points={{-99,-30},{-30,-30},{-30,-8},
          {-22,-8}}, color={255,0,255}));
  connect(mulOr.y, logSwi.u2) annotation (Line(points={{61.7,0},{80,0},{80,-50},
          {98,-50}}, color={255,0,255}));
  connect(uDevRol, not1.u) annotation (Line(points={{-200,-80},{-92,-80},{-92,-50},
          {18,-50}}, color={255,0,255}));
  connect(logSwi.u1, not1.y) annotation (Line(points={{98,-42},{70,-42},{70,-50},
          {41,-50}}, color={255,0,255}));
  connect(uDevRol, logSwi.u3) annotation (Line(points={{-200,-80},{80,-80},{80,-58},
          {98,-58}}, color={255,0,255}));
  connect(mulOr.u[1:2], and2.y)
    annotation (Line(points={{38,-3.5},{38,0},{1,0}}, color={255,0,255}));
  annotation (Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end LeadLag;

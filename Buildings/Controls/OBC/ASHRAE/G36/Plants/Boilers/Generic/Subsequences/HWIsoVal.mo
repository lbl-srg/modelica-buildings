within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences;
block HWIsoVal
    "Sequence of enable or disable hot water isolation valve"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of device reset before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatIsoVal
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDisHotWatIsoVal
    "Status of hot water isolation valve control: true=disabled valve is fully closed"
    annotation (Placement(transformation(extent={{180,26},{220,66}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "Pre block to break algebraic loop"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-40,86},{-20,106}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{0,86},{20,106}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,116},{20,136}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical or"
    annotation (Placement(transformation(extent={{40,116},{60,136}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd and5(
    final nin=2)
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{100,36},{120,56}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

equation

  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,-80},{-132,-80},{-132,-118},{-82,-118}},
                                                      color={255,0,255}));

  connect(not4.y, and4.u2)
    annotation (Line(points={{-18,66},{-10,66},{-10,88},{-2,88}},
      color={255,0,255}));

  connect(not3.y, and4.u1)
    annotation (Line(points={{-18,96},{-2,96}},   color={255,0,255}));

  connect(and3.y, or2.u1)
    annotation (Line(points={{22,126},{38,126}}, color={255,0,255}));

  connect(and4.y, or2.u2)
    annotation (Line(points={{22,96},{30,96},{30,118},{38,118}},
      color={255,0,255}));

  connect(and5.y,yDisHotWatIsoVal)
    annotation (Line(points={{122,46},{200,46}},   color={255,0,255}));

  connect(uUpsDevSta, and2.u1) annotation (Line(points={{-180,-40},{-100,-40},{-100,
          -110},{-82,-110}},      color={255,0,255}));

  connect(or2.y, and5.u[1]) annotation (Line(points={{62,126},{98,126},{98,44.25}},
                          color={255,0,255}));
  connect(uUpsDevSta, and5.u[2]) annotation (Line(points={{-180,-40},{-128,-40},
          {-128,47.75},{98,47.75}},      color={255,0,255}));
  connect(yHotWatIsoVal, pre.u) annotation (Line(points={{200,-40},{170,-40},{170,
          0},{122,0}},     color={255,0,255}));
  connect(pre.y, and3.u1) annotation (Line(points={{98,0},{-50,0},{-50,126},{-2,
          126}},    color={255,0,255}));
  connect(pre.y, not3.u) annotation (Line(points={{98,0},{-50,0},{-50,96},{-42,96}},
                     color={255,0,255}));
  connect(uHotWatIsoVal, and3.u2) annotation (Line(points={{-180,0},{-90,0},{-90,
          118},{-2,118}},            color={255,0,255}));
  connect(uHotWatIsoVal, not4.u) annotation (Line(points={{-180,0},{-90,0},{-90,
          66},{-42,66}},        color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-58,-110},{-42,-110}}, color={255,0,255}));
  connect(uHotWatIsoVal, and1.u1)
    annotation (Line(points={{-180,0},{-82,0},{-82,-40},{18,-40}},
                                                     color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{-18,-110},{10,-110},{10,-48},
          {18,-48}},        color={255,0,255}));
  connect(and1.y, yHotWatIsoVal) annotation (Line(points={{42,-40},{200,-40}},
                                color={255,0,255}));
annotation (
  defaultComponentName="enaHotWatIsoVal",
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-160},{180,160}}),
    graphics={
      Rectangle(
        extent={{-158,158},{178,42}},
        fillColor={210,210,210},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Text(
        extent={{-156,158},{54,124}},
        pattern=LinePattern.None,
        fillColor={210,210,210},
        fillPattern=FillPattern.Solid,
        textColor={0,0,127},
        horizontalAlignment=TextAlignment.Left,
          textString="Check if all enabled HW isolation valves
have been fully open")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name"),
      Text(
        extent={{-96,-54},{-60,-66}},
        textColor={255,0,255},
        pattern=LinePattern.Dash,
        textString="chaPro"),
      Text(
        extent={{-96,8},{-66,-6}},
        textColor={255,0,255},
        pattern=LinePattern.Dash,
        textString="uUpsDevSta"),
      Text(
        extent={{-96,68},{-42,56}},
        textColor={0,0,127},
        pattern=LinePattern.Dash,
        textString="uHotWatIsoVal"),
      Text(
        extent={{32,70},{96,54}},
        textColor={255,0,255},
        pattern=LinePattern.Dash,
        textString="yEnaHotWatIsoVal"),
      Polygon(
        points={{-60,40},{-60,-40},{0,0},{-60,40}},
        lineColor={200,200,200},
        fillColor={207,207,207},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{60,40},{60,-40},{0,0},{60,40}},
        lineColor={200,200,200},
        fillColor={207,207,207},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{44,-54},{98,-66}},
        textColor={0,0,127},
        pattern=LinePattern.Dash,
        textString="yHotWatIsoVal")}),
  Documentation(info="<html>
  <p>
  Block updates boiler hot water isolation valve command <code>yHotWatIsoVal</code>
  when there is a plant disable command (<code>chaPro=true</code>). It will also
  generate status <code>yDisHotWatIsoVal</code> to indicate if the valve status
  change process has finished.
  <br>
  When there is a plant disable command (<code>chaPro=true</code>) and the boilers
  being disabled have been shut off (<code>uUpsDevSta=true</code>),
  the boiler's isolation valve will be fully closed.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  June 18, 2020, by Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end HWIsoVal;

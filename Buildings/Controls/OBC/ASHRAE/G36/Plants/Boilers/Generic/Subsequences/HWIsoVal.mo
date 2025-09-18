within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Subsequences;
block HWIsoVal
    "Sequence of enable or disable hot water isolation valve"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of device reset before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-200},{-160,-160}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  CDL.Interfaces.BooleanInput                     uHotWatIsoVal
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDisHotWatIsoVal
    "Status of hot water isolation valve control: true=disabled valve is fully closed"
   annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

  CDL.Interfaces.BooleanOutput                     yHotWatIsoVal
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{160,-10},{140,10}})));
protected
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{0,180},{20,200}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical or"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd and5(
    final nin=2)
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));

  CDL.Logical.Not                        not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
protected
  CDL.Logical.And                        and1
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
equation

  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,-180},{-132,-180},{-132,-178},{-82,-178}},
                                                      color={255,0,255}));

  connect(not4.y, and4.u2)
    annotation (Line(points={{-18,160},{-12,160},{-12,182},{-2,182}},
      color={255,0,255}));

  connect(not3.y, and4.u1)
    annotation (Line(points={{-18,190},{-2,190}}, color={255,0,255}));

  connect(and3.y, or2.u1)
    annotation (Line(points={{22,220},{38,220}}, color={255,0,255}));

  connect(and4.y, or2.u2)
    annotation (Line(points={{22,190},{30,190},{30,212},{38,212}},
      color={255,0,255}));

  connect(and5.y,yDisHotWatIsoVal)
    annotation (Line(points={{162,140},{200,140}}, color={255,0,255}));

  connect(uUpsDevSta, and2.u1) annotation (Line(points={{-180,-140},{-100,-140},
          {-100,-170},{-82,-170}},color={255,0,255}));

  connect(or2.y, and5.u[1]) annotation (Line(points={{62,220},{122,220},{122,138.25},
          {138,138.25}},  color={255,0,255}));
  connect(uUpsDevSta, and5.u[2]) annotation (Line(points={{-180,-140},{-128,-140},
          {-128,141.75},{138,141.75}},   color={255,0,255}));
  connect(yHotWatIsoVal, pre.u) annotation (Line(points={{200,-40},{170,-40},{
          170,0},{162,0}}, color={255,0,255}));
  connect(pre.y, and3.u1) annotation (Line(points={{138,0},{-50,0},{-50,220},{
          -2,220}}, color={255,0,255}));
  connect(pre.y, not3.u) annotation (Line(points={{138,0},{-50,0},{-50,190},{
          -42,190}}, color={255,0,255}));
  connect(uHotWatIsoVal, and3.u2) annotation (Line(points={{-180,-100},{-90,
          -100},{-90,212},{-2,212}}, color={255,0,255}));
  connect(uHotWatIsoVal, not4.u) annotation (Line(points={{-180,-100},{-90,-100},
          {-90,160},{-42,160}}, color={255,0,255}));
  connect(and2.y, not1.u)
    annotation (Line(points={{-58,-170},{-42,-170}}, color={255,0,255}));
  connect(uHotWatIsoVal, and1.u1)
    annotation (Line(points={{-180,-100},{18,-100}}, color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{-18,-170},{10,-170},{10,
          -108},{18,-108}}, color={255,0,255}));
  connect(and1.y, yHotWatIsoVal) annotation (Line(points={{42,-100},{170,-100},
          {170,-40},{200,-40}}, color={255,0,255}));
annotation (
  defaultComponentName="enaHotWatIsoVal",
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-240},{180,240}}),
    graphics={
      Rectangle(
        extent={{-158,238},{178,122}},
        fillColor={210,210,210},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
      Text(
        extent={{-38,184},{172,150}},
        pattern=LinePattern.None,
        fillColor={210,210,210},
        fillPattern=FillPattern.Solid,
        textColor={0,0,127},
        horizontalAlignment=TextAlignment.Right,
        textString="Check if all enabled HW isolation valves 
          have been fully open")}),
    Icon(graphics={
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
  Block updates boiler hot water isolation valve position when 
  there is stage change command (<code>chaPro=true</code>). It will also generate 
  status <code>yDisHotWatIsoVal=true</code> to indicate if the valve reset process has finished.
  This block is not based on any specific section in RP-1711, but has been designed
  to carry out the hot water isolation valve operations in the plant disable sequences
  defined in 5.3.2.5.
  </p>
  <ul>
  <li>
  When there is a plant disable command (<code>chaPro=true</code>) and the boiler 
  being diabled has been shut off (<code>uUpsDevSta=true</code>), 
  the boiler's isolation valve will be fully closed at a rate of change of position 
  <code>chaHotWatIsoRat</code>.
  </li>
  </ul>
  <p>
  This sequence will generate real signal <code>yHoyWatIsoVal</code> which indicates 
  hot water isolation valve position.
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

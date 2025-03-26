within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences;
block HWIsoVal
    "Sequence of enable or disable hot water isolation valve"

  parameter Real chaHotWatIsoRat(
    final unit="1/s",
    displayUnit="1/s") = 1/60
    "Rate at which to slowly close isolation valve, should be determined in the field";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of device reset before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-200},{-160,-160}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDisHotWatIsoVal
    "Status of hot water isolation valve control: true=disabled valve is fully closed"
   annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1)
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1/chaHotWatIsoRat)
    "Find remaining time for valve position change"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample valve position at start of shutdown process"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1e-6)
    "Determine time required to change valve position"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if time required for changing valve position has elapsed"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Hot water isolation valve setpoint"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.025,
    final uHigh=0.05)
    "Check if isolation valve is disabled"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4(
    final uLow=0.925,
    final uHigh=0.975)
    "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

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
    final nin=3)
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));

equation
  connect(con9.y, lin1.x1)
    annotation (Line(points={{22,100},{30,100},{30,88},{38,88}},
      color={0,0,127}));

  connect(tim.y, lin1.u)
    annotation (Line(points={{-78,100},{-20,100},{-20,80},{38,80}},
                                                color={0,0,127}));

  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,-180},{-132,-180},{-132,-178},{-82,-178}},
                                                      color={255,0,255}));

  connect(swi.y,yHotWatIsoVal)
    annotation (Line(points={{162,-40},{200,-40}}, color={0,0,127}));

  connect(uHotWatIsoVal, hys4.u)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,160},{-122,160}},
      color={0,0,127}));

  connect(uHotWatIsoVal, hys3.u)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,220},{-122,220}},
      color={0,0,127}));

  connect(hys3.y, and3.u1)
    annotation (Line(points={{-98,220},{-2,220}}, color={255,0,255}));

  connect(hys4.y, and3.u2)
    annotation (Line(points={{-98,160},{-80,160},{-80,212},{-2,212}},
      color={255,0,255}));

  connect(hys4.y, not4.u)
    annotation (Line(points={{-98,160},{-42,160}}, color={255,0,255}));

  connect(hys3.y, not3.u)
    annotation (Line(points={{-98,220},{-60,220},{-60,190},{-42,190}},
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

  connect(tim.u, and2.y) annotation (Line(points={{-102,100},{-120,100},{-120,
          -200},{-50,-200},{-50,-170},{-58,-170}}, color={255,0,255}));

  connect(addPar.y, lin1.x2) annotation (Line(points={{42,20},{80,20},{80,100},{
          34,100},{34,76},{38,76}},
                    color={0,0,127}));

  connect(tim.y, gre.u1) annotation (Line(points={{-78,100},{-20,100},{-20,120},
          {58,120}},
                 color={0,0,127}));

  connect(addPar.y, gre.u2) annotation (Line(points={{42,20},{80,20},{80,100},{34,
          100},{34,112},{58,112}},    color={0,0,127}));

  connect(con9.y, lin1.f2) annotation (Line(points={{22,100},{30,100},{30,72},{38,
          72}}, color={0,0,127}));
  connect(triSam.y, lin1.f1) annotation (Line(points={{-48,50},{-40,50},{-40,84},
          {38,84}}, color={0,0,127}));
  connect(uHotWatIsoVal, triSam.u) annotation (Line(points={{-180,-100},{-100,-100},
          {-100,50},{-72,50}}, color={0,0,127}));
  connect(lin1.y, swi.u1) annotation (Line(points={{62,80},{100,80},{100,-32},{138,
          -32}}, color={0,0,127}));
  connect(uHotWatIsoVal, swi.u3) annotation (Line(points={{-180,-100},{110,-100},
          {110,-48},{138,-48}}, color={0,0,127}));

  connect(and2.y, swi.u2) annotation (Line(points={{-58,-170},{-50,-170},{-50,-40},
          {138,-40}}, color={255,0,255}));
  connect(and2.y, triSam.trigger) annotation (Line(points={{-58,-170},{-50,-170},
          {-50,20},{-60,20},{-60,38}},   color={255,0,255}));
  connect(addPar.u, gai.y)
    annotation (Line(points={{18,20},{2,20}}, color={0,0,127}));
  connect(gai.u, triSam.y) annotation (Line(points={{-22,20},{-40,20},{-40,50},{
          -48,50}}, color={0,0,127}));
  connect(or2.y, and5.u[1]) annotation (Line(points={{62,220},{122,220},{122,
          144.667},{138,144.667}},
                          color={255,0,255}));
  connect(gre.y, and5.u[2]) annotation (Line(points={{82,120},{124,120},{124,140},
          {138,140}}, color={255,0,255}));
  connect(uUpsDevSta, and5.u[3]) annotation (Line(points={{-180,-140},{-128,
          -140},{-128,135.333},{138,135.333}},
                                         color={255,0,255}));
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

within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences;
block HWIsoVal
    "Sequence of enable or disable hot water isolation valve"

  parameter Integer nBoi = 3
    "Total number of boiler, which is also the total number of hot water isolation valve";

  parameter Real chaHotWatIsoTim(
    final unit="s",
    final quantity="Time",
    displayUnit="s") = 60
    "Time to slowly change isolation valve position, should be determined in the field";

  parameter Real iniValPos
    "Initial valve position, if it needs to turn on boiler, the value should be 0";

  parameter Real endValPos
    "Ending valve position, if it needs to turn on boiler, the value should be 1";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of device reset before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-198},{-160,-158}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaBoi
    "Index of next boiler that should change status"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal[nBoi](
    final unit=fill("1", nBoi),
    final min=fill(0, nBoi),
    final max=fill(1, nBoi))
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaHotWatIsoVal
    "Status of hot water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi](
    final unit=fill("1", nBoi),
    final min=fill(0, nBoi),
    final max=fill(1, nBoi))
    "Hot water isolation valve position"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  final parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index, {1,2,...,nBoi}";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=chaHotWatIsoTim)
    "Time to change hot water isolation valve"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=endValPos)
    "Ending valve position"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    final k=iniValPos)
    "Initial isolation valve position"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Hot water isolation valve setpoint"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=chaHotWatIsoTim)
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nBoi]
    "Record the old hot water isolation valve status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2[nBoi]
    "Logical not"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nBoi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nBoi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nBoi)
    "Replicate real input"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3[nBoi](
    final uLow=fill(0.025,nBoi),
    final uHigh=fill(0.05, nBoi))
    "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4[nBoi](
    final uLow=fill(0.925,nBoi),
    final uHigh=fill(0.975, nBoi))
    "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3[nBoi]
    "Logical not"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4[nBoi]
    "Logical not"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));

  Buildings.Controls.OBC.CDL.Logical.And and4[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{0,180},{20,200}})));

  Buildings.Controls.OBC.CDL.Logical.And and3[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));

  Buildings.Controls.OBC.CDL.Logical.Or  or2[nBoi]
    "Logical or"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(
    final nin=nBoi)
    "Logical and"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd and5(
    final nin=3)
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nBoi](
    final k=boiInd)
    "Boiler index array"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge detector"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));

equation
  connect(uHotWatIsoVal, triSam.u)
    annotation (Line(points={{-180,-100},{-82,-100}}, color={0,0,127}));

  connect(con9.y, lin1.x1)
    annotation (Line(points={{22,100},{30,100},{30,88},{38,88}},
      color={0,0,127}));

  connect(con6.y, lin1.f1)
    annotation (Line(points={{-18,100},{-10,100},{-10,84},{38,84}},
      color={0,0,127}));

  connect(con7.y, lin1.x2)
    annotation (Line(points={{-18,50},{-10,50},{-10,76},{38,76}},
      color={0,0,127}));

  connect(con8.y, lin1.f2)
    annotation (Line(points={{22,50},{30,50},{30,72},{38,72}}, color={0,0,127}));

  connect(tim.y, lin1.u)
    annotation (Line(points={{-78,80},{38,80}}, color={0,0,127}));

  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,-178},{-82,-178}}, color={255,0,255}));

  connect(booRep1.y, swi.u2)
    annotation (Line(points={{82,-170},{100,-170},{100,-40},{118,-40}},
      color={255,0,255}));

  connect(swi.y,yHotWatIsoVal)
    annotation (Line(points={{142,-40},{200,-40}}, color={0,0,127}));

  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{42,-140},{60,-140},{60,-120},{-70,-120},{-70,-112}},
                      color={255,0,255}));

  connect(booRep1.y, not2.u)
    annotation (Line(points={{82,-170},{100,-170},{100,-110},{-40,-110},
      {-40,-80},{-22,-80}},  color={255,0,255}));

  connect(not2.y, swi1.u2)
    annotation (Line(points={{2,-80},{20,-80},{20,-60},{58,-60}},
      color={255,0,255}));

  connect(triSam.y, swi1.u3)
    annotation (Line(points={{-58,-100},{40,-100},{40,-68},{58,-68}},
      color={0,0,127}));

  connect(swi1.y, swi.u3)
    annotation (Line(points={{82,-60},{90,-60},{90,-48},{118,-48}},
      color={0,0,127}));

  connect(uHotWatIsoVal, swi1.u1)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,-52},{58,-52}},
      color={0,0,127}));

  connect(swi2.y, swi.u1)
    annotation (Line(points={{82,10},{100,10},{100,-32},{118,-32}},
      color={0,0,127}));

  connect(nexChaBoi, intRep.u)
    annotation (Line(points={{-180,10},{-82,10}}, color={255,127,0}));

  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-58,10},{-22,10}}, color={255,127,0}));

  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{2,10},{58,10}}, color={255,0,255}));

  connect(lin1.y, reaRep.u)
    annotation (Line(points={{62,80},{78,80}}, color={0,0,127}));

  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{102,80},{120,80},{120,50},{40,50},{40,18},{58,18}},
      color={0,0,127}));

  connect(triSam.y, swi2.u3)
    annotation (Line(points={{-58,-100},{40,-100},{40,2},{58,2}},
      color={0,0,127}));

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

  connect(and5.y,yEnaHotWatIsoVal)
    annotation (Line(points={{162,140},{200,140}}, color={255,0,255}));

  connect(or2.y, mulAnd1.u)
    annotation (Line(points={{62,220},{78,220}}, color={255,0,255}));

  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-58,-20},{-40,-20},{-40,2},{-22,2}},
      color={255,127,0}));


  connect(uUpsDevSta, and2.u1) annotation (Line(points={{-180,-140},{-100,-140},
          {-100,-170},{-82,-170}},color={255,0,255}));

  connect(and2.y, booRep1.u)
    annotation (Line(points={{-58,-170},{58,-170}}, color={255,0,255}));

  connect(edg.y, booRep.u)
    annotation (Line(points={{2,-140},{18,-140}}, color={255,0,255}));

  connect(and2.y, edg.u) annotation (Line(points={{-58,-170},{-40,-170},{-40,
          -140},{-22,-140}}, color={255,0,255}));

  connect(tim.u, and2.y) annotation (Line(points={{-102,80},{-120,80},{-120,
          -200},{-40,-200},{-40,-170},{-58,-170}}, color={255,0,255}));

  connect(mulAnd1.y, and5.u[1]) annotation (Line(points={{102,220},{120,220},{
          120,144.667},{138,144.667}},
                                   color={255,0,255}));
  connect(tim.passed, and5.u[2]) annotation (Line(points={{-78,72},{-68,72},{-68,
          140},{138,140}}, color={255,0,255}));
  connect(uUpsDevSta, and5.u[3]) annotation (Line(points={{-180,-140},{-130,
          -140},{-130,135.333},{138,135.333}},
                                         color={255,0,255}));
annotation (
  defaultComponentName="hotWatIsoVal",
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
        extent={{-96,-74},{-60,-86}},
        textColor={255,0,255},
        pattern=LinePattern.Dash,
        textString="chaPro"),
      Text(
        extent={{-96,-42},{-46,-56}},
        textColor={255,0,255},
        pattern=LinePattern.Dash,
        textString="uUpsDevSta"),
      Text(
        extent={{-96,86},{-48,74}},
        textColor={255,127,0},
        pattern=LinePattern.Dash,
        textString="nexChaBoi"),
      Text(
        extent={{-96,58},{-42,46}},
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
  Block updates boiler hot water isolation valve enabling-disabling status when 
  there is stage change command (<code>chaPro=true</code>). It will also generate 
  status to indicate if the valve reset process has finished.
  This block is not based on any specific section in RP-1711, but has been designed
  to carry out the hot water isolation valve operations in the staging sequences
  defined in 5.3.3.
  </p>
  <ul>
  <li>
  When there is stage up command (<code>chaPro=true</code>) and next boiler has 
  been enabled (<code>uUpsDevSta=true</code>), the hot water isolation valve of
  next enabling boiler indicated by <code>nexChaBoi</code> will be enabled 
  (<code>iniValPos=0</code>, <code>endValPos=1</code>). 
  </li>
  <li>
  When there is stage down command (<code>chaPro=true</code>) and the disabling
  boiler (<code>nexChaBoi</code>) or its associated pump has been shut off 
  (<code>uUpsDevSta=true</code>), the boiler's isolation valve will be disabled
  (<code>iniValPos=1</code>, <code>endValPos=0</code>).
  </li>
  </ul>
  <p>
  The valve opens or closes in a time period <code>chaHotWatIsoTim</code>, which
  can be defined as per the valve specification. 
  </p>
  <p>
  This sequence will generate array <code>yHoyWatIsoVal</code> which indicates 
  hot water isolation valve position setpoint. <code>yEnaHotWatIsoVal</code> 
  will be true when all the enabled valves are fully open and all the disabled valves
  are fully closed. 
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

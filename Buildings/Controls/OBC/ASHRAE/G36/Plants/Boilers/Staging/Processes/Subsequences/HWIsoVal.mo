within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences;
block HWIsoVal
  "Sequence of enable or disable hot water isolation valve"

  parameter Boolean reqAct
    "Required controller action;
    True: Controller opens valve at required index;
    False: Controller closes valve at required index";

  parameter Integer nBoi
    "Total number of boiler, which is also the total number of hot water isolation valve";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of device reset before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-198},{-160,-158}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatIsoVal[nBoi]
    "Hot water isolation valve status;
    True: Valve detected open;
    False: Valve detected closed;"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaBoi
    "Index of next boiler that should change status"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaHotWatIsoVal
    "Isolation valve change process completion signal"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal[nBoi]
    "Hot water isolation valve open signal;
    True: Valve open command;
    False: Valve close command"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

protected
  final parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index, {1,2,...,nBoi}";

  Buildings.Controls.OBC.CDL.Logical.And and6[nBoi] if reqAct
    "Change current index signal to true when change process is triggered"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=nBoi) "Replicate signal for array logic processing"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[nBoi] if not reqAct
    "Generate true array with false value only for current index"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2[nBoi] if not reqAct
    "Not block "
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3[nBoi] if not reqAct
    "Change current index signal to false when change process is triggered"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if upstream changes have been completed and current process is triggered"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1[nBoi] if reqAct
    "Modify only current index signal on input valve status array"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nBoi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nBoi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

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

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(nin=(nBoi+1))
    "Logical and"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nBoi](
    final k=boiInd)
    "Boiler index array"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{144,130},{164,150}})));
  CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{100,124},{120,144}})));
  CDL.Logical.Edge edg2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={132,200})));
  CDL.Logical.And                        and1[nBoi] if not reqAct
    "Change current index signal to true when change process is triggered"
    annotation (Placement(transformation(extent={{72,30},{92,50}})));
equation

  connect(chaPro, and2.u2)
    annotation (Line(points={{-180,-178},{-102,-178}},color={255,0,255}));

  connect(nexChaBoi, intRep.u)
    annotation (Line(points={{-180,10},{-102,10}},color={255,127,0}));

  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-78,10},{-62,10}}, color={255,127,0}));

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

  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-78,-20},{-62,-20},{-62,2}},
      color={255,127,0}));


  connect(uUpsDevSta, and2.u1) annotation (Line(points={{-180,-140},{-120,-140},
          {-120,-170},{-102,-170}},
                                  color={255,0,255}));

  connect(yHotWatIsoVal, and3.u1) annotation (Line(points={{200,0},{168,0},{168,
          110},{-80,110},{-80,220},{-2,220}}, color={255,0,255}));
  connect(yHotWatIsoVal, not3.u) annotation (Line(points={{200,0},{168,0},{168,110},
          {-80,110},{-80,190},{-42,190}}, color={255,0,255}));
  connect(uHotWatIsoVal, and3.u2) annotation (Line(points={{-180,-100},{-140,-100},
          {-140,212},{-2,212}}, color={255,0,255}));
  connect(uHotWatIsoVal, not4.u) annotation (Line(points={{-180,-100},{-140,-100},
          {-140,160},{-42,160}}, color={255,0,255}));
  connect(and6.y, or1.u1)
    annotation (Line(points={{12,-40},{118,-40}}, color={255,0,255}));
  connect(booScaRep1.u, and2.y)
    annotation (Line(points={{-62,-170},{-78,-170}}, color={255,0,255}));
  connect(booScaRep1.y, and6.u2) annotation (Line(points={{-38,-170},{-20,-170},
          {-20,-48},{-12,-48}},
                          color={255,0,255}));
  connect(intEqu.y, not1.u) annotation (Line(points={{-38,10},{-30,10},{-30,40},
          {-12,40}},color={255,0,255}));
  connect(booScaRep1.y, not2.u) annotation (Line(points={{-38,-170},{-20,-170},{
          -20,0},{-12,0}},
                        color={255,0,255}));
  connect(not2.y, or3.u2) annotation (Line(points={{12,0},{20,0},{20,32},{28,32}},
        color={255,0,255}));
  connect(not1.y, or3.u1)
    annotation (Line(points={{12,40},{28,40}}, color={255,0,255}));
  connect(intEqu.y, and6.u1) annotation (Line(points={{-38,10},{-30,10},{-30,-40},
          {-12,-40}},color={255,0,255}));
  connect(lat.y, yEnaHotWatIsoVal)
    annotation (Line(points={{166,140},{200,140}}, color={255,0,255}));
  connect(uUpsDevSta, edg.u) annotation (Line(points={{-180,-140},{-120,-140},{-120,
          134},{98,134}}, color={255,0,255}));
  connect(edg.y, lat.clr)
    annotation (Line(points={{122,134},{142,134}}, color={255,0,255}));
  connect(mulAnd1.y, edg2.u) annotation (Line(points={{102,220},{132,220},{132,212}},
        color={255,0,255}));
  connect(edg2.y, lat.u) annotation (Line(points={{132,188},{132,140},{142,140}},
        color={255,0,255}));
  connect(uUpsDevSta, mulAnd1.u[1]) annotation (Line(points={{-180,-140},{-120,-140},
          {-120,134},{68,134},{68,212},{70,212},{70,220},{78,220}},       color
        ={255,0,255}));
  connect(or2.y, mulAnd1.u[2:nBoi+1]) annotation (Line(points={{62,220},{70,220},{70,
          220},{78,220}},       color={255,0,255}));
  connect(uHotWatIsoVal, or1.u2) annotation (Line(points={{-180,-100},{110,-100},
          {110,-48},{118,-48}}, color={255,0,255}));
  connect(or1.y, yHotWatIsoVal) annotation (Line(points={{142,-40},{170,-40},{170,
          0},{200,0}}, color={255,0,255}));
  connect(or3.y, and1.u1)
    annotation (Line(points={{52,40},{70,40}}, color={255,0,255}));
  connect(uHotWatIsoVal, and1.u2) annotation (Line(points={{-180,-100},{60,-100},
          {60,32},{70,32}}, color={255,0,255}));
  connect(and1.y, yHotWatIsoVal) annotation (Line(points={{94,40},{168,40},{168,
          0},{200,0}}, color={255,0,255}));
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
  status <code>yEnaHotWatIsoVal</code> to indicate if the valve status change process has finished.
  This block is not based on any specific section in ASHRAE Guideline 36, 2021,
  but has been designed to carry out the hot water isolation valve operations in
  the staging sequences defined in 5.21.3.
  </p>
  <ul>
  <li>
  When there is stage up command (<code>chaPro=true</code>) and next boiler has 
  been enabled (<code>uUpsDevSta=true</code>), the hot water isolation valve of
  next enabling boiler indicated by <code>nexChaBoi</code> will be enabled. 
  </li>
  <li>
  When there is stage down command (<code>chaPro=true</code>) and the disabling
  boiler (<code>nexChaBoi</code>) or its associated pump has been shut off 
  (<code>uUpsDevSta=true</code>), the boiler's isolation valve will be disabled.
  </li>
  </ul>
  <p>
  This sequence will generate array <code>yHoyWatIsoVal</code> which indicates 
  hot water isolation valve signal. <code>yEnaHotWatIsoVal</code> 
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

within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
block PlantDisable
    "Sequence to disable boiler plant components when plant has to be disabled"

  parameter Boolean have_priOnl = false
    "True: Boiler plant is primary-only; False: Boiler plant is not primary-only";

  parameter Boolean have_heaPriPum = true
    "True: Boiler plant has headered pump configuration; False: Boiler plant has dedicated pump configuration";

  parameter Integer nBoi=3
    "Total number of boilers in the plant";

  parameter Real chaHotWatIsoRat(
    final unit="1/s",
    final displayUnit="1/s") = 1/60
    "Rate at which to slowly change isolation valve, should be determined in the field";

  parameter Real delBoiDis=180
    "Time delay after boilers have been disabled before completing disabling process";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable/disable signal from plant enabler"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler enable status signal"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal from staging process controller indicating stage-up/stage-down has been completed"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumChaPro if not have_priOnl
    "Signal from pump controller indicating stage-up/stage-down has been completed"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal[nBoi] if have_heaPriPum
    "Boiler hot water isolation valve position vector"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enable status vector"
    annotation (Placement(transformation(extent={{180,30},{220,70}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaChaPro
    "Signal indicating end of stage change/plant disable process"
    annotation (Placement(transformation(extent={{180,-140},{220,-100}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi] if have_heaPriPum
    "Boiler hot water isolation valve position vector"
    annotation (Placement(transformation(extent={{180,-70},{220,-30}}),
      iconTransformation(extent={{100,-40},{140,0}})));

protected
  parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index vector";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences.HWIsoVal disHotWatIsoVal[nBoi](
    final chaHotWatIsoRat=fill(chaHotWatIsoRat, nBoi)) if have_heaPriPum
    "Disable boiler hot water isolation valve for all disabled boilers simultaneously"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nBoi]
    "Pass input boiler enable status when plant is enabled and disable all boilers when plant is disabled"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-130,-20},{-110,0}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nBoi) if have_heaPriPum
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delBoiDis,
    final delayOnInit=true)
    "Delay after all boilers have been disabled"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Pass through stage change completion signal from staging process controller when plant is enabled"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(
    final nin=nBoi) if have_priOnl and have_heaPriPum
    "Multi And"
    annotation (Placement(transformation(extent={{80,-126},{100,-106}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if not have_priOnl
    "Hold pump change status after receiving signal from primary pump controller"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 if not have_priOnl and have_heaPriPum
    "Signal stage change completion when both pump stage change and isolation valve change are complete"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre if not have_priOnl
    "Logical pre block"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge detector"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}})));


  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(
    final nin=nBoi) if not have_priOnl and have_heaPriPum
    "Multi And"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=1) if not have_priOnl and not have_heaPriPum
    "Multi Or"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[nBoi] if have_heaPriPum
    "Real switch"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And and3 if not have_priOnl
    "Indicate pump change completion only when plant is disabled"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

equation
  connect(uBoi, logSwi.u1) annotation (Line(points={{-180,50},{-120,50},{-120,
          58},{138,58}},               color={255,0,255}));

  connect(booRep1.y, logSwi.u3) annotation (Line(points={{-18,120},{-10,120},{
          -10,70},{60,70},{60,42},{138,42}},
                         color={255,0,255}));

  connect(booRep2.u, truDel.y)
    annotation (Line(points={{-22,-10},{-38,-10}}, color={255,0,255}));

  connect(and2.y, or2.u2) annotation (Line(points={{12,-120},{60,-120},{60,-128},
          {118,-128}}, color={255,0,255}));

  connect(mulAnd1.y, or2.u1) annotation (Line(points={{102,-116},{110,-116},{110,
          -120},{118,-120}}, color={255,0,255}));

  connect(uStaChaProEnd, and2.u1)
    annotation (Line(points={{-180,-120},{-12,-120}}, color={255,0,255}));

  connect(lat1.y, and1.u1) annotation (Line(points={{-38,-80},{-20,-80},{-20,-72},
          {114,-72},{114,-90},{118,-90}}, color={255,0,255}));

  connect(and1.y, or2.u1) annotation (Line(points={{142,-90},{152,-90},{152,-104},
          {116,-104},{116,-120},{118,-120}}, color={255,0,255}));

  connect(pre.y, lat1.clr) annotation (Line(points={{-118,-100},{-110,-100},{-110,
          -86},{-62,-86}},  color={255,0,255}));

  connect(or2.y, edg1.u)
    annotation (Line(points={{142,-120},{148,-120}}, color={255,0,255}));

  connect(edg1.y, yStaChaPro)
    annotation (Line(points={{172,-120},{200,-120}}, color={255,0,255}));

  connect(edg1.y, pre.u) annotation (Line(points={{172,-120},{174,-120},{174,-132},
          {-150,-132},{-150,-100},{-142,-100}}, color={255,0,255}));

  connect(mulAnd2.y, and1.u2) annotation (Line(points={{102,-90},{108,-90},{108,
          -98},{118,-98}}, color={255,0,255}));

  connect(lat1.y, mulOr1.u[1]) annotation (Line(points={{-38,-80},{-20,-80},{-20,
          -90},{-12,-90}},color={255,0,255}));

  connect(mulOr1.y, or2.u1) annotation (Line(points={{12,-90},{48,-90},{48,-136},
          {110,-136},{110,-120},{118,-120}}, color={255,0,255}));

  connect(booRep1.y, logSwi.u2) annotation (Line(points={{-18,120},{-10,120},{
          -10,70},{60,70},{60,50},{138,50}},
                                         color={255,0,255}));

  connect(logSwi.y, yBoi)
    annotation (Line(points={{162,50},{200,50}}, color={255,0,255}));

  connect(not1.y, truDel.u)
    annotation (Line(points={{-108,-10},{-62,-10}},color={255,0,255}));

  connect(swi.y, yHotWatIsoVal)
    annotation (Line(points={{162,-50},{200,-50}}, color={0,0,127}));

  connect(uPla, booRep1.u)
    annotation (Line(points={{-180,120},{-42,120}}, color={255,0,255}));
  connect(uPla, not1.u) annotation (Line(points={{-180,120},{-140,120},{-140,
          -10},{-132,-10}},
                       color={255,0,255}));
  connect(uPla, and2.u2) annotation (Line(points={{-180,120},{-140,120},{-140,
          10},{-34,10},{-34,-128},{-12,-128}},
                                           color={255,0,255}));
  connect(uHotWatIsoVal, disHotWatIsoVal.uHotWatIsoVal) annotation (Line(points={{-180,
          -40},{0,-40},{0,-44},{18,-44}},       color={0,0,127}));
  connect(disHotWatIsoVal.yDisHotWatIsoVal, mulAnd2.u[1:nBoi]) annotation (Line(
        points={{42,-44},{60,-44},{60,-90},{78,-90}},           color={255,0,255}));
  connect(disHotWatIsoVal.yDisHotWatIsoVal, mulAnd1.u[1:nBoi]) annotation (Line(
        points={{42,-44},{60,-44},{60,-116},{78,-116}},         color={255,0,255}));
  connect(disHotWatIsoVal.yHotWatIsoVal, swi.u1) annotation (Line(points={{42,-56},
          {100,-56},{100,-42},{138,-42}}, color={0,0,127}));
  connect(uHotWatIsoVal, swi.u3) annotation (Line(points={{-180,-40},{0,-40},{0,
          -32},{130,-32},{130,-58},{138,-58}}, color={0,0,127}));
  connect(booRep2.y, disHotWatIsoVal.uUpsDevSta) annotation (Line(points={{2,-10},
          {10,-10},{10,-50},{18,-50}}, color={255,0,255}));
  connect(booRep2.y, swi.u2) annotation (Line(points={{2,-10},{10,-10},{10,-20},
          {120,-20},{120,-50},{138,-50}}, color={255,0,255}));
  connect(and3.y, lat1.u) annotation (Line(points={{-68,-70},{-66,-70},{-66,-80},
          {-62,-80}}, color={255,0,255}));
  connect(uPumChaPro, and3.u2) annotation (Line(points={{-180,-80},{-100,-80},{
          -100,-78},{-92,-78}}, color={255,0,255}));
  connect(not1.y, and3.u1) annotation (Line(points={{-108,-10},{-100,-10},{-100,
          -70},{-92,-70}}, color={255,0,255}));
  connect(booRep2.y, disHotWatIsoVal.chaPro) annotation (Line(points={{2,-10},{10,
          -10},{10,-56},{18,-56}}, color={255,0,255}));
  annotation (defaultComponentName="plaDis",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=0.1),
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={28,108,200},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=5,
        borderPattern=BorderPattern.Raised),
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name"),
      Ellipse(
        extent={{-80,80},{80,-80}},
        lineColor={28,108,200},
        fillColor={170,255,213},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{-90,90},{90,-90}},
        lineColor={28,108,200}),
      Rectangle(
        extent={{-75,2},{75,-2}},
        lineColor={28,108,200},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-66,46},{76,10}},
        textColor={28,108,200},
        textString="START"),
      Text(
        extent={{-66,-8},{76,-44}},
        textColor={28,108,200},
        textString="STOP")},
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-140},{180,140}})),
  Documentation(
    info="<html>
    <p>
    Block that controls boiler plant disable process according to ASHRAE RP-1711, 
    March, 2020 draft, section 5.3.2.5.
    </p>
    <p>
    When the boiler plant is disabled by the plant enable controller
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable</a>,
    the controller performs the following actions:
    </p>
    <ol>
    <li>
    All the enabled boilers are disabled, ie, <code>yBoi[nBoi]=false</code>.
    </li>
    <li>
    A time period <code>delBoiDis</code> after the boilers have been disabled,any
    open hot water isolation valves are closed (if present) and any enabled pumps are disabled.
    </li>
    </ol>
    </html>",
    revisions="<html>
    <ul>
    <li>
    September 30, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end PlantDisable;

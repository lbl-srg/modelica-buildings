within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
block PlantDisable
    "Sequence to disable boiler plant components when plant has to be disabled"

  parameter Boolean primaryOnly = false
    "True: Boiler plant is primary-only; False: Boiler plant is not primary-only";

  parameter Boolean isHeadered = true
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumChaPro if not primaryOnly
    "Signal from pump controller indicating stage-up/stage-down has been completed"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatIsoVal[nBoi] if isHeadered
    "Boiler hot water isolation valve position vector"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enable status vector"
    annotation (Placement(transformation(extent={{180,30},{220,70}}),
      iconTransformation(extent={{100,50},{140,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaChaPro
    "Signal indicating end of stage change/plant disable process"
    annotation (Placement(transformation(extent={{180,-140},{220,-100}}),
      iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumChaPro if not primaryOnly
    "Signal indicating start of pump stage change process in primary pump controller"
    annotation (Placement(transformation(extent={{180,-30},{220,10}}),
      iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[nBoi] if isHeadered
    "Boiler hot water isolation valve position vector"
    annotation (Placement(transformation(extent={{180,-70},{220,-30}}),
      iconTransformation(extent={{100,-50},{140,-10}})));

protected
  parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index vector";

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Hold true/false signal based on whether the plant was enabled/disabled last"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detect when plant turns on"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Detect when plant turns off"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nBoi] if
    isHeadered
    "Identify indices of enabled boilers when plant was disabledboilers "
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nBoi](
    final k=boiInd) if isHeadered
    "Vector of boiler indices"
    annotation (Placement(transformation(extent={{-150,60},{-130,80}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nBoi] if
    isHeadered
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro[nBoi] if isHeadered
    "Identify indices of enabled boilers"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nBoi] if
    isHeadered
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nBoi) if isHeadered
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Subsequences.HWIsoVal disHotWatIsoVal[nBoi](
    final nBoi=fill(nBoi, nBoi),
    final chaHotWatIsoRat=fill(chaHotWatIsoRat, nBoi)) if isHeadered
    "Disable boiler hot water isolation valve for all disabled boilers simultaneously"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[nBoi]
    "Pass input boiler enable status when plant is enabled and disable all boilers when plant is disabled"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nBoi)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));

  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep[nBoi](
    final nout=fill(nBoi, nBoi)) if isHeadered
    "Real replicator"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(
    final nout=nBoi) if isHeadered
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delBoiDis,
    final delayOnInit=true)
    "Delay after all boilers have been disabled"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig[nBoi](
    final nin=nBoi) if isHeadered
    "Extract isolation valve position signal for each boiler isolation valve"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Pass through stage change completion signal from staging process controller when plant is enabled"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(
    final nu=nBoi) if primaryOnly and isHeadered
    "Multi And"
    annotation (Placement(transformation(extent={{80,-126},{100,-106}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if not primaryOnly
    "Hold pump change status after receiving signal from primary pump controller"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 if not primaryOnly and isHeadered
    "Signal stage change completion when both pump stage change and isolation valve change are complete"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre if not primaryOnly
    "Logical pre block"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Rising edge detector"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2 if not primaryOnly
    "Rising edge detector"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));


  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(
    final nu=nBoi) if not primaryOnly and isHeadered
    "Multi And"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nu=1) if not primaryOnly and not isHeadered
    "Multi Or"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nBoi](
    final uLow=0,
    final uHigh=0.01) if isHeadered
    "Hysteresis block"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi] if
    isHeadered
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1[nBoi] if
    isHeadered
    "Sample isolation valve position when they start to close"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi[nBoi] if isHeadered
    "Real switch"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

equation
  connect(edg.y, lat.u)
    annotation (Line(points={{-98,120},{-82,120}}, color={255,0,255}));

  connect(uPla, edg.u)
    annotation (Line(points={{-180,120},{-122,120}}, color={255,0,255}));

  connect(uPla, falEdg.u) annotation (Line(points={{-180,120},{-140,120},{-140,90},
          {-122,90}}, color={255,0,255}));

  connect(falEdg.y, lat.clr) annotation (Line(points={{-98,90},{-90,90},{-90,114},
          {-82,114}}, color={255,0,255}));

  connect(conInt.y, intToRea.u)
    annotation (Line(points={{-128,70},{-92,70}}, color={255,127,0}));

  connect(intToRea.y, pro.u1) annotation (Line(points={{-68,70},{-60,70},{-60,56},
          {-52,56}}, color={0,0,127}));

  connect(pro.y, triSam.u)
    annotation (Line(points={{-28,50},{-22,50}}, color={0,0,127}));

  connect(triSam.y, reaToInt.u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));

  connect(falEdg.y, booRep.u)
    annotation (Line(points={{-98,90},{-50,90},{-50,80},{-42,80}},
                                                 color={255,0,255}));

  connect(booRep.y, triSam.trigger) annotation (Line(points={{-18,80},{-4,80},{-4,
          74},{10,74},{10,34},{-10,34},{-10,38.2}},
                                    color={255,0,255}));

  connect(lat.y, booRep1.u)
    annotation (Line(points={{-58,120},{-42,120}}, color={255,0,255}));

  connect(uBoi, logSwi.u1) annotation (Line(points={{-180,50},{-140,50},{-140,
          16},{70,16},{70,58},{138,58}},
                                       color={255,0,255}));

  connect(booRep1.y, logSwi.u3) annotation (Line(points={{-18,120},{-10,120},{
          -10,70},{60,70},{60,42},{138,42}},
                         color={255,0,255}));

  connect(reaRep.y, disHotWatIsoVal.uHotWatIsoVal) annotation (Line(points={{-58,-40},
          {0,-40},{0,-45},{18,-45}},           color={0,0,127}));

  connect(reaToInt.y, disHotWatIsoVal.nexChaBoi) annotation (Line(points={{42,50},
          {50,50},{50,24},{10,24},{10,-42},{18,-42}},    color={255,127,0}));

  connect(booRep2.u, truDel.y)
    annotation (Line(points={{-22,-10},{-38,-10}}, color={255,0,255}));

  connect(disHotWatIsoVal.yHotWatIsoVal, extIndSig.u) annotation (Line(points={{42,-56},
          {70,-56},{70,-50},{78,-50}},         color={0,0,127}));

  connect(conInt.y, extIndSig.index) annotation (Line(points={{-128,70},{-126,70},
          {-126,20},{20,20},{20,0},{74,0},{74,-70},{90,-70},{90,-62}}, color={255,
          127,0}));

  connect(and2.y, or2.u2) annotation (Line(points={{12,-120},{60,-120},{60,-128},
          {118,-128}}, color={255,0,255}));

  connect(disHotWatIsoVal.yDisHotWatIsoVal, mulAnd1.u[1:nBoi]) annotation (Line(
        points={{42,-44},{66,-44},{66,-116},{78,-116}},           color={255,0,255}));

  connect(mulAnd1.y, or2.u1) annotation (Line(points={{102,-116},{110,-116},{110,
          -120},{118,-120}}, color={255,0,255}));

  connect(uStaChaProEnd, and2.u1)
    annotation (Line(points={{-180,-120},{-12,-120}}, color={255,0,255}));

  connect(uPumChaPro, lat1.u)
    annotation (Line(points={{-180,-80},{-102,-80}}, color={255,0,255}));

  connect(lat1.y, and1.u1) annotation (Line(points={{-78,-80},{-60,-80},{-60,-72},
          {114,-72},{114,-90},{118,-90}}, color={255,0,255}));

  connect(and1.y, or2.u1) annotation (Line(points={{142,-90},{152,-90},{152,-104},
          {116,-104},{116,-120},{118,-120}}, color={255,0,255}));

  connect(pre.y, lat1.clr) annotation (Line(points={{-118,-100},{-110,-100},{-110,
          -86},{-102,-86}}, color={255,0,255}));

  connect(or2.y, edg1.u)
    annotation (Line(points={{142,-120},{148,-120}}, color={255,0,255}));

  connect(edg1.y, yStaChaPro)
    annotation (Line(points={{172,-120},{200,-120}}, color={255,0,255}));

  connect(edg1.y, pre.u) annotation (Line(points={{172,-120},{174,-120},{174,-132},
          {-150,-132},{-150,-100},{-142,-100}}, color={255,0,255}));

  connect(truDel.y, edg2.u) annotation (Line(points={{-38,-10},{-30,-10},{-30,-26},
          {130,-26},{130,-10},{138,-10}}, color={255,0,255}));

  connect(edg2.y, yPumChaPro)
    annotation (Line(points={{162,-10},{200,-10}}, color={255,0,255}));

  connect(mulAnd2.y, and1.u2) annotation (Line(points={{102,-90},{108,-90},{108,
          -98},{118,-98}}, color={255,0,255}));

  connect(disHotWatIsoVal.yDisHotWatIsoVal, mulAnd2.u[1:nBoi]) annotation (Line(
        points={{42,-44},{66,-44},{66,-90},{78,-90}}, color={255,0,255}));

  connect(lat1.y, mulOr1.u[1]) annotation (Line(points={{-78,-80},{-20,-80},{-20,
          -90},{-12,-90}},color={255,0,255}));

  connect(mulOr1.y, or2.u1) annotation (Line(points={{12,-90},{48,-90},{48,-136},
          {110,-136},{110,-120},{118,-120}}, color={255,0,255}));

  connect(booRep1.y, logSwi.u2) annotation (Line(points={{-18,120},{-10,120},{
          -10,70},{60,70},{60,50},{138,50}},
                                         color={255,0,255}));

  connect(lat.y, and2.u2) annotation (Line(points={{-58,120},{-50,120},{-50,106},
          {0,106},{0,80},{66,80},{66,-32},{-40,-32},{-40,-128},{-12,-128}},
        color={255,0,255}));

  connect(logSwi.y, yBoi)
    annotation (Line(points={{162,50},{200,50}}, color={255,0,255}));

  connect(hys.y, booToRea.u)
    annotation (Line(points={{-98,40},{-92,40}}, color={255,0,255}));

  connect(uHotWatIsoVal, hys.u) annotation (Line(points={{-180,-40},{-154,-40},
          {-154,40},{-122,40}},color={0,0,127}));

  connect(booToRea.y, pro.u2) annotation (Line(points={{-68,40},{-60,40},{-60,44},
          {-52,44}}, color={0,0,127}));

  connect(not1.y, truDel.u)
    annotation (Line(points={{-78,-10},{-62,-10}}, color={255,0,255}));

  connect(lat.y, not1.u) annotation (Line(points={{-58,120},{-50,120},{-50,106},
          {0,106},{0,80},{66,80},{66,8},{-110,8},{-110,-10},{-102,-10}}, color=
          {255,0,255}));

  connect(booRep2.y, disHotWatIsoVal.chaPro) annotation (Line(points={{2,-10},{
          6,-10},{6,-58},{18,-58}}, color={255,0,255}));

  connect(booRep2.y, disHotWatIsoVal.uUpsDevSta) annotation (Line(points={{2,
          -10},{6,-10},{6,-55},{18,-55}}, color={255,0,255}));

  connect(uHotWatIsoVal, triSam1.u)
    annotation (Line(points={{-180,-40},{-122,-40}}, color={0,0,127}));

  connect(triSam1.y, reaRep.u)
    annotation (Line(points={{-98,-40},{-82,-40}}, color={0,0,127}));

  connect(booRep.y, triSam1.trigger) annotation (Line(points={{-18,80},{-4,80},
          {-4,74},{10,74},{10,26},{-130,26},{-130,-60},{-110,-60},{-110,-51.8}},
        color={255,0,255}));

  connect(extIndSig.y, swi.u3) annotation (Line(points={{102,-50},{110,-50},{
          110,-58},{138,-58}}, color={0,0,127}));

  connect(booRep1.y, swi.u2) annotation (Line(points={{-18,120},{-10,120},{-10,
          70},{60,70},{60,42},{120,42},{120,-50},{138,-50}}, color={255,0,255}));

  connect(uHotWatIsoVal, swi.u1) annotation (Line(points={{-180,-40},{-140,-40},
          {-140,-66},{130,-66},{130,-42},{138,-42}}, color={0,0,127}));

  connect(swi.y, yHotWatIsoVal)
    annotation (Line(points={{162,-50},{200,-50}}, color={0,0,127}));

  annotation (defaultComponentName=
    "plaDis",
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
        lineColor={0,0,255},
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
        lineColor={28,108,200},
        textString="START"),
      Text(
        extent={{-66,-8},{76,-44}},
        lineColor={28,108,200},
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
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement</a>,
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

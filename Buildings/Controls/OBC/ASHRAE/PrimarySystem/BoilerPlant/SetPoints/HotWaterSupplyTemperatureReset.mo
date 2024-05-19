within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints;
block HotWaterSupplyTemperatureReset
  "Block to calculate temperature setpoint for hot water supply temperature"

  parameter Integer nPum = 2
    "Number of pumps in the boiler plant loop"
    annotation(Dialog(group="Plant parameters"));

  parameter Integer nSta = 3
    "Number of stages in the boiler plant"
    annotation(Dialog(group="Plant parameters"));

  parameter Integer nBoi = 2
    "Number of boilers in the plant"
    annotation(Dialog(group="Plant parameters"));

  parameter Integer nHotWatResReqIgn = 2
    "Number of hot-water supply temperature reset requests to be ignored"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Integer boiTyp[nBoi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler}
    "Boiler type vector"
    annotation(Dialog(group="Plant parameters"));

  parameter Real TPlaHotWatSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot-water setpoint temperature for the plant"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot water setpoint temperature for condensing boilers"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real TConBoiHotWatSetOff(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -10
    "The offset for hot water setpoint temperature for condensing boilers in 
    non-condensing stage type"
    annotation(Dialog(group="Plant parameters"));

  parameter Real THotWatSetMinNonConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 341.48
    "The minimum allowed hot-water setpoint temperature for non-condensing boilers"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real THotWatSetMinConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 305.37
    "The minimum allowed hot-water setpoint temperature for condensing boilers"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real delTimVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Delay time"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real samPerVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Sample period"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real triAmoVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -2
    "Setpoint trim value"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real resAmoVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Setpoint respond value"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real maxResVal(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 7
    "Setpoint maximum respond value"
    annotation(Dialog(group="Trim-and-Respond Logic parameters"));

  parameter Real holTimVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Minimum setpoint hold time for stage change process"
    annotation(Dialog(group="Plant parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaCha
    "Signal indicating plant is in the staging process"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPumSta[nPum]
    "Status of hot-water pumps"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nHotWatSupResReq
    "Number of hot-water supply temperature reset requests"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta]
    "Stage type vector for boiler plant"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCurStaSet
    "Current stage setpoint index"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TPlaHotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot-water supply temperature setpoint for the plant"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TBoiHotWatSupSet[nBoi](
    final unit=fill("K",nBoi),
    displayUnit=fill("K",nBoi),
    final quantity=fill("ThermodynamicTemperature",nBoi))
    "Temperature setpoint vector for boilers"
    annotation (Placement(transformation(extent={{140,-250},{180,-210}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Select plant setpoint based on stage type"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(nin=nSta)
    "Extract stage type for current stage"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler)
    "Check for non-condensing stage type"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond triRes(
    final iniSet=TPlaHotWatSetMax,
    final minSet=THotWatSetMinNonConBoi,
    final maxSet=TPlaHotWatSetMax,
    final delTim=delTimVal,
    final samplePeriod=samPerVal,
    final numIgnReq=nHotWatResReqIgn,
    final triAmo=triAmoVal,
    final resAmo=resAmoVal,
    final maxRes=maxResVal)
    "Trim and respond controller for non-condensing stage type"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detect start of stage change process"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueHold truHol(
    final duration=holTimVal)
    "Hold setpoint value for duration of stage change"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Retain last value before stage change initiates"
    annotation (Placement(transformation(extent={{50,40},{70,60}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any pumps are turned on"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond triRes1(
    final iniSet=TPlaHotWatSetMax,
    final minSet=THotWatSetMinConBoi,
    final maxSet=TPlaHotWatSetMax,
    final delTim=delTimVal,
    final samplePeriod=samPerVal,
    final numIgnReq=nHotWatResReqIgn,
    final triAmo=triAmoVal,
    final resAmo=resAmoVal,
    final maxRes=maxResVal)
    "Trim and respond controller for condensing stage type"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant boiTypVec[nBoi](
    final k=boiTyp)
    "Boiler type vector"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greThr1[nBoi](
    final t=fill(Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,nBoi))
    "Identify non-condensing boilers in plant"
    annotation (Placement(transformation(extent={{-80,-260},{-60,-240}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi](
    final realTrue=fill(0, nBoi),
    final realFalse=fill(1, nBoi))
    "Generate binary vector to identify condensing boilers"
    annotation (Placement(transformation(extent={{-40,-240},{-20,-220}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nBoi](
    final realTrue=fill(1, nBoi),
    final realFalse=fill(0, nBoi))
    "Generate binary vector to identify non-condensing boilers"
    annotation (Placement(transformation(extent={{-40,-280},{-20,-260}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nBoi)
    "Convert temperature setpoint into vector"
    annotation (Placement(transformation(extent={{10,-200},{30,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro[nBoi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{60,-200},{80,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Logical Switch"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Add add2[nBoi]
    "Combine setpoint vectors for condensing and non-condensing boilers"
    annotation (Placement(transformation(extent={{100,-240},{120,-220}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=TConBoiHotWatSetMax)
    "Design setpoint for condensing boilers"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=TConBoiHotWatSetOff)
    "Boiler setpoint for condensing boilers in non-condensing type stage"
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Min min
    "Ensure condensing boiler setpoint does not exceed design setpoint"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nBoi)
    "Convert temperature setpoint into vector"
    annotation (Placement(transformation(extent={{10,-310},{30,-290}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1[nBoi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{60,-280},{80,-260}})));

equation
  connect(uHotWatPumSta, mulOr.u[1:nPum]) annotation (Line(points={{-160,90},{-122,
          90}},                   color={255,0,255}));
  connect(mulOr.y, triRes.uDevSta)
    annotation (Line(points={{-98,90},{-60,90},{-60,98},{-42,98}},
                                                           color={255,0,255}));
  connect(truHol.u, uStaCha)
    annotation (Line(points={{-42,-30},{-50,-30},{-50,0},{-160,0}},
                                                   color={255,0,255}));
  connect(edg.u, uStaCha) annotation (Line(points={{-42,0},{-160,0}},
                      color={255,0,255}));
  connect(edg.y, triSam.trigger) annotation (Line(points={{-18,0},{60,0},{60,38}},
                  color={255,0,255}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{72,50},{80,50},{80,8},{98,8}}, color={0,0,127}));
  connect(truHol.y, swi.u2) annotation (Line(points={{-18,-30},{80,-30},{80,0},{
          98,0}}, color={255,0,255}));
  connect(triRes.numOfReq, nHotWatSupResReq) annotation (Line(points={{-42,82},{
          -50,82},{-50,50},{-160,50}},
                                    color={255,127,0}));
  connect(swi.y, TPlaHotWatSupSet)
    annotation (Line(points={{122,0},{160,0}}, color={0,0,127}));
  connect(swi1.y, triSam.u) annotation (Line(points={{32,70},{40,70},{40,50},{48,
          50}}, color={0,0,127}));
  connect(triRes.y, swi1.u1) annotation (Line(points={{-18,90},{0,90},{0,78},{8,
          78}},   color={0,0,127}));
  connect(triRes1.y, swi1.u3)
    annotation (Line(points={{-18,50},{0,50},{0,62},{8,62}}, color={0,0,127}));
  connect(triRes1.numOfReq, nHotWatSupResReq) annotation (Line(points={{-42,42},
          {-50,42},{-50,50},{-160,50}}, color={255,127,0}));
  connect(triRes1.uDevSta, mulOr.y) annotation (Line(points={{-42,58},{-60,58},{
          -60,90},{-98,90}},   color={255,0,255}));
  connect(swi1.y, swi.u3) annotation (Line(points={{32,70},{40,70},{40,-8},{98,-8}},
        color={0,0,127}));
  connect(uCurStaSet, extIndSig.index) annotation (Line(points={{-160,-120},{-70,
          -120},{-70,-82}}, color={255,127,0}));
  connect(extIndSig.u, intToRea.y)
    annotation (Line(points={{-82,-70},{-98,-70}}, color={0,0,127}));
  connect(intToRea.u, uTyp)
    annotation (Line(points={{-122,-70},{-160,-70}}, color={255,127,0}));
  connect(extIndSig.y, greThr.u)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={0,0,127}));
  connect(greThr.y, swi1.u2) annotation (Line(points={{-18,-70},{-10,-70},{-10,70},
          {8,70}}, color={255,0,255}));
  connect(boiTypVec.y, greThr1.u)
    annotation (Line(points={{-98,-250},{-82,-250}},  color={0,0,127}));
  connect(booToRea1.u, greThr1.y) annotation (Line(points={{-42,-270},{-50,-270},
          {-50,-250},{-58,-250}}, color={255,0,255}));
  connect(booToRea.u, greThr1.y) annotation (Line(points={{-42,-230},{-50,-230},
          {-50,-250},{-58,-250}}, color={255,0,255}));
  connect(add2.y, TBoiHotWatSupSet)
    annotation (Line(points={{122,-230},{160,-230}}, color={0,0,127}));
  connect(swi2.u2, greThr.y) annotation (Line(points={{-42,-190},{-50,-190},{-50,
          -100},{-10,-100},{-10,-70},{-18,-70}},
                           color={255,0,255}));
  connect(swi2.u3, swi.y) annotation (Line(points={{-42,-198},{-46,-198},{-46,-210},
          {-130,-210},{-130,-130},{130,-130},{130,0},{122,0}},
                                      color={0,0,127}));
  connect(addPar.u, swi.y) annotation (Line(points={{-122,-190},{-130,-190},{-130,
          -130},{130,-130},{130,0},{122,0}}, color={0,0,127}));
  connect(min.u1, con.y) annotation (Line(points={{-82,-164},{-90,-164},{-90,-150},
          {-98,-150}}, color={0,0,127}));
  connect(min.u2, addPar.y) annotation (Line(points={{-82,-176},{-90,-176},{-90,
          -190},{-98,-190}}, color={0,0,127}));
  connect(min.y, swi2.u1) annotation (Line(points={{-58,-170},{-46,-170},{-46,-182},
          {-42,-182}}, color={0,0,127}));
  connect(swi2.y, reaRep.u)
    annotation (Line(points={{-18,-190},{8,-190}},color={0,0,127}));
  connect(pro.u1, reaRep.y) annotation (Line(points={{58,-184},{50,-184},{50,-190},
          {32,-190}}, color={0,0,127}));
  connect(reaRep1.u, swi.y) annotation (Line(points={{8,-300},{-130,-300},{-130,
          -130},{130,-130},{130,0},{122,0}}, color={0,0,127}));
  connect(booToRea.y, pro.u2) annotation (Line(points={{-18,-230},{50,-230},{50,
          -196},{58,-196}}, color={0,0,127}));
  connect(pro.y, add2.u1) annotation (Line(points={{82,-190},{90,-190},{90,-224},
          {98,-224}}, color={0,0,127}));
  connect(reaRep1.y, pro1.u2) annotation (Line(points={{32,-300},{50,-300},{50,-276},
          {58,-276}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-18,-270},{50,-270},{50,
          -264},{58,-264}}, color={0,0,127}));
  connect(pro1.y, add2.u2) annotation (Line(points={{82,-270},{90,-270},{90,-236},
          {98,-236}}, color={0,0,127}));

annotation(defaultComponentName="hotWatSupTemRes",
  Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-320},{140,120}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
      graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={28,108,200},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-50,20},{50,-20}},
                  textColor={28,108,200},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.None,
                  textString="hotWatSupTemRes"),
                Text(
                  extent={{-100,150},{100,110}},
                  textColor={0,0,255},
                  textString="%name")}),
  Documentation(info="<html>
<p>
Control sequence for hot-water supply temperature setpoint <code>TPlaHotWatSupSet</code>
for boiler plant loop as per section 5.3.4 in ASHRAE RP-1711, March 2020 draft.
</p>
<ul>
<li>
The setpoint controller is enabled when any of the hot-water supply pumps
are proven on <code>uHotWatPumSta = true</code>, and disabled otherwise.
</li>
<li>
When enabled, a Trim-and-Respond logic controller adjusts the supply
temperature setpoint <code>TPlaHotWatSupSet</code> according to the following parameters:
</li>
</ul>
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>Any hot water pump</td> <td>Associated device</td></tr>
<tr><td>iniSet</td><td><code>TPlaHotWatSetMax</code></td><td>Initial setpoint</td></tr>
<tr><td>minSet</td><td><code>THotWatSetMinConBoi</code> for condensing boilers;<br><code>THotWatSetMinNonConBoi</code> for non-condensing boilers</td><td>Minimum setpoint</td></tr>
<tr><td>maxSet</td><td><code>TPlaHotWatSetMax</code></td><td>Maximum setpoint</td></tr>
<tr><td>delTim</td><td><code>delTimVal</code></td><td>Delay timer</td></tr>
<tr><td>samplePeriod</td><td><code>samPerVal</code></td><td>Time step</td></tr>
<tr><td>numIgnReq</td><td><code>nHotWatResReqIgn</code></td><td>Number of ignored requests</td></tr>
<tr><td>numOfReq</td><td><code>nHotWatSupResReq</code></td><td>Number of requests</td></tr>
<tr><td>triAmo</td><td><code>triAmoVal</code></td><td>Trim amount</td></tr>
<tr><td>resAmo</td><td><code>resAmoVal</code></td><td>Respond amount</td></tr>
<tr><td>maxRes</td><td><code>maxResVal</code></td><td>Maximum response per time interval</td></tr>
</table>
<ul>
<li>
When the plant stage change is initiated <code>uStaCha=true</code>, the 
temperature reset shall be disabled and value fixed at its last value for 
the longer of <code>holTimVal</code> and the time it takes for the plant 
to successfully stage.
</li>
<li>
When the current stage type <code>uTyp[uCurStaSet]</code> is condensing type, the
condensing boiler setpoint <code>TBoiHotWatSupSet</code> shall be the plant
hot water supply setpoint <code>TPlaHotWatSupSet</code>.
</li>
<li>
When <code>uTyp[uCurStaSet]</code> is non-condensing type,
<ul>
<li>
the non-condensing boiler setpoints in <code>TBoiHotWatSupSet</code> shall
be <code>TPlaHotWatSupSet</code>.
</li>
<li>
minimum setpoint <code>minSet</code> in the Trim-and-Respond logic is reset to <code>THotWatSetMinNonConBoi</code>.
</li>
<li>
condensing boiler setpoints in <code>TBoiHotWatSupSet</code> shall be
lesser of condensing boiler design supply temperature <code>TConBoiHotWatSetMax</code>,
and <code>TPlaHotWatSupSet</code> less an offset of <code>TConBoiHotWatSetOff</code>,
ie, <code>TPlaHotWatSupSet</code> - <code>TConBoiHotWatSetOff</code>.
</li>
</ul>
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
February 23, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end HotWaterSupplyTemperatureReset;

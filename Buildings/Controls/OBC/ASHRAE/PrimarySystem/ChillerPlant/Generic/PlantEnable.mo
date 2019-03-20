within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block PlantEnable "Sequence to enable and disable plant"


  parameter Boolean haveWSE = true
    "Flag to indicate if the plant has waterside economizer";
  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour";
  parameter Buildings.Controls.OBC.CDL.Types.Smoothness tabSmo=
    Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments
    "Smoothness of table interpolation";
  final parameter Buildings.Controls.OBC.CDL.Types.Extrapolation extrapolation=
    Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic
    "Extrapolation of data outside the definition range";
  parameter Modelica.SIunits.Temperature TChiLocOut
    "Outdoor air lockout temperature below which the chiller plant should be disabled";
  parameter Modelica.SIunits.Time plaThrTim = 15*60
    "Threshold time to check status of chiller plant";
  parameter Modelica.SIunits.Time reqThrTim = 3*60
    "Threshold time to check current chiller plant request";
  parameter Integer ignReq = 0
    "Ignorable chiller plant requests";
  parameter Integer iniSta = 1
    "Lowest chiller plant stage";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Current chiller plant enabling status"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Cooling chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreHeaChaLea(
    final unit="K",
    final quantity="ThermodynamicTemperature") if haveWSE
    "Predicted heat exchanger leaving water temperature"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature") if haveWSE
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PLRHeaExc(
    final min=0,
    final max=1,
    final unit="1") if haveWSE
    "Heat exchanger part load ratio"
    annotation (Placement(transformation(extent={{-240,-300},{-200,-260}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIniChiSta
    "Initial chiller plant stage"
    annotation (Placement(transformation(extent={{200,-290},{220,-270}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Chiller plant enabling status"
    annotation (Placement(transformation(extent={{200,80},{220,100}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=tabSmo,
    final extrapolation=extrapolation)
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=(-1)*TChiLocOut,
    final k=1)
    "Difference between chiller lockout temperature and outdoor temperature"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold schOn(
    final threshold=0.5)
    "Check if enabling schedule is active"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer disTim
    "Chiller plant disabled time"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold hasReq(
    final threshold=ignReq)
    "Check if the chiller plant request is greater than ignorable request"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=4)
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer enaTim "Chiller plant enabled time"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
    final threshold=ignReq)
    "Check if the chiller plant request is less than ignorable request"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer enaTim1
    "Total time when chiller plant request is less than ignorable request"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=TChiLocOut - 5/9,
    final k=-1)
    "Difference between chiller lockout temperature and outdoor temperature"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{140,-290},{160,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintains an on signal until conditions changes"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    annotation (Placement(transformation(extent={{120,-250},{140,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=iniSta)
    "Lowest chiller stage"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=0.05, final uHigh=0.1)
    "Check if outdoor temperature is higher than chiller lockout temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=plaThrTim)
    "Check if chiller plant has been disabled more than threshold time"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=plaThrTim)
    "Check if chiller plant has been enabled more than threshold time"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=0.05, final uHigh=0.1)
    "Check if outdoor temperature is lower than chiller lockout temperature minus 1 degF"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr2(
    final threshold=reqThrTim)
    "Check if number of chiller plant request has been less than ignorable request by more than threshold time"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 mulOr "Logical or"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=0)
    "Zero stage"
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 if haveWSE "Logical and"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis equOne(
    final uLow=0.98,
    final uHigh=0.99) if haveWSE
    "Check if heat exchanger part load ratio equals to 1"
    annotation (Placement(transformation(extent={{-160,-290},{-140,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=5/9, final k=1) if haveWSE
    "1 degF lower than chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=0.05, final uHigh=0.1) if haveWSE
    "Check if predict heat exchange leaving water temperature is greater than chilled water supply temperature setpoint minus 1degF"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback if haveWSE
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(final k=true) if not haveWSE
    "Constant true"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));

equation
  connect(addPar.y, hys.u)
    annotation (Line(points={{-119,10},{-102,10}}, color={0,0,127}));
  connect(TOut, addPar.u)
    annotation (Line(points={{-220,10},{-142,10}}, color={0,0,127}));
  connect(enaSch.y[1], schOn.u)
    annotation (Line(points={{-119,60},{-102,60}}, color={0,0,127}));
  connect(uPla, not1.u)
    annotation (Line(points={{-220,140},{-142,140}}, color={255,0,255}));
  connect(not1.y, disTim.u)
    annotation (Line(points={{-119,140},{-102,140}}, color={255,0,255}));
  connect(disTim.y, greEquThr.u)
    annotation (Line(points={{-79,140},{-62,140}}, color={0,0,127}));
  connect(TChiWatSupResReq, hasReq.u)
    annotation (Line(points={{-220,100},{-142,100}}, color={255,127,0}));
  connect(uPla, enaTim.u)
    annotation (Line(points={{-220,140},{-160,140},{-160,-40},{-142,-40}},
      color={255,0,255}));
  connect(enaTim.y, greEquThr1.u)
    annotation (Line(points={{-119,-40},{-102,-40}}, color={0,0,127}));
  connect(TChiWatSupResReq, intLesThr.u)
    annotation (Line(points={{-220,100},{-170,100},{-170,-100},{-142,-100}},
      color={255,127,0}));
  connect(intLesThr.y, enaTim1.u)
    annotation (Line(points={{-119,-100},{-102,-100}}, color={255,0,255}));
  connect(enaTim1.y, greEquThr2.u)
    annotation (Line(points={{-79,-100},{-62,-100}}, color={0,0,127}));
  connect(TOut, addPar1.u)
    annotation (Line(points={{-220,10},{-180,10},{-180,-140},{-142,-140}},
      color={0,0,127}));
  connect(addPar1.y, hys3.u)
    annotation (Line(points={{-119,-140},{-102,-140}}, color={0,0,127}));
  connect(greEquThr1.y, and2.u1)
    annotation (Line(points={{-79,-40},{-60,-40},{-60,-10},{38,-10}},
      color={255,0,255}));
  connect(greEquThr.y, mulAnd.u[1])
    annotation (Line(points={{-39,140},{-20,140},{-20,95.25},{38,95.25}},
      color={255,0,255}));
  connect(hasReq.y, mulAnd.u[2])
    annotation (Line(points={{-119,100},{-40,100},{-40,91.75},{38,91.75}},
      color={255,0,255}));
  connect(schOn.y, mulAnd.u[3])
    annotation (Line(points={{-79,60},{-40,60},{-40,88.25},{38,88.25}},
      color={255,0,255}));
  connect(hys.y, mulAnd.u[4])
    annotation (Line(points={{-79,10},{-20,10},{-20,84.75},{38,84.75}},
      color={255,0,255}));
  connect(schOn.y, not2.u)
    annotation (Line(points={{-79,60},{-40,60},{-40,-50},{-22,-50}},
      color={255,0,255}));
  connect(mulAnd.y, lat.u)
    annotation (Line(points={{61.7,90},{99,90}}, color={255,0,255}));
  connect(and2.y, lat.u0)
    annotation (Line(points={{61,-10},{80,-10},{80,84},{99,84}}, color={255,0,255}));
  connect(lat.y, yPla)
    annotation (Line(points={{121,90},{210,90}}, color={255,0,255}));
  connect(mulOr.y, and2.u2)
    annotation (Line(points={{61,-100},{80,-100},{80,-40},{20,-40},{20,-18},
      {38,-18}}, color={255,0,255}));
  connect(lat.y, edg.u)
    annotation (Line(points={{121,90},{140,90},{140,60},{100,60},{100,-240},
      {118,-240}},color={255,0,255}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{141,-240},{150,-240},{150,-211.8}}, color={255,0,255}));
  connect(triSam.y, reaToInt.u)
    annotation (Line(points={{161,-200},{180,-200},{180,-260},{120,-260},
      {120,-280},{138,-280}}, color={0,0,127}));
  connect(reaToInt.y, yIniChiSta)
    annotation (Line(points={{161,-280},{210,-280}}, color={255,127,0}));
  connect(PLRHeaExc, equOne.u)
    annotation (Line(points={{-220,-280},{-192,-280},{-192,-280},{-162,-280}},
      color={0,0,127}));
  connect(TChiWatSupSet, addPar2.u)
    annotation (Line(points={{-220,-240},{-182,-240}}, color={0,0,127}));
  connect(TPreHeaChaLea, feedback.u1)
    annotation (Line(points={{-220,-200},{-152,-200}}, color={0,0,127}));
  connect(addPar2.y, feedback.u2)
    annotation (Line(points={{-159,-240},{-140,-240},{-140,-212}}, color={0,0,127}));
  connect(feedback.y, hys1.u)
    annotation (Line(points={{-129,-200},{-122,-200}}, color={0,0,127}));
  connect(con.y, swi.u1)
    annotation (Line(points={{21,-170},{40,-170},{40,-192},{58,-192}}, color={0,0,127}));
  connect(con1.y, swi.u3)
    annotation (Line(points={{21,-230},{40,-230},{40,-208},{58,-208}}, color={0,0,127}));
  connect(hys1.y, and1.u1)
    annotation (Line(points={{-99,-200},{-62,-200}}, color={255,0,255}));
  connect(equOne.y, and1.u2)
    annotation (Line(points={{-139,-280},{-80,-280},{-80,-208},{-62,-208}},
      color={255,0,255}));
  connect(and1.y, swi.u2)
    annotation (Line(points={{-39,-200},{58,-200}}, color={255,0,255}));
  connect(swi.y, triSam.u)
    annotation (Line(points={{81,-200},{138,-200}}, color={0,0,127}));
  connect(con2.y, swi.u2)
    annotation (Line(points={{-39,-270},{-20,-270},{-20,-200},{58,-200}},
      color={255,0,255}));
  connect(not2.y, mulOr.u1)
    annotation (Line(points={{1,-50},{20,-50},{20,-92},{38,-92}}, color={255,0,255}));
  connect(greEquThr2.y, mulOr.u2)
    annotation (Line(points={{-39,-100},{38,-100}}, color={255,0,255}));
  connect(hys3.y, mulOr.u3)
    annotation (Line(points={{-79,-140},{20,-140},{20,-108},{38,-108}}, color={255,0,255}));

annotation (
  defaultComponentName = "plaEna",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-340},{200,160}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-17,7.5},{17,-7.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-83,97.5},
          rotation=0,
          textString="uPla"),
        Text(
          extent={{-49,9.5},{49,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-49,59.5},
          rotation=0,
          textString="TChiWatSupResReq"),
        Text(
          extent={{-16,6.5},{16,-6.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-84,20.5},
          rotation=0,
          textString="TOut"),
        Text(
          extent={{-17,7.5},{17,-7.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={81,-0.5},
          rotation=0,
          textString="yPla"),
        Text(
          extent={{-27,9},{27,-9}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={69,-59},
          rotation=0,
          textString="yIniChiSta"),
        Text(
          extent={{-39,7.5},{39,-7.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-57,-20.5},
          rotation=0,
          textString="TPreHeaChaLea"),
        Text(
          extent={{-36,8.5},{36,-8.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-60,-59.5},
          rotation=0,
          textString="TChiWatSupSet"),
        Text(
          extent={{-28,6.5},{28,-6.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={-68,-91.5},
          rotation=0,
          textString="PLRHeaExc")}),
 Documentation(info="<html>
<p>
Block that generate chiller plant enable signals, according to
ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), section 5.2.2.
</p>
<ol>
<li>
An enabling schedule should be included to allow operators to lock out the 
chiller plant during off-hour, e.g. to allow off-hour operation of HVAC systems
except the chiller plant. The default schedule shall be 24/7 and be adjustable.
</li>
<li>
The plant should be enabled in the lowest stage when the plant has been
disabled for at least <code>plaThrTim</code>, e.g. 15 minutes and: 
<ul>
<li>
Number of chiller plant requests &gt; <code>ignReq</code> (<code>ignReq</code>
should default to 0 and adjustable), and,
</li>
<li>
Outdoor air temperature is greater than chiller lockout temperature, 
<code>TOut</code> &gt; <code>TChiLocOut</code>, and,
</li>
<li>
The chiller enable schedule is active.
</li>
</ul>
</li>

<li>
The plant should be disabled when it has been enabled for at least 
<code>plaThrTim</code>, e.g. 15 minutes and:


</li>
</ol>

</html>",
revisions="<html>
<ul>
<li>
January 24, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantEnable;

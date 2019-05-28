within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer nSta = 3
    "Total number of stages";

  parameter Modelica.SIunits.Power staNomCap[nSta] = fill(5e5, nSta)
    "Array of nominal capacities at each individual stage";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = fill(0.2*staNomCap[1], nSta)
    "Array of unload capacities at each individual stage";

  final parameter Real lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaAva[nSta]
    "Stage availability status"
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(
    final min = 0,
    final max = nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{260,150},{280,170}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDowNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{260,70},{280,90}}),
      iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the next higher stage"
                                                annotation (Placement(
      transformation(extent={{260,110},{280,130}}),
      iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMin(
    final unit="W",
    final quantity="Power")
    "Minimum capacity of the current stage" annotation (Placement(
      transformation(extent={{260,30},{280,50}}),   iconTransformation(extent={{100,-80},
            {120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="W",
    final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{260,-10},{280,10}}),
      iconTransformation(extent={{100,-60},{120,-40}})));

//protected
  final parameter Real small = 0.001
  "Small number to avoid division with zero";

  final parameter Real large = staNomCap[end]*nSta*10
  "Value to avoid stage up when at the highest stage";

  final parameter Integer staRan[nSta] = {i for i in 1:nSta}
  "Range with all possible stage values";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant integer"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert staExc(
    final message="The provided chiller stage is not within the number of stages available")
    "Error assertion"
    annotation (Placement(transformation(extent={{220,260},{240,280}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[2](final
      threshold=fill(-0.5, 2)) "Less than threshold"
    annotation (Placement(transformation(extent={{140,260},{160,280}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCap(
    final outOfRangeValue=-1,
    final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaLowCap(
    final outOfRangeValue=-1,
    final nin=nSta,
    allowOutOfRange=true)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt "Adds to index"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCapMin(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaUpCap(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=large)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaCapMin(
    final nin=nSta,
    final outOfRangeValue=0,
    final allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant smaNum(
    final k=small) "Small number to prevent division with zero downstream"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant larNum(
    final k=large) "Large number to prevent staging up at the highest stage"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));

  Buildings.Controls.OBC.CDL.Integers.Add subInt(
    final k1=-1) "Subtracts from index"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant maxSta(
    final k=nSta) "Highest stage"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{220,120},{240,140}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Switch"
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaDowNom
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Max forStaNom
    "To avoid division zero downstream"
    annotation (Placement(transformation(extent={{220,180},{240,200}})));

  Modelica.Blocks.Logical.Switch swi1
    "Use minimum stage capacity for nominal stage down capacity if operating in the lowest available stage"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));

  Buildings.Controls.OBC.CDL.Integers.Min forCurSta
    "Limiter for current stage capacity extraction"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nu=2)
    "Or operator on array inputs"
    annotation (Placement(transformation(extent={{180,260},{200,280}})));

  CDL.Integers.Sources.Constant stages[nSta](final k=staRan)
    "Range with all possible stages"
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  CDL.Conversions.BooleanToInteger booToInt[nSta](integerTrue=fill(1, nSta),
      integerFalse=fill(0, nSta))
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  CDL.Integers.MultiSum mulSumInt(nin=nSta, k=fill(1, nSta))
    "Counts number of available stages below and including currenta stage"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));
  CDL.Integers.Equal equLowSta "Check if stage is the lowest available"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));
  CDL.Integers.GreaterEqual
                         intGreEqu[nSta]
    annotation (Placement(transformation(extent={{-180,-202},{-160,-182}})));
  CDL.Routing.IntegerReplicator intRep(nout=nSta)
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
  CDL.Logical.And and2[nSta]
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  CDL.Interfaces.BooleanOutput lowSta "Operating at the lowest available stage"
    annotation (Placement(transformation(extent={{260,-150},{280,-130}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  CDL.Integers.Equal equHigSta "Check if the stage is the highest available"
    annotation (Placement(transformation(extent={{0,-260},{20,-240}})));
  CDL.Conversions.BooleanToInteger booToInt1
                                           [nSta](integerTrue=fill(1, nSta),
      integerFalse=fill(0, nSta))
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  CDL.Integers.MultiSum mulSumInt1(nin=nSta, k=fill(1, nSta))
    "Counts number of available stages"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  CDL.Interfaces.RealInput uNomCap[nSta](final quantity="Power", final unit="W")
    "Nominal stage capacities considering the chiller availability" annotation (
     Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  CDL.Interfaces.RealInput uMinCap[nSta](final quantity="Power", final unit="W")
    "Unload stage capacities considering the chiller availability" annotation (
      Placement(transformation(extent={{-302,-272},{-262,-232}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
equation
  connect(uSta, addInt.u1) annotation (Line(points={{-280,80},{-130,80},{-130,36},
          {-102,36}}, color={255,127,0}));
  connect(one.y, addInt.u2) annotation (Line(points={{-199,0},{-120,0},{-120,24},
          {-102,24}},     color={255,127,0}));
  connect(uSta, subInt.u2) annotation (Line(points={{-280,80},{-130,80},{-130,54},
          {-102,54}}, color={255,127,0}));
  connect(one.y, subInt.u1) annotation (Line(points={{-199,0},{-140,0},{-140,66},
          {-102,66}},     color={255,127,0}));
  connect(maxSta.y, forCurSta.u1) annotation (Line(points={{-199,100},{-190,100},
          {-190,166},{-102,166}},   color={255,127,0}));
  connect(uSta, forCurSta.u2) annotation (Line(points={{-280,80},{-180,80},{-180,
          154},{-102,154}},
                       color={255,127,0}));
  connect(forCurSta.y, extStaCapMin.index) annotation (Line(points={{-79,160},{60,
          160},{60,-120},{110,-120},{110,-102}},      color={255,127,0}));
  connect(forCurSta.y, extStaCap.index) annotation (Line(points={{-79,160},{-30,
          160},{-30,198}}, color={255,127,0}));
  connect(larNum.y, swi2.u1) annotation (Line(points={{161,230},{200,230},{200,138},
          {218,138}},color={0,0,127}));
  connect(swi2.y, yStaUpNom) annotation (Line(points={{241,130},{250,130},{250,120},
          {270,120}},color={0,0,127}));
  connect(extStaUpCap.y, swi2.u3) annotation (Line(points={{121,140},{172,140},{
          172,122},{218,122}},
                     color={0,0,127}));
  connect(yStaMin, yStaMin)
    annotation (Line(points={{270,40},{270,40}},   color={0,0,127}));
  connect(larNum.y, swi4.u1) annotation (Line(points={{161,230},{190,230},{190,-22},
          {218,-22}},  color={0,0,127}));
  connect(extStaUpCapMin.y, swi4.u3) annotation (Line(points={{121,-30},{140,-30},
          {140,-38},{218,-38}},    color={0,0,127}));
  connect(swi4.y, yStaUpMin) annotation (Line(points={{241,-30},{250,-30},{250,0},
          {270,0}},        color={0,0,127}));
  connect(mulOr.y, staExc.u) annotation (Line(points={{201.7,270},{218,270}},
                 color={255,0,255}));
  connect(extStaCapMin.y, yStaMin) annotation (Line(points={{121,-90},{180,-90},
          {180,40},{270,40}},   color={0,0,127}));
  connect(extStaCap.y, forStaNom.u1) annotation (Line(points={{-19,210},{0,210},
          {0,196},{218,196}}, color={0,0,127}));
  connect(forStaNom.y, yStaNom) annotation (Line(points={{241,190},{250,190},{250,
          160},{270,160}},   color={0,0,127}));
  connect(forStaNom.u2, smaNum.y) annotation (Line(points={{218,184},{180,184},{
          180,170},{161,170}},color={0,0,127}));
  connect(forStaDowNom.y, yStaDowNom)
    annotation (Line(points={{241,80},{270,80}},
                                               color={0,0,127}));
  connect(smaNum.y, forStaDowNom.u1) annotation (Line(points={{161,170},{180,170},
          {180,86},{218,86}},
                            color={0,0,127}));
  connect(swi1.y, forStaDowNom.u2) annotation (Line(points={{181,60},{200,60},{200,
          74},{218,74}}, color={0,0,127}));
  connect(addInt.y, extStaUpCap.index) annotation (Line(points={{-79,30},{110,30},
          {110,128}},     color={255,127,0}));
  connect(subInt.y, extStaLowCap.index)
    annotation (Line(points={{-79,60},{10,60},{10,128}},  color={255,127,0}));
  connect(addInt.y, extStaUpCapMin.index) annotation (Line(points={{-79,30},{40,
          30},{40,-60},{110,-60},{110,-42}},        color={255,127,0}));
  connect(one.y, equLowSta.u2) annotation (Line(points={{-199,0},{-10,0},{-10,
          -178},{-2,-178}},
                      color={255,127,0}));
  connect(mulSumInt.y, equLowSta.u1)
    annotation (Line(points={{-38.3,-170},{-2,-170}}, color={255,127,0}));
  connect(stages.y,intGreEqu. u2) annotation (Line(points={{-199,-210},{-190,-210},
          {-190,-200},{-182,-200}},       color={255,127,0}));
  connect(uSta, intRep.u) annotation (Line(points={{-280,80},{-250,80},{-250,-170},
          {-222,-170}},       color={255,127,0}));
  connect(intRep.y,intGreEqu. u1) annotation (Line(points={{-199,-170},{-190,-170},
          {-190,-192},{-182,-192}},       color={255,127,0}));
  connect(and2.y, booToInt.u)
    annotation (Line(points={{-119,-170},{-102,-170}}, color={255,0,255}));
  connect(uStaAva, and2.u1) annotation (Line(points={{-280,-40},{-240,-40},{-240,
          -150},{-150,-150},{-150,-170},{-142,-170}},      color={255,0,255}));
  connect(intGreEqu.y, and2.u2) annotation (Line(points={{-159,-192},{-150,-192},
          {-150,-178},{-142,-178}}, color={255,0,255}));
  connect(equLowSta.y, lowSta) annotation (Line(points={{21,-170},{240,-170},{240,
          -140},{270,-140}}, color={255,0,255}));
  connect(extStaLowCap.y, swi1.u3) annotation (Line(points={{21,140},{50,140},{50,
          52},{158,52}}, color={0,0,127}));
  connect(extStaCapMin.y, swi1.u1) annotation (Line(points={{121,-90},{130,-90},
          {130,68},{158,68}}, color={0,0,127}));
  connect(equLowSta.y, swi1.u2) annotation (Line(points={{21,-170},{150,-170},{150,
          60},{158,60}}, color={255,0,255}));
  connect(booToInt.y, mulSumInt.u) annotation (Line(points={{-79,-170},{-62,-170}},
                                                color={255,127,0}));
  connect(equHigSta.y, swi4.u2) annotation (Line(points={{21,-250},{210,-250},{
          210,-30},{218,-30}},
                           color={255,0,255}));
  connect(equHigSta.y, swi2.u2) annotation (Line(points={{21,-250},{210,-250},{
          210,130},{218,130}},
                           color={255,0,255}));
  connect(uStaAva, booToInt1.u)
    annotation (Line(points={{-280,-40},{-102,-40}}, color={255,0,255}));
  connect(mulSumInt1.y, equHigSta.u1) annotation (Line(points={{-38.3,-40},{-20,
          -40},{-20,-250},{-2,-250}}, color={255,127,0}));
  connect(mulSumInt.y, equHigSta.u2) annotation (Line(points={{-38.3,-170},{-28,
          -170},{-28,-258},{-2,-258}}, color={255,127,0}));
  connect(extStaCap.y, greThr[1].u) annotation (Line(points={{-19,210},{60,210},
          {60,270},{138,270}}, color={0,0,127}));
  connect(extStaLowCap.y, greThr[2].u) annotation (Line(points={{21,140},{80,140},
          {80,270},{138,270}}, color={0,0,127}));
  connect(greThr.y, mulOr.u[1:2]) annotation (Line(points={{161,270},{170,270},{
          170,266.5},{178,266.5}}, color={255,0,255}));
  connect(booToInt1.y, mulSumInt1.u) annotation (Line(points={{-79,-40},{-70,
          -40},{-70,-40},{-62,-40}},           color={255,127,0}));
  connect(uMinCap, extStaUpCapMin.u) annotation (Line(points={{-282,-252},{-110,
          -252},{-110,-78},{20,-78},{20,-30},{98,-30}}, color={0,0,127}));
  connect(uMinCap, extStaCapMin.u) annotation (Line(points={{-282,-252},{-138,
          -252},{-138,-274},{34,-274},{34,-84},{98,-84},{98,-90}}, color={0,0,
          127}));
  connect(uNomCap, extStaCap.u) annotation (Line(points={{-280,260},{-160,260},
          {-160,210},{-42,210}}, color={0,0,127}));
  connect(uNomCap, extStaLowCap.u) annotation (Line(points={{-280,260},{-230,
          260},{-230,182},{-44,182},{-44,140},{-2,140}}, color={0,0,127}));
  connect(uNomCap, extStaUpCap.u) annotation (Line(points={{-280,260},{70,260},
          {70,140},{98,140}},          color={0,0,127}));
  annotation (defaultComponentName = "staCap",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-80,-30},{-20,-42}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-48},{-20,-60}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-42},{-72,-48}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-42},{-24,-48}}, lineColor={0,0,127}),
        Rectangle(extent={{0,-10},{80,-30}}, lineColor={0,0,127}),
        Rectangle(extent={{0,-40},{80,-60}}, lineColor={0,0,127}),
        Rectangle(extent={{6,-30},{12,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{68,-30},{74,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,10},{-20,-2}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-8},{-20,-20}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-2},{-72,-8}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-2},{-24,-8}}, lineColor={0,0,127})}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-300},{260,300}})),
Documentation(info="<html>
<p>
Based on the current chiller stage and nominal stage capacities returns the
nominal capacity of the current and one lower stage for the purpose of
calculating the operative part load ratio (OPLR).
</p>
</html>",
revisions="<html>
<ul>
<li>
January 13, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacities;

within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block ChangeDeprecated
  "Will turn into a generic change sequence that takes all PLRs from PartLoadRatios"

  // fixme: pull OPRLup and OPRLdown out into chiller type staging packages
  parameter Integer numSta = 2
  "Number of stages";

  parameter Real staUpPlr(min = 0, max = 1, unit="1") = 0.8
  "Maximum operating part load ratio of the current stage before staging up";

  parameter Real staDowPlr(min = 0, max = 1, unit="1") = 0.8
  "Minimum operating part load ratio of the next lower stage before staging down";

  parameter Modelica.SIunits.TemperatureDifference TChiWatSetOffset = 2
  "Chilled water supply temperature difference above the setpoint";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
  "Minimum chiller load time below or above current stage before a change is enabled";

  parameter Real chiWatPumSpeThr = 0.99
  "Chilled water pump speed limit used in staging up";

  parameter Real dpStaPreSet = 0.9
  "Chilled water pump differential static pressure setpoint gain used in staging up";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),
        iconTransformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapNomSta(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapNomLowSta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(
      extent={{-220,-150},{-180,-110}}), iconTransformation(extent={{-120,40},
      {-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
    iconTransformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPumSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiWatPumSpe(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-220,
    -280},{-180,-240}}), iconTransformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatPum(
    final unit="Pa",
    final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(
    transformation(extent={{-220,-250},{-180,-210}}), iconTransformation(
     extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final max=1,
    final min=-1) "Chiller stage change (1 - up, -1 - down, 0 - unchanged)"
    annotation (Placement(transformation(extent=
    {{180,-10},{200,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrLowSta
    "Calculates operating part load ratio at the first lower stage"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiDown
    "Checks if the stage down should occur"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiUp
    "Checks if the stage up should occur"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Equality check"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Equality check"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=1)
    "Stage 1"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stageMax(k=numSta)
    "Highest stage"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEquStaUpCap
    "Checks if staging up is needed due to the capacity requirement"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEquStaDowCap
    "Checks if staging down is needed due to the capacity requirement"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{110,0},{130,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{110,-40},{130,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(
    final k2=-1)
    "Adder"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staUpOpePlr(final k=staUpPlr)
    "Maximum operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staDowOpePlr(final k=staDowPlr)
    "Minimum operating part load ratio of the first lower stage"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant firstAndLast(final k=1)
    "Operating part load ratio limit for lower and upper extremes"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  CDL.Logical.Or  andStaDow "And for staging down"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  CDL.Logical.Or3  andStaUp
                           "And for staging up"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
  CDL.Continuous.Less                                les
    annotation (Placement(transformation(extent={{10,-140},{30,-120}})));
  CDL.Continuous.AddParameter addTOffset(p=TChiWatSetOffset, k=1)
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));

  CDL.Continuous.GreaterThreshold greThr(threshold=chiWatPumSpeThr)
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
  CDL.Continuous.Less lesEqu
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  CDL.Continuous.Gain gai(k=dpStaPreSet)
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  CDL.Logical.TrueDelay truDel3(delayTime=delayStaCha)
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));
  CDL.Logical.And andStaUp1
                           "And for staging up"
    annotation (Placement(transformation(extent={{-40,-240},{-20,-220}})));
equation
  connect(uChiSta, intEqu.u1) annotation (Line(points={{-200,140},{-170,140},{-170,
          -10},{-122,-10}},     color={255,127,0}));
  connect(intEqu.u2, stage1.y) annotation (Line(points={{-122,-18},{-130,-18},{-130,
          -50},{-139,-50}},  color={255,127,0}));
  connect(uChiSta, intEqu1.u1) annotation (Line(points={{-200,140},{-170,140},{-170,
          170},{-122,170}},                     color={255,127,0}));
  connect(stageMax.y, intEqu1.u2) annotation (Line(points={{-139,130},{-130,130},
          {-130,162},{-122,162}},
                            color={255,127,0}));
  connect(intEqu.y, swiDown.u2) annotation (Line(points={{-99,-10},{-60,-10},{-60,
          -30},{-42,-30}},color={255,0,255}));
  connect(swiDown.u1, firstAndLast.y) annotation (Line(points={{-42,-22},{-50,-22},
          {-50,70},{-59,70}},
                          color={0,0,127}));
  connect(swiDown.u3, staDowOpePlr.y) annotation (Line(points={{-42,-38},{-60,-38},
          {-60,-50},{-99,-50}}, color={0,0,127}));
  connect(intEqu1.y, swiUp.u2) annotation (Line(points={{-99,170},{-80,170},{-80,
          150},{-42,150}},
                        color={255,0,255}));
  connect(swiUp.u3, staUpOpePlr.y) annotation (Line(points={{-42,142},{-80,142},
          {-80,130},{-99,130}},
                             color={0,0,127}));
  connect(firstAndLast.y, swiUp.u1) annotation (Line(points={{-59,70},{-50,70},{
          -50,158},{-42,158}},            color={0,0,127}));
  connect(swiDown.y,lesEquStaDowCap. u2) annotation (Line(points={{-19,-30},{0,-30},
          {0,22},{8,22}},   color={0,0,127}));
  connect(opePlrLowSta.y,lesEquStaDowCap. u1)
    annotation (Line(points={{-59,30},{8,30}},  color={0,0,127}));
  connect(swiUp.y, greEquStaUpCap.u2) annotation (Line(points={{-19,150},{0,150},
          {0,92},{8,92}},   color={0,0,127}));
  connect(opePlrSta.y, greEquStaUpCap.u1)
    annotation (Line(points={{-59,100},{8,100}},  color={0,0,127}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{131,10},{134,10},{134,
          6},{148,6}},     color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{131,-30},{134,-30},{
          134,-6},{148,-6}},  color={255,127,0}));
  connect(uCapReq, opePlrLowSta.u1) annotation (Line(points={{-200,30},{-160,30},
          {-160,36},{-82,36}},   color={0,0,127}));
  connect(uCapNomLowSta, opePlrLowSta.u2) annotation (Line(points={{-200,60},{-140,
          60},{-140,24},{-82,24}},   color={0,0,127}));
  connect(uCapNomSta, opePlrSta.u2) annotation (Line(points={{-200,90},{-120,90},
          {-120,94},{-82,94}},color={0,0,127}));
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-200,30},{-160,30},{-160,
          106},{-82,106}},     color={0,0,127}));
  connect(addInt.y, y)
    annotation (Line(points={{171,0},{190,0}}, color={255,127,0}));
  connect(TChiWatSupSet, addTOffset.u) annotation (Line(points={{-200,-100},{-60,
          -100},{-60,-110},{-42,-110}}, color={0,0,127}));
  connect(TChiWatSup, gre.u1) annotation (Line(points={{-200,-130},{-140,-130},{
          -140,-80},{-60,-80},{-60,-90},{8,-90}}, color={0,0,127}));
  connect(addTOffset.y, gre.u2) annotation (Line(points={{-19,-110},{0,-110},{0,
          -98},{8,-98}}, color={0,0,127}));
  connect(booToInt.u, andStaUp.y)
    annotation (Line(points={{108,10},{101,10}}, color={255,0,255}));
  connect(TChiWatRet, les.u1) annotation (Line(points={{-200,-160},{-40,-160},{-40,
          -130},{8,-130}},      color={0,0,127}));
  connect(TChiWatSupSet, les.u2) annotation (Line(points={{-200,-100},{-80,-100},
          {-80,-138},{8,-138}},         color={0,0,127}));
  connect(les.y, andStaDow.u2) annotation (Line(points={{31,-130},{70,-130},{70,
          -38},{78,-38}}, color={255,0,255}));
  connect(booToInt1.u, andStaDow.y)
    annotation (Line(points={{108,-30},{101,-30}}, color={255,0,255}));
  connect(chiWatPumSpe, greThr.u)
    annotation (Line(points={{-200,-260},{-142,-260}}, color={0,0,127}));
  connect(greThr.y, truDel3.u)
    annotation (Line(points={{-119,-260},{-102,-260}}, color={255,0,255}));
  connect(truDel3.y, andStaUp1.u2) annotation (Line(points={{-79,-260},{-60,-260},
          {-60,-238},{-42,-238}}, color={255,0,255}));
  connect(dpChiWatPum, lesEqu.u1) annotation (Line(points={{-200,-230},{-150,-230},
          {-150,-210},{-102,-210}}, color={0,0,127}));
  connect(dpChiWatPumSet, gai.u) annotation (Line(points={{-200,-200},{-160,-200},
          {-160,-190},{-142,-190}}, color={0,0,127}));
  connect(lesEqu.u2, gai.y) annotation (Line(points={{-102,-218},{-110,-218},{-110,
          -190},{-119,-190}}, color={0,0,127}));
  connect(lesEqu.y, andStaUp1.u1) annotation (Line(points={{-79,-210},{-60,-210},
          {-60,-230},{-42,-230}}, color={255,0,255}));
  connect(andStaUp1.y, andStaUp.u3) annotation (Line(points={{-19,-230},{74,-230},
          {74,2},{78,2}}, color={255,0,255}));
  connect(greEquStaUpCap.y, andStaUp.u1) annotation (Line(points={{31,100},{54,
          100},{54,18},{78,18}}, color={255,0,255}));
  connect(gre.y, andStaUp.u2) annotation (Line(points={{31,-90},{54,-90},{54,10},
          {78,10}}, color={255,0,255}));
  connect(lesEquStaDowCap.y, andStaDow.u1) annotation (Line(points={{31,30},{40,
          30},{40,-30},{78,-30}}, color={255,0,255}));
  annotation (defaultComponentName = "staChaPosDis",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-280},{180,200}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChangeDeprecated;

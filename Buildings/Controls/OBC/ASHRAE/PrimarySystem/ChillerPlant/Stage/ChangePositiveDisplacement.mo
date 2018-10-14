within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block ChangePositiveDisplacement
  "Stage change conditions for positive displacement chillers"

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real staUpPlr(min = 0, max = 1, unit="1") = 0.8
  "Maximum operating part load ratio of the current stage before staging up";

  parameter Real staDowPlr(min = 0, max = 1, unit="1") = 0.8
  "Minimum operating part load ratio of the next lower stage before staging down";

  CDL.Interfaces.IntegerInput uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
        iconTransformation(extent={{-120,70},{-100,90}})));

  CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
    iconTransformation(extent={{-120,-60},{-100,-40}})));

  CDL.Interfaces.RealInput uCapNomSta(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  CDL.Interfaces.RealInput uCapNomLowSta(
    final unit="W",
    final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));

  CDL.Interfaces.IntegerOutput yChiStaCha(
    final max=1,
    final min=-1)
    "Chiller stage change"
    annotation (Placement(transformation(extent={{180,-10},
            {200,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Continuous.Division opePlrSta
    "Operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  CDL.Continuous.Division opePlrLowSta
    "Operating part load ratio at the first lower stage"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  CDL.Logical.Switch swiDown
    "Checks if the stage should go down"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  CDL.Logical.Switch swiUp "Checks if the stage should go up"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  CDL.Integers.Sources.Constant stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  CDL.Integers.Sources.Constant stageMax(k=numSta) "Last stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  CDL.Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  CDL.Integers.Add addInt(k2=-1)
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  CDL.Continuous.Sources.Constant staUpOpePlr(final k=staUpPlr)
    "Maximum operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  CDL.Continuous.Sources.Constant staDowOpePlr(final k=staDowPlr)
    "Minimum operating part load ratio of the first lower stage"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  CDL.Continuous.Sources.Constant firstAndLast(final k=1)
    "Operating part load ratio limit for lower and upper extremes"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(uChiSta, intEqu.u1) annotation (Line(points={{-160,100},{-130,100},{-130,
          -70},{-82,-70}},      color={255,127,0}));
  connect(intEqu.u2, stage1.y) annotation (Line(points={{-82,-78},{-90,-78},{-90,
          -110},{-99,-110}}, color={255,127,0}));
  connect(uChiSta, intEqu1.u1) annotation (Line(points={{-160,100},{-130,100},{-130,
          110},{-82,110}},                      color={255,127,0}));
  connect(stageMax.y, intEqu1.u2) annotation (Line(points={{-99,70},{-90,70},{-90,
          102},{-82,102}},  color={255,127,0}));
  connect(intEqu.y, swiDown.u2) annotation (Line(points={{-59,-70},{-20,-70},{-20,
          -90},{-2,-90}}, color={255,0,255}));
  connect(swiDown.u1, firstAndLast.y) annotation (Line(points={{-2,-82},{-10,-82},
          {-10,0},{-19,0}},
                          color={0,0,127}));
  connect(swiDown.u3, staDowOpePlr.y) annotation (Line(points={{-2,-98},{-20,-98},
          {-20,-110},{-59,-110}},
                                color={0,0,127}));
  connect(intEqu1.y, swiUp.u2) annotation (Line(points={{-59,110},{-40,110},{-40,
          90},{-2,90}}, color={255,0,255}));
  connect(swiUp.u3, staUpOpePlr.y) annotation (Line(points={{-2,82},{-40,82},{-40,
          70},{-59,70}},     color={0,0,127}));
  connect(firstAndLast.y, swiUp.u1) annotation (Line(points={{-19,0},{-10,0},{-10,
          98},{-2,98}},                   color={0,0,127}));
  connect(swiDown.y, lesEqu.u2) annotation (Line(points={{21,-90},{30,-90},{30,-38},
          {38,-38}},      color={0,0,127}));
  connect(opePlrLowSta.y, lesEqu.u1) annotation (Line(points={{-19,-50},{20,-50},
          {20,-30},{38,-30}}, color={0,0,127}));
  connect(swiUp.y, greEqu.u2) annotation (Line(points={{21,90},{30,90},{30,32},{
          38,32}},  color={0,0,127}));
  connect(opePlrSta.y, greEqu.u1)
    annotation (Line(points={{-19,40},{38,40}},
                                              color={0,0,127}));
  connect(lesEqu.y, booToInt1.u) annotation (Line(points={{61,-30},{78,-30}},
                               color={255,0,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{101,40},{124,40},{124,
          6},{138,6}},     color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{101,-30},{124,-30},{
          124,-6},{138,-6}},  color={255,127,0}));
  connect(uCapReq, opePlrLowSta.u1) annotation (Line(points={{-160,-90},{-100,-90},
          {-100,-44},{-42,-44}}, color={0,0,127}));
  connect(uCapNomLowSta, opePlrLowSta.u2) annotation (Line(points={{-160,-20},{-50,
          -20},{-50,-56},{-42,-56}}, color={0,0,127}));
  connect(uCapNomSta, opePlrSta.u2) annotation (Line(points={{-160,20},{-50,20},
          {-50,34},{-42,34}}, color={0,0,127}));
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-160,-90},{-100,-90},
          {-100,46},{-42,46}}, color={0,0,127}));
  connect(addInt.y, yChiStaCha)
    annotation (Line(points={{161,0},{190,0}}, color={255,127,0}));
  connect(greEqu.y, booToInt.u)
    annotation (Line(points={{61,40},{78,40}}, color={255,0,255}));
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
        extent={{-140,-140},{180,140}})),
Documentation(info="<html>
<p>
Fixme
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
end ChangePositiveDisplacement;

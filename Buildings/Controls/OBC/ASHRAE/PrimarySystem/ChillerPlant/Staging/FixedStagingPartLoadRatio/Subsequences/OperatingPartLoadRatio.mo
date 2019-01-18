within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.FixedStagingPartLoadRatio.Subsequences;
block OperatingPartLoadRatio
  "Stage operating part load ratio (current, up, down and minimum)"

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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaCap(final unit="W",
      final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaLowCap(final unit="W",
      final quantity="Power") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrLowSta
    "Calculates operating part load ratio at the first lower stage"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiDown
    "Checks if the stage down should occur"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swiUp
    "Checks if the stage up should occur"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Equality check"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Equality check"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stageMax(k=numSta)
    "Highest stage"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEquStaUpCap
    "Checks if staging up is needed due to the capacity requirement"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEquStaDowCap
    "Checks if staging down is needed due to the capacity requirement"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staUpOpePlr(final k=staUpPlr)
    "Maximum operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant firstAndLast(final k=1)
    "Operating part load ratio limit for lower and upper extremes"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  CDL.Interfaces.IntegerInput                        uChiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
equation
  connect(stageMax.y, intEqu1.u2) annotation (Line(points={{-139,90},{-130,90},
          {-130,122},{-122,122}},
                            color={255,127,0}));
  connect(intEqu.y, swiDown.u2) annotation (Line(points={{-99,-50},{-60,-50},{
          -60,-70},{-42,-70}},
                          color={255,0,255}));
  connect(swiDown.u1, firstAndLast.y) annotation (Line(points={{-42,-62},{-50,
          -62},{-50,30},{-59,30}},
                          color={0,0,127}));
  connect(intEqu1.y, swiUp.u2) annotation (Line(points={{-99,130},{-80,130},{
          -80,110},{-42,110}},
                        color={255,0,255}));
  connect(swiUp.u3, staUpOpePlr.y) annotation (Line(points={{-42,102},{-80,102},
          {-80,90},{-99,90}},color={0,0,127}));
  connect(firstAndLast.y, swiUp.u1) annotation (Line(points={{-59,30},{-50,30},
          {-50,118},{-42,118}},           color={0,0,127}));
  connect(swiDown.y,lesEquStaDowCap. u2) annotation (Line(points={{-19,-70},{0,
          -70},{0,-18},{8,-18}},
                            color={0,0,127}));
  connect(opePlrLowSta.y,lesEquStaDowCap. u1)
    annotation (Line(points={{-59,-10},{8,-10}},color={0,0,127}));
  connect(swiUp.y, greEquStaUpCap.u2) annotation (Line(points={{-19,110},{0,110},
          {0,52},{8,52}},   color={0,0,127}));
  connect(opePlrSta.y, greEquStaUpCap.u1)
    annotation (Line(points={{-59,60},{8,60}},    color={0,0,127}));
  connect(uCapReq, opePlrLowSta.u1) annotation (Line(points={{-200,-60},{-160,
          -60},{-160,-4},{-82,-4}},
                                 color={0,0,127}));
  connect(uStaLowCap, opePlrLowSta.u2) annotation (Line(points={{-200,20},{-140,
          20},{-140,-16},{-82,-16}}, color={0,0,127}));
  connect(uStaCap, opePlrSta.u2) annotation (Line(points={{-200,60},{-100,60},{
          -100,54},{-82,54}}, color={0,0,127}));
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-200,-60},{-160,-60},
          {-160,66},{-82,66}}, color={0,0,127}));
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
end OperatingPartLoadRatio;

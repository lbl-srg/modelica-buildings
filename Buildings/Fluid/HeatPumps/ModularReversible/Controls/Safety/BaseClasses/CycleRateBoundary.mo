within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
block CycleRateBoundary "Checks if the cycle rate is in boundary"
  extends Modelica.Blocks.Interfaces.BooleanSISO;
  parameter Integer maxCycRat "Maximal cycle rate";
  parameter Modelica.Units.SI.Time delTim(displayUnit="h") = 3600
    "Delay time of output with respect to input signal";
  Modelica.Blocks.Logical.LessThreshold runCouLesMax(threshold=maxCycRat)
    "Checks if the count of total runs is lower than the maximal value"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.MathInteger.TriggeredAdd triAdd "Count number of starts"
    annotation (Placement(transformation(extent={{-50,-10},{-30,-30}})));
  Modelica.Blocks.Sources.IntegerConstant intConPluOne(final k=1)
    "Value for counting"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Modelica.Blocks.Math.IntegerToReal intToRea
    "Convert to real in order to compare and delay"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Blocks.Math.Add sub(k2=-1)
    "Difference of current and delayed starts"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixDel(final delayTime=delTim)
    "Apply delay to enable starts per delay time"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(intConPluOne.y, triAdd.u) annotation (Line(points={{-69,-20},{-54,-20}},
                            color={255,127,0}));
  connect(intToRea.u, triAdd.y)
    annotation (Line(points={{-22,-20},{-28,-20}},
                                               color={255,127,0}));
  connect(intToRea.y, sub.u1)
    annotation (Line(points={{1,-20},{12,-20},{12,6},{38,6}},
                                                          color={0,0,127}));
  connect(intToRea.y, fixDel.u)
    annotation (Line(points={{1,-20},{12,-20},{12,-40},{18,-40}},
                                                           color={0,0,127}));
  connect(fixDel.y, sub.u2)
    annotation (Line(points={{41,-40},{50,-40},{50,-20},{28,-20},{28,-6},{38,-6}},
                                                        color={0,0,127}));
  connect(runCouLesMax.y, y)
    annotation (Line(points={{91,0},{110,0}},           color={255,0,255}));
  connect(u, triAdd.trigger) annotation (Line(points={{-120,0},{-46,0},{-46,-8}},
                              color={255,0,255}));
  connect(sub.y, runCouLesMax.u) annotation (Line(points={{61,0},{68,0}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
        Line(points={{0,80},{0,60}}, color={160,160,164}),
        Line(points={{80,0},{60,0}}, color={160,160,164}),
        Line(points={{0,-80},{0,-60}}, color={160,160,164}),
        Line(points={{-80,0},{-60,0}}, color={160,160,164}),
        Line(points={{37,70},{26,50}}, color={160,160,164}),
        Line(points={{70,38},{49,26}}, color={160,160,164}),
        Line(points={{71,-37},{52,-27}}, color={160,160,164}),
        Line(points={{39,-70},{29,-51}}, color={160,160,164}),
        Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
        Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
        Line(points={{-71,37},{-54,28}}, color={160,160,164}),
        Line(points={{-38,70},{-28,51}}, color={160,160,164}),
        Line(
          points={{0,0},{-50,50}},
          thickness=0.5),
        Line(
          points={{0,0},{40,0}},
          thickness=0.5)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  The block counts the number of times the device is turned on
  in a given time interval by tracking the rising edge of the boolean
  input signal. If this number is higher than a set value, the block
  indicates an error.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Renaming according to Buildings guideline (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end CycleRateBoundary;

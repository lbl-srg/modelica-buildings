within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36_new.AtomicSequences;
model EconEnableDisable "Economizer enable/disable switch"

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-140,134},{-100,174}}),
        iconTransformation(extent={{-140,134},{-100,174}})));
  CDL.Interfaces.BooleanInput uFre(start=false) "Freezestat status"
    annotation (Placement(transformation(extent={{-140,38},{-100,78}}),
        iconTransformation(extent={{-140,38},{-100,78}})));
  CDL.Interfaces.RealInput TSup(unit="K", displayUnit="degC")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,84},{-100,124}}),
        iconTransformation(extent={{-140,84},{-100,124}})));
  CDL.Interfaces.RealOutput yEcoDamPosMax(min=0, max=1)
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yEcoDamPosMin and enable = yEcoDamPosMax."
    annotation (Placement(transformation(extent={{100,44},{138,82}}),
        iconTransformation(extent={{100,44},{138,82}})));
  CDL.Interfaces.RealInput uEcoDamPosMin
    "Minimal economizer damper position, output from a separate sequence."
    annotation (Placement(transformation(extent={{-140,-6},{-100,34}}),
        iconTransformation(extent={{-140,-6},{-100,34}})));
  CDL.Interfaces.RealInput uEcoDamPosMax
    "Maximum economizer damper position, either 100% or set to a constant value <100% at commisioning."
    annotation (Placement(transformation(extent={{-140,-54},{-100,-14}}),
        iconTransformation(extent={{-140,-54},{-100,-14}})));
  CDL.Logical.Switch assignDamperPosition
    "If control loop signal = 1 opens the damper to it's max position; if signal = 0 closes the damper to it's min position."
    annotation (Placement(transformation(extent={{76,-70},{96,-50}})));
  CDL.Logical.Or or1
    "If any of the conditions evaluated is 1, the block returns 1 and it's inverse in the following block closes the damper to uEcoDamPosMin. If all conditions are 0, the damper can be opened up to uEcoDamPosMax"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
  CDL.Logical.Hysteresis hysTOut(final uLow = 297 - 1, uHigh = 297)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow"
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Logical.Or or2
    "fixme: should we have an or block that allows multiple inputs?"
    annotation (Placement(transformation(extent={{10,8},{30,28}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  CDL.Logical.LessThreshold TSupThreshold(threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated"
    annotation (Placement(transformation(extent={{-78,88},{-58,108}})));
equation
  connect(assignDamperPosition.u1, uEcoDamPosMin) annotation (Line(points={{74,-52},
          {-18,-52},{-18,14},{-120,14}},           color={0,0,127}));
  connect(assignDamperPosition.u3, uEcoDamPosMax) annotation (Line(points={{74,-68},
          {22,-68},{22,-66},{-30,-66},{-30,-34},{-120,-34}},
                                                   color={0,0,127}));
  connect(assignDamperPosition.y, yEcoDamPosMax) annotation (Line(points={{97,
          -60},{104,-60},{104,63},{119,63}}, color={0,0,127}));
  connect(or1.u2, uFre) annotation (Line(points={{8,-18},{-10,-18},{-10,58},{-120,
          58}},color={255,0,255}));
  connect(TOut, hysTOut.u)
    annotation (Line(points={{-120,154},{-96,154},{-96,160},{-72,160}},
                                                    color={0,0,127}));
  connect(or1.y, not1.u)
    annotation (Line(points={{31,-10},{38,-10}}, color={255,0,255}));
  connect(not1.y, assignDamperPosition.u2) annotation (Line(points={{61,-10},{68,
          -10},{68,-60},{74,-60}}, color={255,0,255}));
  connect(or2.y, or1.u1) annotation (Line(points={{31,18},{42,18},{42,34},{-6,
          34},{-6,4},{2,4},{2,-10},{8,-10}},
                 color={255,0,255}));
  connect(TSupThreshold.y, or2.u2) annotation (Line(points={{-57,98},{-26,98},
          {-26,10},{8,10}}, color={255,0,255}));
  connect(TSup, TSupThreshold.u) annotation (Line(points={{-120,104},{-100,
          104},{-100,98},{-80,98}}, color={0,0,127}));
  connect(hysTOut.y, or2.u1) annotation (Line(points={{-49,160},{-22,160},{-22,18},
          {8,18}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,200}},
        initialScale=0.1),                                      graphics={
        Rectangle(
        extent={{-100,-38},{100,162}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                          Line(
          points={{2,116},{82,116}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-94,32},{-24,-4}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uEcoDamPosMin"),
        Text(
          extent={{-96,-12},{-26,-48}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uEcoDamPosMax"),
        Text(
          extent={{26,114},{96,78}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yEcoDamPos"),
        Text(
          extent={{-96,166},{-26,130}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-96,124},{-26,88}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          extent={{-96,78},{-26,42}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFre"),
          Line(
          points={{-78,-4},{2,-4},{2,116}},
          color={28,108,200},
          thickness=0.5)}), Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,200}},
        initialScale=0.1)),
             Documentation(info="<html>      
             <p>
             implementation fixme: timers for TSup, AND for 10 min delay
             </p>   
  <p>
  Fixme: There might be a need to convert this block in a generic enable-disable
  control block that receives one or more hysteresis conditions, one or more 
  timed conditions, and one or more additional boolean signal conditions. For 
  now, the block is implemented as economizer enable-disable control block, an
  atomic sequence implemented in the economizer control composite sequence.
  </p>
  <p>
  The economizer enable-disable sequence implements conditions from 
  ASHRAE guidline 36 (G36) as listed on the state machine diagram below. The 
  sequence output is binary, it either sets the economizer damper position to
  its high (yEcoDamPosMax) or to its low limit (yEcoDamPosMin).
  </p>

<p>
Fixme: Edit conditions based on any additional stakeholder input, e.g. include
space averaged MAT sensor output.
</p>
<p>
Fixme - Implementation issues: Delay placement; Excluding hysteresis by simply 
setting the delta parameter to 0. Delay seems to replace hysteresis in practice, 
at least based on our current project partners input.
</p>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconHighLimitLockout.png\"/>
</p>
</html>"));
end EconEnableDisable;

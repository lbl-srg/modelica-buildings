within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconEnableDisable "Economizer enable/disable switch"

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-140,134},{-100,174}}),
        iconTransformation(extent={{-140,134},{-100,174}})));
  CDL.Interfaces.BooleanInput uFre(start=false) "Freezestat status"
    annotation (Placement(transformation(extent={{-140,36},{-100,76}}),
        iconTransformation(extent={{-140,36},{-100,76}})));
  CDL.Interfaces.RealInput TSup(unit="K", displayUnit="degC")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,84},{-100,124}}),
        iconTransformation(extent={{-140,84},{-100,124}})));
  CDL.Interfaces.RealOutput yEcoDamPosMax(min=0, max=1)
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yEcoDamPosMin and enable = yEcoDamPosMax."
    annotation (Placement(transformation(extent={{100,42},{138,80}}),
        iconTransformation(extent={{100,42},{138,80}})));
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
    annotation (Placement(transformation(extent={{66,-74},{86,-54}})));
  CDL.Logical.Or or1
    "If any of the conditions evaluated is 1, the block returns 1 and it's inverse in the following block closes the damper to uEcoDamPosMin. If all conditions are 0, the damper can be opened up to uEcoDamPosMax"
    annotation (Placement(transformation(extent={{30,54},{50,74}})));
  CDL.Logical.Hysteresis hysTOut(                      uHigh = 297, final uLow=
        297 - 1)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow"
    annotation (Placement(transformation(extent={{-70,144},{-50,164}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Logical.Or or2
    "fixme: should we have an or block that allows multiple inputs?"
    annotation (Placement(transformation(extent={{30,82},{50,102}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{60,54},{80,74}})));
  CDL.Logical.LessThreshold TSupThreshold(threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated"
    annotation (Placement(transformation(extent={{-90,94},{-70,114}})));
  CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{-62,104},{-42,124}})));
  CDL.Logical.Greater greater
    annotation (Placement(transformation(extent={{-32,94},{-12,114}})));
  CDL.Continuous.Constant TSupTimeLimit(k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-62,78},{-42,98}})));
equation
  connect(assignDamperPosition.u1, uEcoDamPosMin) annotation (Line(points={{64,-56},
          {-18,-56},{-18,14},{-120,14}},           color={0,0,127}));
  connect(TOut, hysTOut.u)
    annotation (Line(points={{-120,154},{-96,154},{-72,154}},
                                                    color={0,0,127}));
  connect(or1.y, not1.u)
    annotation (Line(points={{51,64},{58,64}},   color={255,0,255}));
  connect(or2.y, or1.u1) annotation (Line(points={{51,92},{62,92},{62,108},{14,
          108},{14,78},{14,78},{14,64},{28,64}},
                 color={255,0,255}));
  connect(TSup, TSupThreshold.u)
    annotation (Line(points={{-120,104},{-92,104}}, color={0,0,127}));
  connect(hysTOut.y, or2.u1) annotation (Line(points={{-49,154},{-2,154},{-2,92},
          {28,92}},color={255,0,255}));
  connect(TSupThreshold.y, timer1.u) annotation (Line(points={{-69,104},{-66,104},
          {-66,114},{-64,114}}, color={255,0,255}));
  connect(TSupTimeLimit.y, greater.u2) annotation (Line(points={{-41,88},{-38,88},
          {-38,96},{-34,96}}, color={0,0,127}));
  connect(timer1.y, greater.u1) annotation (Line(points={{-41,114},{-38,114},{-38,
          104},{-34,104}}, color={0,0,127}));
  connect(greater.y, or2.u2) annotation (Line(points={{-11,104},{-11,104},{-4,
          104},{-4,84},{14,84},{28,84}},
                                    color={255,0,255}));
  connect(uFre, or1.u2)
    annotation (Line(points={{-120,56},{-46,56},{28,56}}, color={255,0,255}));
  connect(assignDamperPosition.y, yEcoDamPosMax) annotation (Line(points={{87,-64},
          {94,-64},{94,61},{119,61}}, color={0,0,127}));
  connect(uEcoDamPosMax, assignDamperPosition.u3) annotation (Line(points={{-120,
          -34},{-28,-34},{-28,-72},{64,-72}}, color={0,0,127}));
  connect(not1.y, assignDamperPosition.u2) annotation (Line(points={{81,64},{86,
          64},{86,-4},{52,-4},{52,-64},{64,-64}}, color={255,0,255}));
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
          extent={{106,118},{176,82}},
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
             implementation fixme: 10 min delay
             - pg. 119 - Ret damper position when disabled: before releasing 
             the return air damper to be controled by the minimum air req 
             (EconDamPosLimits): open fully, wait 15 sec MaxOA-P = MinOA-P,
             wait 3 min after that and release ret dam for EconDamPosLimits
             control.
             </p>   
             <p>
             This sequence enables or disables the economizer based on 
             conditions provided in G36 PART5.N.7.           
  Fixme: There might be a need to convert this block in a generic enable-disable
  control block that receives one or more hysteresis conditions, one or more 
  timed conditions, and one or more additional boolean signal conditions. For 
  now, the block is implemented as economizer enable-disable control block, an
  atomic sequence which is a part in the economizer control composite sequence.
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
Fixme - feature related issues: Delay placement - 10 min delay right before
this block's output should cover this condition, since listed in G36; 
test excluding hysteresis by simply setting the delta parameter to 0. 
Notes: Delay seems to replace hysteresis in practice, 
at least based on our current project partners input.
</p>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconHighLimitLockout.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisable;

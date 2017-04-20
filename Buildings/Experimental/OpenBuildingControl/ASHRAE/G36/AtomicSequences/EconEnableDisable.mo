within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconEnableDisable "Economizer enable/disable switch"

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-140,
            120},{-100,160}}), iconTransformation(extent={{-140,120},{-100,160}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1)
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{100,42},{138,80}}),
        iconTransformation(extent={{100,42},{138,80}})));
  CDL.Interfaces.RealInput uOutDamPosMin
    "Minimal economizer damper position, output from a separate sequence."
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput uOutDamPosMax
    "Maximum economizer damper position, either 100% or set to a constant value <100% at commisioning."
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Logical.Switch assignDamperPosition
    "If control loop signal = 1 opens the damper to it's max position; if signal = 0 closes the damper to it's min position."
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Logical.Or or1
    "If any of the conditions evaluated is 1, the block returns 1 and it's inverse in the following block closes the damper to uOutDamPosMin. If all conditions are 0, the damper can be opened up to uOutDamPosMax"
    annotation (Placement(transformation(extent={{60,74},{80,94}})));
  CDL.Logical.Hysteresis hysTOut(uHigh=297, final uLow=297 - 1)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Logical.Or or2
    "fixme: should we have an or block that allows multiple inputs?"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Interfaces.StatusTypeInput uFreezeProtectionStatus
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Logical.EqualStatus equ
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
equation
  connect(TOut, hysTOut.u) annotation (Line(points={{-120,140},{-114,140},{-88,
          140},{-62,140}},
                 color={0,0,127}));
  connect(or2.y, or1.u1) annotation (Line(points={{81,110},{90,110},{90,130},{
          50,130},{50,84},{58,84}},              color={255,0,255}));
  connect(hysTOut.y, or2.u1) annotation (Line(points={{-39,140},{30,140},{30,
          110},{58,110}},
                   color={255,0,255}));
  connect(assignDamperPosition.y, yOutDamPosMax) annotation (Line(points={{81,10},
          {88,10},{90,10},{90,60},{106,60},{106,61},{119,61}},
                                      color={0,0,127}));
  connect(uOutDamPosMax, assignDamperPosition.u3) annotation (Line(points={{-120,
          -30},{-30,-30},{-30,2},{58,2}},     color={0,0,127}));
  connect(or1.y, not1.u) annotation (Line(points={{81,84},{90,84},{90,68},{50,
          68},{50,50},{58,50}}, color={255,0,255}));
  connect(not1.y, assignDamperPosition.u2) annotation (Line(points={{81,50},{86,
          50},{86,36},{50,36},{50,10},{58,10}}, color={255,0,255}));
  connect(uOutDamPosMin, assignDamperPosition.u1) annotation (Line(points={{-120,0},
          {-40,0},{-40,18},{58,18}},           color={0,0,127}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-40},{100,160}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-100,-40},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{2,124},{82,124}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-94,40},{-24,4}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uOutDamPosMin"),
        Text(
          extent={{-94,0},{-24,-36}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uOutDamPosMax"),
        Text(
          extent={{106,114},{176,78}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Text(
          extent={{-92,114},{-54,88}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Line(
          points={{-78,4},{2,4},{2,124}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-94,76},{-56,50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uFre"),
        Text(
          extent={{-94,154},{-56,128}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-40},{100,160}},
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
  its high (yOutDamPosMax) or to its low limit (yOutDamPosMin).
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
<img alt=\"Image of economizer enable-disable state machine chart\"
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

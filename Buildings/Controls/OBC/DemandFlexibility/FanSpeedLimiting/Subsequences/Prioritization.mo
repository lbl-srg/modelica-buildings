within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences;
block Prioritization "Prioritization"

  parameter Integer nAHU(min=1)
    "Number of air handling units";
  parameter Real fanSiz[nAHU](each start=0)
    "Fan size; can be in any unit, but a larger value should represent a larger fan"
    annotation (Dialog(enable =priCri == Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Types.PrioritizationCriteria.FanSize));
  parameter
    Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Types.PrioritizationCriteria
    priCri "Fan limiting prioritization criteria";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpe[nAHU](each unit="1") if priCri ==
    Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Types.PrioritizationCriteria.CurrentFanSpeed
    "Fan speed of the air handling unit"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nAHU]
    "True: disqualify fans from fan limiting"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of air handling unit fans to select for prioritization"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectLargestValues selLarVal(final
      nVal=nAHU)
    "Select the largest value, either the fan speed or the fan size"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conFanSiz[nAHU](
    final k=fanSiz)
    if priCri == Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Types.PrioritizationCriteria.FanSize
    "Constant for fan size"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEna[nAHU]
    "True: enable fan limiting"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(disFla, selLarVal.disFla) annotation (Line(points={{-120,60},{-20,60},
          {-20,6},{-2,6}}, color={255,0,255}));
  connect(fanSpe, selLarVal.u)
    annotation (Line(points={{-120,0},{-2,0}}, color={0,0,127}));
  connect(conFanSiz.y, selLarVal.u) annotation (Line(points={{-58,30},{-40,30},{
          -40,0},{-2,0}}, color={0,0,127}));
  connect(nSel, selLarVal.nSel) annotation (Line(points={{-120,-60},{-20,-60},{-20,
          -6},{-2,-6}}, color={255,127,0}));
  connect(selLarVal.y, yEna)
    annotation (Line(points={{22,0},{120,0}}, color={255,0,255}));
  annotation (defaultComponentName="pri",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang and Liam Cochrane:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block selects the air handling units whose supply fans
are enabled for fan speed limiting during demand flexibility
operation. The selection is made among the <code>nAHU</code>
air handling units.
</p>
<p>
The prioritization criterion is set by the parameter
<code>priCri</code>:
</p>
<ul>
<li>
<code>FanSize</code>: air handling units with larger fans
are prioritized. The fan sizes are set by the parameter
<code>fanSiz</code>, which can be in any unit as long as a
larger value represents a larger fan.
</li>
<li>
<code>CurrentFanSpeed</code>: air handling units with higher
current fan speeds, given by the input <code>fanSpe</code>,
are prioritized. The input <code>fanSpe</code> is only
present when this criterion is used.
</li>
</ul>
<p>
Air handling units with <code>disFla[i] = true</code> are
disqualified and are not selected. Among the remaining units,
the <code>nSel</code> units with the largest values of the
chosen criterion are enabled for fan speed limiting, i.e.,
<code>yEna[i] = true</code>. For all other units,
<code>yEna[i] = false</code>.
</p>
<p>
The selection is performed by the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SelectLargestValues\">
Generic.SelectLargestValues</a>. Refer to that block for more
details on the selection logic.
</p>
</html>"));
end Prioritization;

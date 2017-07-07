within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconDamperPositionLimitsSingleZone
  "Single zone VAV AHU minimum outdoor air control - damper position limits"

  parameter Real minFanSpe(min=0, max=1, unit="1") = 0.1 "Minimum supply fan operation speed";
  parameter Real maxFanSpe(min=0, max=1, unit="1") = 0.9 "Maximum supply fan operation speed";
  parameter Real minPosMin(min=0, max=1, unit="1") = 0.4
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow";
  parameter Real desPosMin(min=0, max=1, unit="1") = 0.9
    "Outdoor air damper position, when fan operating at minimum speed to supply design outdoor air flow";
  parameter Real minPosMax(min=0, max=1, unit="1") = 0.2
    "Outdoor air damper position, when fan operating at maximum speed to supply minimum outdoor air flow";
  parameter Real desPosMax(min=0, max=1, unit="1") = 0.8
    "Outdoor air damper position, when fan operating at maximum speed to supply design outdoor air flow";
  parameter Modelica.SIunits.MassFlowRate minVOut_flowSet = 1.0
    "fixme: minimum outdoor airflow rate (Vbz_A/EzC). Should we use unit kg/s as the unit?";
  parameter Modelica.SIunits.MassFlowRate desVOut_flowSet = 2.0
    "fixme: design outdoor airflow rate (Vbz_A+Vbz_p)/EzH. Should we use unit kg/s as the unit?";

  CDL.Interfaces.RealInput uSupFanSpe(min=minFanSpe, max=maxFanSpe, unit="1") "Current supply fan speed"
    annotation (Placement(transformation(extent={{-220,36},{-180,76}}), iconTransformation(extent={{-220,40},{-180,80}})));
  CDL.Interfaces.RealInput uVOut_flowMinSet(min=minVOut_flowSet, max=desVOut_flowSet)
    "fixme: Minimum outdoor airflow requirement (setpoint, kg/s?), output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-220,118},{-180,158}}),
        iconTransformation(extent={{-220,120},{-180,160}})));
  //fixme add units, should be percentage

  CDL.Continuous.Constant minFanSpeSig(k=minFanSpe) "Minimum supply fan speed"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Interfaces.BooleanInput uAHUMod
    "AHU Mode, fixme: see pg. 103 in G36 for the full list of modes, here we use true = \"occupied\""
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}})));
  CDL.Interfaces.RealOutput yOutDamPosMin(unit="1")
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{180,10},{200,30}}),  iconTransformation(extent={{180,10},
            {200,30}})));
  CDL.Continuous.Constant outDamPhyPosMinSig(k=0)
    "If the minimum outdoor airflow setpoint becomes zero (when the zone is in other than occupied mode), the outdoor damper shall be zero."
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  CDL.Logical.Switch outDamPosMin
    "If zone is in other than occupied mode, uVOutMinSet shall be zero, so that the yOutDamPosMin shall be zero"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));

  CDL.Continuous.Constant maxFanSpeSig(k=maxFanSpe) "Maximum supply fan speed"
    annotation (Placement(transformation(extent={{-140,18},{-120,38}})));

  CDL.Continuous.Constant minPosAtMinSpe(k=minPosMin)
    "Outdoor air damper position, when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-140,64},{-120,84}})));
  CDL.Continuous.Constant desPosAtMinSpe(k=desPosMin)
    "Outdoor air damper position, when fan operating at minimum speed to supply design outdoor air flow"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Continuous.Constant minPosAtMaxSpe(k=minPosMax)
    "Outdoor air damper position, when fan operating at maximum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-140,102},{-120,122}})));
  CDL.Continuous.Constant desPosAtMaxSpe(k=desPosMax)
    "Outdoor air damper position, when fan operating at maximum speed to supply design outdoor air flow"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  CDL.Continuous.Constant minOA(k=minVOut_flowSet) "Minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  CDL.Continuous.Constant desOA(k=desVOut_flowSet) "Design outdoor airflow rate"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  CDL.Continuous.Line minPosAtCurSpe(limitBelow=true, limitAbove=true)
    "Outdoor air damper position, when fan operating at current speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  CDL.Continuous.Line desPosAtCurSpe(limitBelow=true, limitAbove=true)
    "Outdoor air damper position, when fan operating at current speed to supply design outdoor air flow"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  CDL.Continuous.Line minOutDamForOutMinSet(limitBelow=true, limitAbove=true)
    "Outdoor air damper position, when fan operating at current speed to supply setpoint outdoor air flow"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
equation
  connect(uAHUMod, outDamPosMin.u2)
    annotation (Line(points={{-200,-100},{118,-100}}, color={255,0,255}));
  connect(outDamPhyPosMinSig.y, outDamPosMin.u3) annotation (Line(points={{-119,
          -130},{-76,-130},{-76,-108},{118,-108}}, color={0,0,127}));
  connect(minOA.y, minOutDamForOutMinSet.x1) annotation (Line(points={{1,100},{26,100},{26,48},{58,48}},
                                color={0,0,127}));
  connect(desOA.y, minOutDamForOutMinSet.x2) annotation (Line(points={{1,20},{26,20},{26,36},{58,36}},
                                color={0,0,127}));
  connect(minPosAtCurSpe.y, minOutDamForOutMinSet.f1) annotation (Line(points={{1,60},{1,60},{40,60},{40,44},{58,44}},
                                                   color={0,0,127}));
  connect(desPosAtCurSpe.y, minOutDamForOutMinSet.f2) annotation (Line(points={{1,-30},{34,-30},{34,32},{58,32}},
                                             color={0,0,127}));
  connect(uVOutMinSet, minOutDamForOutMinSet.u) annotation (Line(points={{-200,
          138},{-86,138},{30,138},{30,40},{58,40}},
                                               color={0,0,127}));
  connect(minOutDamForOutMinSet.y, outDamPosMin.u1) annotation (Line(points={{81,40},
          {88,40},{88,-92},{118,-92}},     color={0,0,127}));
  connect(outDamPosMin.y, yOutDamPosMin) annotation (Line(points={{141,-100},{
          148,-100},{148,20},{190,20}},
                                    color={0,0,127}));
  connect(minFanSpe.y, desPosAtCurSpe.x1) annotation (Line(points={{-119,-8},{-66,-8},{-66,-22},{-22,-22}},
                                    color={0,0,127}));
  connect(desPosAtMinSpe.y, desPosAtCurSpe.f1) annotation (Line(points={{-119,-80},{-66,-80},{-66,-26},{-22,-26}},
                                          color={0,0,127}));
  connect(maxFanSpe.y, desPosAtCurSpe.x2) annotation (Line(points={{-119,28},{-98,28},{-74,28},{-74,-34},{-22,-34}},
                                             color={0,0,127}));
  connect(desPosAtMaxSpe.y, desPosAtCurSpe.f2) annotation (Line(points={{-119,-40},{-102,-40},{-74,-40},{-74,-38},{-22,-38}},
                                                     color={0,0,127}));
  connect(minFanSpe.y, minPosAtCurSpe.x1) annotation (Line(points={{-119,-8},{-66,-8},{-66,68},{-22,68}},
                                  color={0,0,127}));
  connect(minPosAtMinSpe.y, minPosAtCurSpe.f1) annotation (Line(points={{-119,74},{-98,74},{-74,74},{-74,64},{-22,64}},
                                                color={0,0,127}));
  connect(maxFanSpe.y, minPosAtCurSpe.x2) annotation (Line(points={{-119,28},{-74,28},{-74,56},{-22,56}},
                                  color={0,0,127}));
  connect(minPosAtMaxSpe.y, minPosAtCurSpe.f2) annotation (Line(points={{-119,112},{-90,112},{-58,112},{-58,52},{-22,52}},
                                                  color={0,0,127}));
  connect(uSupFanSpe, minPosAtCurSpe.u)
    annotation (Line(points={{-200,56},{-112,56},{-112,60},{-22,60}},
                                                           color={0,0,127}));
  connect(uSupFanSpe, desPosAtCurSpe.u) annotation (Line(points={{-200,56},{-146,56},{-86,56},{-86,-30},{-22,-30}},
                                             color={0,0,127}));
  annotation (
    defaultComponentName = "ecoMinOAPos",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,200}}),
                                                                graphics={
        Rectangle(
        extent={{-180,-140},{180,200}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-112,130},{-112,-80},{148,-80}}, color={0,0,127}),
        Ellipse(
          extent={{-88,124},{-84,120}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-26},{-84,-30}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{96,96},{100,92}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{96,-48},{100,-52}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-86,122},{98,94}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-86,-28},{98,-50}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{14,-40},{14,108}},
          color={0,0,127},
          thickness=0.5),
        Rectangle(
          extent={{12,-38},{16,-42}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,110},{16,106}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{14,6},{-112,6}},
          color={0,0,127},
          pattern=LinePattern.Dot),
        Polygon(
          points={{14,10},{10,6},{14,2},{18,6},{14,10}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,244},{104,208}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(                           extent={{-180,-180},{
            180,180}},
        initialScale=0.1)),
    Documentation(info="<html>      
<p>
This atomic sequence sets the minimum economizer damper position limit. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.P.4.d.
</p>   
<p>
The controller is enabled when the zone is in occupied mode. Otherwise, the outdoor air damper position limit is set to
minimum physical or at commissioning fixed limits. The state machine diagram below illustrates this.
<br/>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsStateMachineChartSingleZone.png\"/>
</p>
<p>
According to article from G36, 
<ul>
<li>
based on current supply fan speed (<code>uSupFanSpe</code>), it calculates outdoor air damper position (<code>minPosAtCurSpe</code>), 
to ensure minimum outdoor air flow rate (<code>minVOut_flowSet</code>); 
</li>
</ul>
<ul>
<li>
based on current supply fan speed (<code>uSupFanSpe</code>), it calculates outdoor air damper position (<code>desPosAtCurSpe</code>), 
to ensure design outdoor air flow rate (<code>desVOut_flowSet</code>);
</li>
</ul>
<ul>
<li>
given the calculated air damper positions (<code>minPosAtCurSpe</code>, <code>desPosAtCurSpe</code>) 
and the outdoor air flow rate limits (<code>minVOut_flowSet</code>, <code>desVOut_flowSet</code>), 
it caculates the minimum outdoor air damper position (<code>yOutDamPosMin</code>), 
to ensure outdoor air flow rate setpoint (<code>uVOutMinSet</code>) 
under current supply fan speed (<code>uSupFanSpe</code>).
</li>
</ul>
Both the outdoor air flow rate setpoint (code>uVOutMinSet</code>) 
and current supply fan speed (<code>uSupFanSpe</code>) are output from separate sequences.
</p>
<p>
This chart illustrates the OA damper position calculation based on the supply fan speed:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of damper position limits control chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconDamperLimitsControlChartSingleZone.png\"/>
</p>
<p>
fixme: additional text about the functioning of the sequence
Note that VOut depends on whether the economizer damper is controlled to a 
position higher than it's minimum limit. This is defined by the EconEnableDisable
and EconModulate [fixme check seq name] sequences. Fixme feature add: For this reason
we may want to implement something like:
while VOut > VOutSet and outDamPos>outDamPosMin, keep previous outDamPosMin.
fixme: add option for separate minimum outdoor air damper.
</p>
    </html>", revisions="<html>
    <ul>
    <li>
    July 06, 2017, by Milica Grahovac:<br/>
    Finalized for the integration in the composite single zone VAV AHU economizer sequence.
    </li>
    <li>
    April 15, 2017, by Jianjun Hu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end EconDamperPositionLimitsSingleZone;

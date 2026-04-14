within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SingleStepSetpointChange "Single-step setpoint change"

  parameter Real samPer(final unit="s",final quantity="Time")
    "Sample period";
  parameter Real alwDev(min=1E-6)
    "Allowed deviation for equality";
  parameter Boolean setChaMod=true
    "Setpoint change mode; true to go to the target setpoint value, false to go to the baseline setpoint value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTarSet
    "Target setpoint: the setpoint under load-shed or load-increase scenarios"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBasSet
    "Baseline setpoint: the setpoint under normal conditions"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCurSet "Current setpoint"
    annotation (Placement(transformation(extent={{-200,22},{-160,62}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "\"Enable\" signal for the setpoint change"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSet
    "Command setpoint output: the setpoint that an external controller should change to"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_uTarSet "Reached the target setpoint"
    annotation (Placement(transformation(extent={{160,70},{200,110}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_uBasSet "Reached the baseline setpoint" annotation (Placement(
    transformation(extent={{160,-110},{200,-70}}), iconTransformation(extent={{100,-70},
            {140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between the baseline setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(final samplePeriod=samPer)
    "Sample period for the single-step change"
    annotation (Placement(transformation(extent={{116,-10},{136,10}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Minimum of baseline setpoint and target setpoint"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum of baseline setpoint and target setpoint"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=setChaMod)
    "Setpoint change mode boolean constant"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch for having priority"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Min min2
    "Current setpoint should be no smaller than the minimum of the baseline setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Current setpoint should be no larger than the maximum of the baseline setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual
    reaNumEquTarSet(alwDev=alwDev)
    "Check if the current setpoint and the target setpoint are equal to each other"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.RealEqual
    reaNumEquBasSet(alwDev=alwDev)
    "Check if the current setpoint and the baseline setpoint are equal to each other"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
equation
  connect(uBasSet,max1. u2) annotation (Line(points={{-180,-120},{-76,-120},{
          -76,-6},{-2,-6}},
                     color={0,0,127}));
  connect(uEna,swi. u2) annotation (Line(points={{-180,120},{-104,120},{-104,
          -70},{-2,-70}},                 color={255,0,255}));
  connect(uCurSet,swi. u3) annotation (Line(points={{-180,42},{-56,42},{-56,-78},
          {-2,-78}},  color={0,0,127}));
  connect(max1.y,min2. u1) annotation (Line(points={{22,0},{30,0},{30,6},{38,6}},
        color={0,0,127}));
  connect(swi.y,min2. u2)
    annotation (Line(points={{22,-70},{26,-70},{26,-6},{38,-6}},
                                                        color={0,0,127}));
  connect(min2.y,max2. u2) annotation (Line(points={{62,0},{70,0},{70,-6},{78,-6}},
                    color={0,0,127}));
  connect(min1.y,max2. u1) annotation (Line(points={{22,70},{68,70},{68,6},{78,6}},
                          color={0,0,127}));
  connect(sam.y,yComSet)  annotation (Line(points={{138,0},{180,0}},
                             color={0,0,127}));
  connect(max2.y,sam. u) annotation (Line(points={{102,0},{114,0}},
                                color={0,0,127}));
  connect(con.y, swi1.u2) annotation (Line(points={{-118,-170},{-48,-170},{-48,-30},
          {-42,-30}},
        color={255,0,255}));
  connect(uTarSet, swi1.u1) annotation (Line(points={{-180,-40},{-110,-40},{
          -110,-22},{-42,-22}},      color={0,0,127}));
  connect(uBasSet, swi1.u3) annotation (Line(points={{-180,-120},{-76,-120},{
          -76,-38},{-42,-38}},       color={0,0,127}));
  connect(swi1.y, swi.u1) annotation (Line(points={{-18,-30},{-12,-30},{-12,-62},
          {-2,-62}},color={0,0,127}));
  connect(min1.u2,uBasSet)  annotation (Line(points={{-2,64},{-76,64},{-76,-120},
          {-180,-120}},                    color={0,0,127}));
  connect(uTarSet, max1.u1) annotation (Line(points={{-180,-40},{-92,-40},{-92,
          6},{-2,6}}, color={0,0,127}));
  connect(uTarSet, min1.u1) annotation (Line(points={{-180,-40},{-92,-40},{-92,
          76},{-2,76}}, color={0,0,127}));
  connect(reaNumEquTarSet.y, reach_uTarSet) annotation (Line(points={{2,150},{
          80,150},{80,90},{180,90}}, color={255,0,255}));
  connect(uCurSet, reaNumEquTarSet.u1) annotation (Line(points={{-180,42},{-132,
          42},{-132,156},{-22,156}}, color={0,0,127}));
  connect(uTarSet, reaNumEquTarSet.u2) annotation (Line(points={{-180,-40},{
          -136,-40},{-136,144},{-22,144}},
                                      color={0,0,127}));
  connect(uCurSet, reaNumEquBasSet.u1) annotation (Line(points={{-180,42},{-56,
          42},{-56,-144},{-22,-144}}, color={0,0,127}));
  connect(uBasSet, reaNumEquBasSet.u2) annotation (Line(points={{-180,-120},{
          -64,-120},{-64,-156},{-22,-156}},
                                        color={0,0,127}));
  connect(reaNumEquBasSet.y, reach_uBasSet) annotation (Line(points={{2,-150},{
          80,-150},{80,-90},{180,-90}}, color={255,0,255}));
  annotation (defaultComponentName="sinSteSetCha",
        Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          radius=0,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-200},{160,200}},
        grid={2,2})),
    Documentation(info="<html>
<p>
This block changes the value of a setpoint between 
the baseline setpoint and the target setpoint in a single step when the \"enable\" signal becomes <code>true</code>.
</p>

<p>
The meaning of each input variable is described below: 
</p>
<ul>
<li>
<code>uCurSet</code>: the current setpoint, which represents the current value of the setpoint that needs to be changed.
</li>
<li>
<code>uBasSet</code>: the baseline setpoint, which represents the setpoint value during normal conditions without load-shed or load-increase 
demand flexibility actions. The value of this setpoint is constant most of the time, and the value is 
expected to change when the occupancy mode is changed between the unoccupied mode and the occupied mode.
</li>
<li>
<code>uTarSet</code>: the target setpoint, which represents the setpoint value under demand flexibility needs such as load-shed or load-increase. The value of this setpoint is constant most of the time, and the value is 
expected to change when the occupancy mode is changed between the unoccupied mode and the occupied mode.
</li>
</ul>

<p>
The parameter <code>setChaMod</code> specifies whether the current 
setpoint <code>uCurSet</code> shall change to the <code>uBasSet</code> value or the 
<code>uTarSet</code> value in a single step. The setpoint change operation 
will be executed every <code>samPer</code> seconds. 
The resultant setpoint will be outputted as the 
<code>yComSet</code> output variable, which 
represents the new setpoint that a zone or a piece of equipment shall have. 
The output variable <code>yComSet</code> is intended to be received by an external
zone temperature controller or equipment controller, which will execute the setpoint change and pass the new setpoint
back to the input variable <code>uCurSet</code> in this block, completing a full control loop.
</p>

<p>
The <code>uEna</code> boolean input variable 
specifies whether a setpoint has an \"enable\" signal to execute the single-step setpoint change operation.
This is useful in multiple-zone or multiple-equipment scenarios where there is a need to prioritize 
which zone or equipment will go through the setpoint change. When the 
<code>uEna</code> input variable is set to <code>true</code>, either <code>uBasSet</code> or 
<code>uTarSet</code> is passed to <code>yComSet</code>, depending on the parameter value of <code>setChaMod</code>.
When <code>uEna</code> is changed to <code>false</code> from a previous 
<code>true</code> value, <code>yComSet</code> will simply take the value <code>uCurSet</code> 
and will not be reverted to the previous value before the setpoint change. Reversing this unidirectional 
change to the current setpoint <code>uCurSet</code> needs to happen outside of this block. 
</p>

<p>
Output variables also include boolean flags that specify whether the current 
setpoint has reached the baseline setpoint <code>uBasSet</code> or the target setpoint 
<code>uTarSet</code>. 
</p>


</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleStepSetpointChange;

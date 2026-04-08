within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SetpointSingleStepChange "Single-step setpoint change"

  parameter Real samPer(unit="s",quantity="Time")=300
    "Sample period";
  parameter Real alwDev(min=1E-6)=0.01
    "Allowed deviation for equality";
  parameter Boolean setChaMod=true
    "Setpoint change mode; true to go to the target setpoint value, false to go to the baseline setpoint value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSetTar "Target setpoint"
    annotation (Placement(transformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSetBas "Baseline setpoint"
    annotation (Placement(transformation(extent={{-140,-88},{-100,-48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSetCur "Current setpoint input"
    annotation (Placement(transformation(extent={{-140,12},{-100,52}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput have_pri "Have priority"
    annotation (Placement(transformation(extent={{-140,62},{-100,102}}),
      iconTransformation(extent={{-140,62},{-100,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySetCom "Setpoint command output"
    annotation (Placement(transformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_uSetTar "Reached the target setpoint"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{200,52},{240,92}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reach_uSetBas "Reached the baseline setpoint" annotation (Placement(
    transformation(extent={{200,-94},{240,-54}}), iconTransformation(extent={{200,-94},
      {240,-54}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between the baseline setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{10,-46},{30,-26}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(final samplePeriod=samPer)
    "Sample period for the single-step change"
    annotation (Placement(transformation(extent={{166,-10},{186,10}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Minimum of baseline setpoint and target setpoint"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum of baseline setpoint and target setpoint"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=setChaMod)
    "Setpoint change mode boolean constant"
    annotation (Placement(transformation(extent={{-92,-144},{-72,-124}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Switch for having priority"
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Buildings.Controls.OBC.CDL.Reals.Min min2
    "Current setpoint should be no smaller than the minimum of the baseline setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{92,-16},{112,4}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Current setpoint should be no larger than the maximum of the baseline setpoint and the target setpoint"
    annotation (Placement(transformation(extent={{132,-10},{152,10}})));
  CDL.Reals.Add                        add2 "Input u2 plus allowed deviation"
    annotation (Placement(transformation(extent={{46,158},{66,178}})));
  CDL.Reals.Subtract                        sub
    "Input u2 minus allowed deviation"
    annotation (Placement(transformation(extent={{46,90},{66,110}})));
  CDL.Reals.Sources.Constant                        con1(k=alwDev)
    "Allowed deviation constant"
    annotation (Placement(transformation(extent={{-12,126},{8,146}})));
  CDL.Reals.Greater                        gre "Greater than"
    annotation (Placement(transformation(extent={{100,98},{120,118}})));
  CDL.Reals.Less                        les "Less than"
    annotation (Placement(transformation(extent={{96,166},{116,186}})));
  CDL.Logical.And                        and2
    "Input u1 within input u2 plus or minus allowed deviation"
    annotation (Placement(transformation(extent={{146,166},{166,186}})));
  CDL.Reals.Add                        add1 "Input u2 plus allowed deviation"
    annotation (Placement(transformation(extent={{48,-132},{68,-112}})));
  CDL.Reals.Subtract                        sub1
    "Input u2 minus allowed deviation"
    annotation (Placement(transformation(extent={{50,-194},{70,-174}})));
  CDL.Reals.Sources.Constant                        con2(k=alwDev)
    "Allowed deviation constant"
    annotation (Placement(transformation(extent={{-10,-164},{10,-144}})));
  CDL.Reals.Greater                        gre1
                                               "Greater than"
    annotation (Placement(transformation(extent={{102,-170},{122,-150}})));
  CDL.Reals.Less                        les1
                                            "Less than"
    annotation (Placement(transformation(extent={{100,-124},{120,-104}})));
  CDL.Logical.And                        and1
    "Input u1 within input u2 plus or minus allowed deviation"
    annotation (Placement(transformation(extent={{150,-148},{170,-128}})));
equation
  connect(uSetBas,max1. u2) annotation (Line(points={{-120,-68},{-78,-68},{-78,
          -44},{-26,-44},{-26,-6},{48,-6}},
                     color={0,0,127}));
  connect(have_pri,swi. u2) annotation (Line(points={{-120,82},{-58,82},{-58,
          -74},{46,-74}},                 color={255,0,255}));
  connect(uSetCur,swi. u3) annotation (Line(points={{-120,32},{-6,32},{-6,-82},
          {46,-82}},  color={0,0,127}));
  connect(max1.y,min2. u1) annotation (Line(points={{72,0},{90,0}},
        color={0,0,127}));
  connect(swi.y,min2. u2)
    annotation (Line(points={{70,-74},{76,-74},{76,-12},{90,-12}},
                                                        color={0,0,127}));
  connect(min2.y,max2. u2) annotation (Line(points={{114,-6},{130,-6}},
                    color={0,0,127}));
  connect(min1.y,max2. u1) annotation (Line(points={{72,60},{118,60},{118,6},{
          130,6}},        color={0,0,127}));
  connect(sam.y,ySetCom)  annotation (Line(points={{188,0},{220,0}},
                             color={0,0,127}));
  connect(max2.y,sam. u) annotation (Line(points={{154,0},{164,0}},
                                color={0,0,127}));
  connect(con.y, swi1.u2) annotation (Line(points={{-70,-134},{2,-134},{2,-36},
          {8,-36}},
        color={255,0,255}));
  connect(uSetTar, swi1.u1) annotation (Line(points={{-120,-18},{-72,-18},{-72,
          -28},{8,-28}},             color={0,0,127}));
  connect(uSetBas, swi1.u3) annotation (Line(points={{-120,-68},{-78,-68},{-78,
          -44},{8,-44}},             color={0,0,127}));
  connect(swi1.y, swi.u1) annotation (Line(points={{32,-36},{38,-36},{38,-66},{
          46,-66}}, color={0,0,127}));
  connect(min1.u2,uSetBas)  annotation (Line(points={{48,54},{-26,54},{-26,-44},
          {-78,-44},{-78,-68},{-120,-68}}, color={0,0,127}));
  connect(uSetTar, max1.u1) annotation (Line(points={{-120,-18},{-42,-18},{-42,
          6},{48,6}}, color={0,0,127}));
  connect(uSetTar, min1.u1) annotation (Line(points={{-120,-18},{-42,-18},{-42,
          66},{48,66}}, color={0,0,127}));
  connect(con1.y, add2.u2) annotation (Line(points={{10,136},{34,136},{34,162},
          {44,162}}, color={0,0,127}));
  connect(con1.y, sub.u2) annotation (Line(points={{10,136},{34,136},{34,94},{
          44,94}}, color={0,0,127}));
  connect(add2.y,les. u2) annotation (Line(points={{68,168},{94,168}},
                color={0,0,127}));
  connect(sub.y,gre. u2)
    annotation (Line(points={{68,100},{98,100}},  color={0,0,127}));
  connect(les.y,and2. u1) annotation (Line(points={{118,176},{144,176}},
                                   color={255,0,255}));
  connect(gre.y,and2. u2) annotation (Line(points={{122,108},{138,108},{138,168},
          {144,168}},     color={255,0,255}));
  connect(con2.y, add1.u2) annotation (Line(points={{12,-154},{36,-154},{36,
          -128},{46,-128}}, color={0,0,127}));
  connect(con2.y, sub1.u2) annotation (Line(points={{12,-154},{36,-154},{36,
          -190},{48,-190}}, color={0,0,127}));
  connect(add1.y, les1.u2)
    annotation (Line(points={{70,-122},{98,-122}}, color={0,0,127}));
  connect(sub1.y, gre1.u2) annotation (Line(points={{72,-184},{86,-184},{86,
          -168},{100,-168}}, color={0,0,127}));
  connect(les1.y, and1.u1) annotation (Line(points={{122,-114},{138,-114},{138,
          -138},{148,-138}}, color={255,0,255}));
  connect(gre1.y, and1.u2) annotation (Line(points={{124,-160},{140,-160},{140,
          -146},{148,-146}}, color={255,0,255}));
  connect(and1.y, reach_uSetBas) annotation (Line(points={{172,-138},{186,-138},
          {186,-74},{220,-74}}, color={255,0,255}));
  connect(and2.y, reach_uSetTar) annotation (Line(points={{168,176},{186,176},{
          186,80},{220,80}}, color={255,0,255}));
  connect(uSetCur, les.u1) annotation (Line(points={{-120,32},{-84,32},{-84,186},
          {78,186},{78,176},{94,176}}, color={0,0,127}));
  connect(gre.u1, uSetCur) annotation (Line(points={{98,108},{78,108},{78,186},
          {-84,186},{-84,32},{-120,32}}, color={0,0,127}));
  connect(uSetTar, add2.u1) annotation (Line(points={{-120,-18},{-78,-18},{-78,
          106},{-24,106},{-24,174},{44,174}}, color={0,0,127}));
  connect(sub.u1, uSetTar) annotation (Line(points={{44,106},{-78,106},{-78,-18},
          {-120,-18}}, color={0,0,127}));
  connect(uSetCur, les1.u1) annotation (Line(points={{-120,32},{-64,32},{-64,
          -98},{78,-98},{78,-114},{98,-114}}, color={0,0,127}));
  connect(gre1.u1, uSetCur) annotation (Line(points={{100,-160},{78,-160},{78,
          -98},{-64,-98},{-64,32},{-120,32}}, color={0,0,127}));
  connect(uSetBas, add1.u1) annotation (Line(points={{-120,-68},{-36,-68},{-36,
          -116},{46,-116}}, color={0,0,127}));
  connect(sub1.u1, uSetBas) annotation (Line(points={{48,-178},{-36,-178},{-36,
          -68},{-120,-68}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-150},{200,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-150},{200,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This block changes the value of a setpoint between 
the baseline setpoint and the target setpoint in a single step when a priority signal is received.
This block is helpful when controlling the setpoints of multiple zones or multiple pieces of equipment,
where setpoints are changed in sequential steps based on some priority signals. </p>

<p>Input variables <code>uSetCur</code>, <code>uSetBas</code>, and <code>uSetTar</code> are the
current setpoint, the baseline setpoint, and the target setpoint, respectively. 
The parameter <code>setChaMod</code> specifies whether the current 
setpoint <code>uSetCur</code> shall change to the <code>uSetBas</code> value or the 
<code>uSetTar</code> value in a single step. The setpoint change operation 
will be executed every <code>samPer</code> seconds. 
The resultant setpoint will be outputted as the 
<code>ySetCom</code> output variable, which 
represents the new setpoint that a zone or a piece of equipment shall have. 
It is expected that outside of this block, a zone temperature controller will receive
the output variable <code>ySetCom</code>, execute the setpoint change, and output the new setpoint
back to the input variable <code>uSetCur</code> in this block, completing a full control loop. (change this sentence)</p>


<p>The <code>have_pri</code> boolean input variable 
specifies whether a setpoint has a priority to execute the single-step setpoint change operation.
This is useful in multiple-zone or multiple-equipment scenarios where there is a need to prioritize 
which zone or equipment will go through the setpoint change. When the 
<code>have_pri</code> input variable is set to <code>true</code>, either <code>uSetBas</code> or 
<code>uSetTar</code> is passed to <code>ySetCom</code>, depending on the parameter value of <code>setChaMod</code>.
When <code>have_pri</code> is changed to <code>false</code> from a previous 
<code>true</code> value, <code>ySetCom</code> will simply take the value <code>uSetCur</code> 
and will not be reverted to the previous value before the setpoint change. Reversing this unidirectional 
change to the current setpoint <code>uSetCur</code> needs to happen outside of this block. </p>

<p>Output variables also include boolean flags that specify whether the current 
setpoint has reached the baseline setpoint <code>uSetBas</code> or the target setpoint 
<code>uSetTar</code>. </p>


</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end SetpointSingleStepChange;

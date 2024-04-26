within Buildings.Templates.Plants.Controls.StagingRotation;
block FailsafeCondition "Evaluate failsafe stage up condition"
  parameter Buildings.Templates.Plants.Controls.Types.Application typ
    "Type of application"
    annotation (Evaluate=true);
  parameter Boolean have_pumSec
    "Set to true for primary-secondary distribution, false for primary-only"
    annotation (Evaluate=true);
  parameter Real dT(
    final min=0,
    final unit="K")
    "Delta-T triggering stage up command (>0)";
  parameter Real dtPri(
    final min=0,
    final unit="s")=900
    "Runtime with high primary-setpoint Delta-T before staging up";
  parameter Real dtSec(
    final min=0,
    final unit="s",
    start=600)=600
    "Runtime with high secondary-primary and secondary-setpoint Delta-T before staging up"
    annotation(Dialog(enable=have_pumSec));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSecSup(final unit="K",
      displayUnit="degC") if have_pumSec
    "Secondary supply temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPriSup(final unit="K",
      displayUnit="degC")              "Primary supply temperature" annotation (
     Placement(transformation(extent={{-178,-20},{-138,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(final unit="K",
      displayUnit="degC") "Supply temperature setpoint" annotation (Placement(
        transformation(extent={{-178,40},{-138,80}}), iconTransformation(extent={{-140,20},
            {-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTSecPri if have_pumSec
                                                     "Secondary-primary ∆T"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTPriSet "Primary-setpoint ∆T"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter polHeaCoo(final k=if typ ==
        Buildings.Templates.Plants.Controls.Types.Application.Cooling then -1
         else 1)   "Polarity depending on heating or cooling application"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter polHeaCoo1(final k=if
        typ == Buildings.Templates.Plants.Controls.Types.Application.Cooling
         then -1 else 1) if have_pumSec
                   "Polarity depending on heating or cooling application"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesPriSet(final t=-dT,final h=0.1
        *dT) "True if Delta-T less than threshold"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesSecPri(final t=-dT,final h=0.1
        *dT) if have_pumSec
             "True if Delta-T less than threshold"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reset
    "Reset timers to zero at completion of stage change"
    annotation (Placement(transformation(extent={{-178,80},{-138,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Utilities.TimerWithReset timPriSet(final t=dtPri)    "Timer"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Utilities.TimerWithReset timSecPri(final t=dtSec)    if have_pumSec
                                                                    "Timer"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or any "Any criterion met"
    annotation (Placement(transformation(extent={{112,-10},{132,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Failsafe stage up condition met" annotation (Placement(transformation(
          extent={{140,-20},{180,20}}), iconTransformation(extent={{100,-20},{140,
            20}})));
  Utilities.PlaceholderLogical ph(
    final have_inp=have_pumSec,
    final have_inpPh=false,
    final u_internal=false) "Placeholder signal"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTSecSet if have_pumSec
                                                     "Secondary-setpoint ∆T"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter polHeaCoo2(final k=if
        typ == Buildings.Templates.Plants.Controls.Types.Application.Cooling
         then -1 else 1) if have_pumSec
                   "Polarity depending on heating or cooling application"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesSecSet(final t=-dT, final h
      =0.1*dT) if have_pumSec
               "True if Delta-T less than threshold"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Utilities.TimerWithReset timSecSet(final t=dtSec) if have_pumSec
                                                    "Timer"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And allSec if have_pumSec
    "All criteria on secondary temperature met"
    annotation (Placement(transformation(extent={{28,-70},{48,-50}})));
equation
  connect(TPriSup, dTPriSet.u1) annotation (Line(points={{-158,0},{-120,0},{
          -120,46},{-112,46}},
                     color={0,0,127}));
  connect(TSupSet, dTPriSet.u2) annotation (Line(points={{-158,60},{-130,60},{
          -130,34},{-112,34}},
                         color={0,0,127}));
  connect(TSecSup, dTSecPri.u1) annotation (Line(points={{-160,-60},{-124,-60},
          {-124,-74},{-112,-74}},
                           color={0,0,127}));
  connect(TPriSup, dTSecPri.u2) annotation (Line(points={{-158,0},{-120,0},{
          -120,-86},{-112,-86}},
                      color={0,0,127}));
  connect(dTPriSet.y, polHeaCoo.u)
    annotation (Line(points={{-88,40},{-82,40}}, color={0,0,127}));
  connect(dTSecPri.y, polHeaCoo1.u)
    annotation (Line(points={{-88,-80},{-82,-80}}, color={0,0,127}));
  connect(polHeaCoo1.y, lesSecPri.u)
    annotation (Line(points={{-58,-80},{-52,-80}}, color={0,0,127}));
  connect(polHeaCoo.y, lesPriSet.u) annotation (Line(points={{-58,40},{-52,40}},
                             color={0,0,127}));
  connect(lesPriSet.y, timPriSet.u)
    annotation (Line(points={{-28,40},{-12,40}},
                                               color={255,0,255}));
  connect(reset, timPriSet.reset) annotation (Line(points={{-158,100},{-20,100},
          {-20,32},{-12,32}},
                       color={255,0,255}));
  connect(lesSecPri.y, timSecPri.u)
    annotation (Line(points={{-28,-80},{-12,-80}},
                                                color={255,0,255}));
  connect(reset, timSecPri.reset) annotation (Line(points={{-158,100},{-20,100},
          {-20,-88},{-12,-88}},
                         color={255,0,255}));
  connect(any.y, y1)
    annotation (Line(points={{134,0},{160,0}}, color={255,0,255}));
  connect(dTSecSet.y, polHeaCoo2.u)
    annotation (Line(points={{-88,-40},{-82,-40}}, color={0,0,127}));
  connect(polHeaCoo2.y, lesSecSet.u)
    annotation (Line(points={{-58,-40},{-52,-40}}, color={0,0,127}));
  connect(lesSecSet.y, timSecSet.u)
    annotation (Line(points={{-28,-40},{-12,-40}},
                                                color={255,0,255}));
  connect(reset, timSecSet.reset) annotation (Line(points={{-158,100},{-20,100},
          {-20,-48},{-12,-48}},
                         color={255,0,255}));
  connect(reset, timSecPri.reset) annotation (Line(points={{-158,100},{-20,100},
          {-20,-88},{-12,-88}},
                         color={255,0,255}));
  connect(TSecSup, dTSecSet.u1) annotation (Line(points={{-160,-60},{-124,-60},
          {-124,-34},{-112,-34}},
                                color={0,0,127}));
  connect(TSupSet, dTSecSet.u2) annotation (Line(points={{-158,60},{-130,60},{
          -130,-46},{-112,-46}},
                           color={0,0,127}));
  connect(timSecSet.passed, allSec.u1) annotation (Line(points={{12,-48},{20,
          -48},{20,-60},{26,-60}}, color={255,0,255}));
  connect(timSecPri.passed, allSec.u2) annotation (Line(points={{12,-88},{20,
          -88},{20,-68},{26,-68}}, color={255,0,255}));
  connect(allSec.y, ph.u)
    annotation (Line(points={{50,-60},{68,-60}}, color={255,0,255}));
  connect(timPriSet.passed, any.u1) annotation (Line(points={{12,32},{100,32},{
          100,0},{110,0}}, color={255,0,255}));
  connect(ph.y, any.u2) annotation (Line(points={{92,-60},{100,-60},{100,-8},{
          110,-8}}, color={255,0,255}));
  annotation (
    defaultComponentName="faiSaf",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(extent={{-140,-120},{140,120}})),
    Documentation(info="<html>
<p>
For heating applications with primary-secondary distribution:
The failsafe stage up condition evaluates to true if either of the following is true.
</p>
<ul>
<li>
Secondary HW supply temperature &lt; primary HW supply temperature - <code>dT</code>
for a period of <code>dtSec</code> and secondary HW supply temperature
&lt; setpoint – <code>dT</code> for <code>dtSec</code>.
</li>
<li>
Primary HW supply temperature &lt; setpoint - <code>dT</code> for 
<code>dtPri</code>.
</li>
</ul>
<p>
For heating applications with primary-only distribution:
The failsafe stage up condition evaluates to true if the following is true.
</p>
<ul>
<li>
Primary HW supply temperature &lt; setpoint - <code>dT</code> for 
<code>dtPri</code>.
</li>
</ul>
<p>
For cooling applications with primary-secondary distribution:
The failsafe stage up condition evaluates to true if either of the following is true.
</p>
<ul>
<li>
Secondary CHW supply temperature &gt; primary CHW supply temperature + <code>dT</code>
for a period of <code>dtSec</code> and secondary CHW supply temperature
&lt; setpoint + <code>dT</code> for <code>dtSec</code>.
</li>
<li>
Primary CHW supply temperature &gt; setpoint + <code>dT</code> for 
<code>dtPri</code>.
</li>
</ul>
<p>
For cooling applications with primary-only distribution:
The failsafe stage up condition evaluates to true if the following is true.
</p>
<ul>
<li>
Primary CHW supply temperature &gt; setpoint + <code>dT</code> for 
<code>dtPri</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end FailsafeCondition;

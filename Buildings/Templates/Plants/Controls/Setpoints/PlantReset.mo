within Buildings.Templates.Plants.Controls.Setpoints;
block PlantReset
  "Plant reset logic"
  parameter Integer nSenDpRem(final min=1)
    "Number of remote loop differential pressure sensors used for pump speed control"
    annotation (Evaluate=true);
  parameter Real dpSet_max[nSenDpRem](
    each final min=5*6894,
    each unit="Pa")
    "Maximum differential pressure setpoint";
  parameter Real dpSet_min(
    final min=0,
    final unit="Pa")=5*6894
    "Minimum value to which the differential pressure can be reset";
  parameter Real TSup_nominal(
    final min=273.15,
    final unit="K",
    displayUnit="degC")
    "Design supply temperature";
  parameter Real TSupSetLim(
    final min=273.15,
    final unit="K",
    displayUnit="degC")
    "Limit value to which the supply temperature can be reset";
  parameter Real dtHol(
    final min=0,
    final unit="s")=900
    "Minimum hold time during stage change"
    annotation (Dialog(tab="Advanced"));
  parameter Real resDp_max(
    final max=1,
    final min=0,
    final unit="1")=0.5
    "Upper limit of plant reset interval for differential pressure reset"
    annotation (Dialog(tab="Advanced"));
  parameter Real resTSup_min(
    final max=1,
    final min=0,
    final unit="1")=resDp_max
    "Lower limit of plant reset interval for supply temperature reset"
    annotation (Dialog(tab="Advanced"));
  parameter Real res_init(
    final max=1,
    final min=0,
    final unit="1")=1
    "Initial reset value"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real res_min(
    final max=1,
    final min=0,
    final unit="1")=0
    "Minimum reset value"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real res_max(
    final max=1,
    final min=0,
    final unit="1")=1
    "Maximum reset value"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real dtDel(
    final min=100*1E-15,
    final unit="s")=900
    "Delay time before the reset begins"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real dtRes(
    final min=1E-3,
    final unit="s")=300
    "Time step"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Integer nReqResIgn(min=0)=2
    "Number of ignored requests"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real tri(
    final max=0,
    final unit="1")=-0.02
    "Reset period"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real rsp(
    final min=0,
    final unit="1")=0.03
    "Respond amount (must have opposite sign of trim amount)"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  parameter Real rsp_max(
    final min=0,
    final unit="1")=0.07
    "Maximum response per reset period (must have same sign as respond amount)"
    annotation (Dialog(tab="Advanced",group="Trim and respond"));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqRes
    "Sum of reset requests of all loads served"
    annotation (Placement(transformation(extent={{-160,100},{-120,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ena
    "Plant enable"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1StaPro
    "Staging process in progress"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpSet[nSenDpRem](
    each final min=0,
    each final unit="Pa")
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond triRes(
    final have_hol=true,
    final delTim=dtDel,
    final iniSet=res_init,
    final maxRes=rsp_max,
    final maxSet=res_max,
    final minSet=res_min,
    final numIgnReq=nReqResIgn,
    final resAmo=rsp,
    final samplePeriod=dtRes,
    final triAmo=tri,
    dtHol=dtHol)
    "Compute plant reset with trim and respond logic "
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Reals.Line resTSup
    "Supply temperature reset"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Line resDp[nSenDpRem]
    "Differential pressure reset"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resDpMax(
    final k=resDp_max)
    "Constant"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSetMax[nSenDpRem](
    final k=dpSet_max)
    "Constant"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resTSupMin(
    final k=resTSup_min)
    "Constant"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetNom(
    final k=TSup_nominal)
    "Constant"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSetMin(
    final k=dpSet_min)
    "Constant"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep3(
    final nout=nSenDpRem)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetMinMax(final k=
        TSupSetLim) "Constant"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
equation
  connect(nReqRes, triRes.numOfReq)
    annotation (Line(points={{-140,120},{-60,120},{-60,92},{-12,92}},color={255,127,0}));
  connect(resTSup.y, TSupSet)
    annotation (Line(points={{102,-60},{140,-60}},  color={0,0,127}));
  connect(resDp.y, dpSet)
    annotation (Line(points={{102,20},{140,20}},  color={0,0,127}));
  connect(one.y, resTSup.x2)
    annotation (Line(points={{-28,-80},{60,-80},{60,-64},{78,-64}},      color={0,0,127}));
  connect(zer.y, rep.u)
    annotation (Line(points={{-28,40},{-12,40}},
                                            color={0,0,127}));
  connect(rep.y, resDp.x1)
    annotation (Line(points={{12,40},{40,40},{40,28},{78,28}}, color={0,0,127}));
  connect(rep1.y, resDp.u)
    annotation (Line(points={{52,80},{60,80},{60,20},{78,20}},     color={0,0,127}));
  connect(rep2.y, resDp.x2)
    annotation (Line(points={{12,0},{40,0},{40,16},{78,16}},       color={0,0,127}));
  connect(dpSetMax.y, resDp.f2)
    annotation (Line(points={{-88,-20},{60,-20},{60,12},{78,12}},     color={0,0,127}));
  connect(TSupSetNom.y, resTSup.f2)
    annotation (Line(points={{-88,-100},{64,-100},{64,-68},{78,-68}},     color={0,0,127}));
  connect(dpSetMin.y, rep3.u)
    annotation (Line(points={{-88,60},{-82,60}},color={0,0,127}));
  connect(rep3.y, resDp.f1)
    annotation (Line(points={{-58,60},{36,60},{36,24},{78,24}},   color={0,0,127}));
  connect(TSupSetMinMax.y, resTSup.f1)
    annotation (Line(points={{-88,-60},{40,-60},{40,-56},{78,-56}},   color={0,0,127}));
  connect(resTSupMin.y, resTSup.x1)
    annotation (Line(points={{-28,-40},{40,-40},{40,-52},{78,-52}},color={0,0,127}));
  connect(resDpMax.y, rep2.u)
    annotation (Line(points={{-28,0},{-12,0}},  color={0,0,127}));
  connect(u1Ena, triRes.uDevSta) annotation (Line(points={{-140,100},{-40,100},{
          -40,108},{-12,108}},  color={255,0,255}));
  connect(triRes.y, rep1.u) annotation (Line(points={{12,100},{20,100},{20,80},{
          28,80}},  color={0,0,127}));
  connect(u1StaPro, triRes.uHol) annotation (Line(points={{-140,80},{-20,80},{-20,
          100},{-12,100}},     color={255,0,255}));
  connect(triRes.y, resTSup.u) annotation (Line(points={{12,100},{70,100},{70,-60},
          {78,-60}},      color={0,0,127}));
  annotation (
    defaultComponentName="res",
    Icon(
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
    Diagram(
      coordinateSystem(
        extent={{-120,-140},{120,140}})),
    Documentation(info="<html>
<p>
This logic is used in primary-only and primary-secondary systems 
serving differential pressure controlled pumps.
</p>
<h5>CHW loops with differential pressure control</h5>
<p>
The CHW supply temperature setpoint and pump differential pressure setpoint 
are reset based on the current value of the logic variable called \"CHW Plant Reset\"
as shown below and described subsequently.
</p>
<p>
<img alt=\"CHW plant reset logic diagram\"
src=\"modelica://Buildings/Resources/Images/Templates/Plants/Controls/Setpoints/PlantResetCHW.png\"/>
</p>
<h5>HW loops with differential pressure control</h5>
<p>
The HW supply temperature setpoint and pump differential pressure setpoint 
are reset based on the current value of the logic variable called \"HW Plant Reset\"
as shown below and described subsequently.
</p>
<p>
<img alt=\"CHW plant reset logic diagram\"
src=\"modelica://Buildings/Resources/Images/Templates/Plants/Controls/Setpoints/PlantResetHW.png\"/>
</p>
<h5>Generic reset logic applicable to all plants</h5>
<p>
From <i>0&nbsp;%</i> loop output to <code>resDp_max</code> loop output, reset 
differential pressure setpoint from <code>dpSet_min</code> to <code>dpSet_max</code>.
</p>
<p>
From <code>resTSup_min</code> loop output to <i>100&nbsp;%</i> loop output, reset supply
temperature setpoint from <code>TSupSetLim</code> to <code>TSup_nominal</code>.
</p>
<p>
CHW/HW Plant Reset variable is reset using trim and respond logic with the following parameters:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>Any pump distribution loop</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>res_init</code></td><td>Initial reset value</td></tr>
<tr><td>SPmin</td><td><code>res_min</code></td><td>Minimum reset value</td></tr>
<tr><td>SPmax</td><td><code>res_max</code></td><td>Maximum reset value</td></tr>
<tr><td>Td</td><td><code>dtDel</code></td><td>Delay time before the reset begins</td></tr>
<tr><td>T</td><td><code>dtRes</code></td><td>Reset period</td></tr>
<tr><td>I</td><td><code>nReqResIgn</code></td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td><code>nReqRes</code></td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td><code>tri</code></td><td>Trim amount</td></tr>
<tr><td>SPres</td><td><code>rsp</code></td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td><code>rsp_max</code></td><td>Maximum response per reset period</td></tr>
</table>
<p>
The plant reset loop is enabled when the plant is enabled and disabled when the plant is disabled.
</p>
<p>
When a plant stage change is initiated, the plant reset logic is disabled and 
value fixed at its last value for the longer of <code>dtHol</code> and the time it 
takes for the plant to successfully stage.
</p>
<h5>Plants serving more than one set of differential pressure controlled pumps</h5>
<p>
A unique instance of the above reset is used for each set of differential pressure 
controlled pumps.
</p>
<ul>
<li>
Reset requests from all loads served by a set of pumps are directed to those pumps’ reset loop only.
</li>
<li>
The differential pressure setpoint output from each reset is used in the ∆p control loop 
for the associated set of pumps only, i.e., the ∆p setpoint will not change 
for any other ∆p control loops.
</li>
</ul>
<h5>Plants where more than one remote ∆p sensor serves a given set of primary or secondary pumps ∆p</h5>                        
<p>
Where more than one remote ∆p sensor serves a given set of primary or secondary pumps, 
remote ∆p setpoints for all remote sensors serving those pumps shall increase in unison. 
Note: if remote sensors have different <code>dpSet_max</code> values, then the amount 
each ∆p setpoint changes per percent loop output will differ.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2024, by Antoine Gautier:<br/>
Updated hold logic during staging after refactoring trim and respond block.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3761\">#3761</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlantReset;

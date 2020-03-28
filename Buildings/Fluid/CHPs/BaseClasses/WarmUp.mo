within Buildings.Fluid.CHPs.BaseClasses;
model WarmUp "Warm-up control sequence"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Time timeDelayStart
    "Time delay between activation and power generation";
  parameter Modelica.SIunits.Temperature TEngNom
    "Nominal engine operating temperature";
  parameter Boolean warmUpByTimeDelay
    "If true, the plant will be in warm-up mode depending on the delay time, 
    otherwise depending on engine temperature ";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Engine temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Transition signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Warm-up by time delay and it has been longer than the specified time"
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Warm-up by engine temperature and the temperature is higher than nominal"
    annotation (Placement(transformation(extent={{32,50},{52,70}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor
    "Check if it should change from warm-up mode to other modes"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Controls.OBC.CDL.Interfaces.BooleanInput actWarUp
    "Warm-up state active signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100, -40}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Timer timer
    "Count the time since the warm-up mode is activated"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold timeDel(
    final threshold=timeDelayStart)
    "Check if it has been in warm-up mode by longer than specified time"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis(
    final uLow=0.5, final uHigh=1)
    "Check if current engine temperature is higher than norminal value"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(final k2=-1)
    "Difference between norminal engin temperature and the current value"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant norEngTem(
    final k=TEngNom)
    "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant timDel(
    final k=warmUpByTimeDelay)
    "Warm-up by time delay"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not engTem "Warm-up by engine temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(xor.y, y) annotation (Line(points={{92,0},{120,0}},
          color={255,0,255}));
  connect(hysteresis.y, and2.u1) annotation (Line(points={{12,60},{30,60}},
          color={255,0,255}));
  connect(add.y, hysteresis.u) annotation (Line(points={{-28,60},{-12,60}},
          color={0,0,127}));
  connect(TEng, add.u1) annotation (Line(points={{-120,60},{-80,60},{-80,66},{-52,
          66}},    color={0,0,127}));
  connect(norEngTem.y, add.u2) annotation (Line(points={{-68,0},{-60,0},{-60,54},
          {-52,54}},color={0,0,127}));
  connect(timDel.y, engTem.u) annotation (Line(points={{-28,0},{-12,0}},
          color={255,0,255}));
  connect(engTem.y, and2.u2) annotation (Line(points={{12,0},{20,0},{20,52},{30,
          52}}, color={255,0,255}));
  connect(timDel.y, and1.u1) annotation (Line(points={{-28,0},{-20,0},{-20,-20},
          {30,-20}},color={255,0,255}));
  connect(timeDel.y, and1.u2) annotation (Line(points={{-18,-60},{0,-60},{0,-28},
          {30,-28}}, color={255,0,255}));
  connect(actWarUp, timer.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={255,0,255}));
  connect(timer.y, timeDel.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(and2.y, xor.u1) annotation (Line(points={{54,60},{60,60},{60,0},{68,0}},
        color={255,0,255}));
  connect(and1.y, xor.u2) annotation (Line(points={{54,-20},{60,-20},{60,-8},{68,
          -8}}, color={255,0,255}));
annotation (defaultComponentName="warUpCtr", Documentation(info="<html>
<p>
The model defines the warm-up operating mode. 
CHP will transition from the warm-up mode to the normal mode after the specified 
time delay (if <code>per.warmUpByTimeDelay</code> is true), 
or when <code>TEng</code> is higher than <code>per.TEngNom</code> 
(if <code>per.warmUpByTimeDelay</code> is false). 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end WarmUp;

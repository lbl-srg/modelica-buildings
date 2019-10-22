within Buildings.Fluid.CHPs.BaseClasses;
model WarmUp "Warm-up operating mode"
  extends Modelica.StateGraph.PartialCompositeStep;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));

  Modelica.StateGraph.Interfaces.Step_in inPort1
    annotation (Placement(transformation(extent={{-170,-90},{-150,-110}}),
      iconTransformation(extent={{-170,-70},{-150,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Engine temperature"
    annotation (Placement(transformation(extent={{-170,90},{-150,110}}),
      iconTransformation(extent={{-288,12},{-248,52}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Transition signal"
    annotation (Placement(transformation(extent={{150,-50},{170,-30}}),
      iconTransformation(extent={{150,-88},{170,-68}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Warm-up by time delay and it has been longer than the specified time"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Warm-up by engine temperature and the temperature is higher than nominal"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor
    "Check if it should change from warm-up mode to other modes"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Modelica.StateGraph.StepWithSignal warmUpState(nIn=2)
    annotation (Placement(transformation(extent={{-40,-16},{-8,16}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Timer timer
    "Count the time since the warm-up mode is activated"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold timeDel(
    final threshold=per.timeDelayStart)
    "Check if it has been in warm-up mode by longer than specified time"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis(
    final uLow=0.5, final uHigh=1)
    "Check if current engine temperature is higher than norminal value"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(final k2=-1)
    "Difference between norminal engin temperature and the current value"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant norEngTem(
    final k=per.TEngNom)
    "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant timDel(
    final k=per.warmUpByTimeDelay)
    "Warm-up by time delay"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not engTem "Warm-up by engine temperature"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

equation
  connect(warmUpState.active, timer.u) annotation (Line(points={{-24,-17.6},{-24,
          -70},{-2,-70}}, color={255,0,255}));
  connect(timer.y, timeDel.u) annotation (Line(points={{22,-70},{38,-70}},
          color={0,0,255}));
  connect(inPort, warmUpState.inPort[1]) annotation (Line(points={{-160,0},{-80,
          0},{-80,0.8},{-41.6,0.8}}, color={0,0,0}));
  connect(warmUpState.outPort[1], outPort) annotation (Line(points={{-7.2,0},
          {155,0}}, color={0,0,0}));
  connect(inPort1, warmUpState.inPort[2]) annotation (Line(points={{-160,-100},{
          -120,-100},{-120,0},{-58,0},{-58,-0.8},{-41.6,-0.8}}, color={0,0,0}));
  connect(xor.y, y) annotation (Line(points={{142,-40},{160,-40}},
          color={255,0,255}));
  connect(and1.y, xor.u1) annotation (Line(points={{102,-40},{118,-40}},
          color={255,0,255}));
  connect(hysteresis.y, and2.u1) annotation (Line(points={{62,90},{78,90}},
          color={255,0,255}));
  connect(and2.y, xor.u2) annotation (Line(points={{102,90},{110,90},{110,-48},{
          118,-48}}, color={255,0,255}));
  connect(add.y, hysteresis.u) annotation (Line(points={{22,90},{38,90}},
          color={0,0,127}));
  connect(TEng, add.u1) annotation (Line(points={{-160,100},{-60,100},{-60,96},{
          -2,96}}, color={0,0,127}));
  connect(norEngTem.y, add.u2) annotation (Line(points={{-18,50},{-10,50},{-10,84},
          {-2,84}}, color={0,0,127}));
  connect(timDel.y, engTem.u) annotation (Line(points={{22,50},{38,50}},
          color={255,0,255}));
  connect(engTem.y, and2.u2) annotation (Line(points={{62,50},{70,50},{70,82},{78,
          82}}, color={255,0,255}));
  connect(timDel.y, and1.u1) annotation (Line(points={{22,50},{30,50},{30,-40},{
          78,-40}}, color={255,0,255}));
  connect(timeDel.y, and1.u2) annotation (Line(points={{62,-70},{70,-70},{70,-48},
          {78,-48}}, color={255,0,255}));

annotation (defaultComponentName="warUp", Documentation(info="<html>
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

within Buildings.Fluid.CHPs.BaseClasses;
model WarmUpLeaving
  "Model evaluating the condition for transitioning from warm-up to normal mode"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Time timeDelayStart
    "Time delay between activation and power generation";
  parameter Modelica.Units.SI.Temperature TEngNom
    "Nominal engine operating temperature";
  parameter Modelica.Units.SI.Power PEleMax=0 "Maximum power output"
    annotation (Dialog(enable=not warmUpByTimeDelay));
  parameter Boolean warmUpByTimeDelay
    "If true, the plant will be in warm-up mode depending on the delay time, otherwise depending on engine temperature "
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEng(
    final unit="K",
    displayUnit="degC") if not warmUpByTimeDelay
    "Engine temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Transition signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput actWarUp
    "Warm-up state active signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(final unit="W")
 if not warmUpByTimeDelay
    "Power demand"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleNet(final unit="W")
 if not warmUpByTimeDelay
    "Net power output"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Timer timer(
    final t=timeDelayStart) if warmUpByTimeDelay
    "Check the time since the warm-up mode is activated"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTem(
    final uLow=-0.5,
    final uHigh=0) if not warmUpByTimeDelay
    "Check if actual engine temperature is higher than the nominal value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
 if not warmUpByTimeDelay
    "Difference between actual engine temperature and the nominal value"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temEngNom(
    y(final unit="K", displayUnit="degC"),
    final k=TEngNom)
    "Nominal engine temperature"
    annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
 if not warmUpByTimeDelay
    "Difference between actual power output and demand"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysPow(
    final uLow=-0.01*PEleMax - 1e-6,
    final uHigh=0) if not warmUpByTimeDelay
    "Check if actual power output is higher than demand"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if not warmUpByTimeDelay "OR evaluation"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre if not warmUpByTimeDelay
    "Infinitesimal time delay to break algebraic loop related to power output computation"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

equation
  connect(sub.y, hysTem.u)
    annotation (Line(points={{-28,0},{-12,0}}, color={0,0,127}));
  connect(TEng, sub.u1)
    annotation (Line(points={{-120,20},{-80,20},{-80,6},{-52,6}}, color={0,0,127}));
  connect(temEngNom.y, sub.u2)
    annotation (Line(points={{-66,-20},{-60,-20},{-60, -6},{-52,-6}}, color={0,0,127}));
  connect(actWarUp, timer.u)
    annotation (Line(points={{-120,60},{-2,60}},    color={255,0,255}));
  connect(sub1.y, hysPow.u)
    annotation (Line(points={{-28,-60},{-12,-60}}, color={0,0,127}));
  connect(PEle, sub1.u2) annotation (Line(points={{-120,-80},{-80,-80},{-80,-66},
          {-52,-66}}, color={0,0,127}));
  connect(hysTem.y, or2.u1) annotation (Line(points={{12,0},{20,0},{20,-20},{28,
          -20}}, color={255,0,255}));
  connect(hysPow.y, or2.u2) annotation (Line(points={{12,-60},{20,-60},{20,-28},
          {28,-28}}, color={255,0,255}));
  connect(or2.y, pre.u)
    annotation (Line(points={{52,-20},{58,-20}}, color={255,0,255}));
  connect(pre.y, y) annotation (Line(points={{82,-20},{90,-20},{90,0},{120,0}},
        color={255,0,255}));
  connect(PEleNet, sub1.u1) annotation (Line(points={{-120,-40},{-80,-40},{-80,
          -54},{-52,-54}}, color={0,0,127}));
  connect(timer.passed, y) annotation (Line(points={{22,52},{60,52},{60,0},{120,
          0}}, color={255,0,255}));

annotation (defaultComponentName="warUpCtr", Documentation(info="<html>
<p>
The model computes a boolean variable which is true when warm-up
is over.
CHP will transition from the warm-up mode to the normal mode
</p>
<ul>
<li>
after the specified time delay if <code>warmUpByTimeDelay</code> is true, or
</li>
<li>
when the engine temperature exceeds the nominal value or the net power produced
exceeds that requested by the controller if <code>warmUpByTimeDelay</code> is false.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 8, 2020, by Antoine Gautier:<br/>
Add condition on power output.
</li>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end WarmUpLeaving;

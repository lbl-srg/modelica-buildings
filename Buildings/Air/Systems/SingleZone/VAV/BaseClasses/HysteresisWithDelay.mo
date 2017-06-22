within Buildings.Air.Systems.SingleZone.VAV.BaseClasses;
model HysteresisWithDelay
  extends Modelica.Blocks.Icons.Block;

  parameter Real uLow = 0.05 "if y=true and u<=uLow, switch to y=false";
  parameter Real uHigh = 0.15 "if y=false and u>=uHigh, switch to y=true";
  Modelica.StateGraph.InitialStep staOff "Off state"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.StateGraph.Transition toOn(
    waitTime=waitTimeToOn,
    condition=u > uHigh,
    enableTimer=waitTimeToOn > 0) "Transition to on"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.StateGraph.Transition toOff(
    waitTime=waitTimeToOff,
    condition=u < uLow,
    enableTimer=waitTimeToOff > 0) "Transition to off"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Modelica.StateGraph.StepWithSignal staOn "On state"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Interfaces.BooleanOutput on "On signal" annotation (Placement(
        transformation(rotation=0, extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput u(unit="1") "Control input" annotation (
      Placement(transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  parameter Modelica.SIunits.Time waitTimeToOn=15*60
    "Wait time before transition fires to active";
  parameter Modelica.SIunits.Time waitTimeToOff=15*60
    "Wait time before transition fires to off";
initial equation
  assert(uLow < uHigh, "Require uLow < uHigh.");
equation
  connect(toOn.inPort, staOff.outPort[1])
    annotation (Line(points={{-4,20},{-19.5,20}}, color={0,0,0}));
  connect(toOn.outPort, staOn.inPort[1])
    annotation (Line(points={{1.5,20},{19,20}}, color={0,0,0}));
  connect(staOn.outPort[1], toOff.inPort) annotation (Line(points={{40.5,20},{
          50,20},{50,-20},{4,-20}}, color={0,0,0}));
  connect(toOff.outPort, staOff.inPort[1]) annotation (Line(points={{-1.5,-20},
          {-50,-20},{-50,20},{-41,20}}, color={0,0,0}));
  connect(on, staOn.active) annotation (Line(points={{110,0},{110,0},{30,0},{30,
          0},{30,9}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Model for a hysteresis block that optionally allows to specify
a wait time. During this wait time, the current state is hold.
</p>
</html>", revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
          Line(points={{-2,2},{34,2}}),
          Polygon(
            points={{34,8},{46,2},{34,-4},{34,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(extent={{46,18},{84,-16}}, lineColor={0,0,0}),
          Line(points={{-2,34},{-2,-36}}),
          Polygon(
            points={{-14,8},{-2,2},{-14,-4},{-14,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Line(points={{-46,2},{-14,2}}),
          Rectangle(extent={{-84,18},{-46,-16}}, lineColor={0,0,0}),
        Text(
          extent={{-68,-40},{60,-82}},
          lineColor={0,0,0},
          textString="%uLow     %uHigh")}));
end HysteresisWithDelay;

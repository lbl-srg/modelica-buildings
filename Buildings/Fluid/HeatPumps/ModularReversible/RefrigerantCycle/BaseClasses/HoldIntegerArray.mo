within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block HoldIntegerArray
  "Block that holds an output signal for at least a specified duration"
  parameter Real holdDuration(
    final quantity="Time",
    final unit="s")
    "Duration of hold"
    annotation (Evaluate=true);
  parameter Integer u_max(
    min=0)
    "Maximum value of sum(u)"
    annotation (Evaluate=true);
  parameter Integer nin(
    min=0)=0
    "Size of input array"
    annotation (Evaluate=true,
    Dialog(connectorSizing=true),HideResult=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u[nin]
    "Input signal that is to be held"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y[nin]
    "Output with held input signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  discrete Real entryTime(final quantity="Time", final unit="s")
    "Time instant when hold started";
initial equation
  pre(entryTime) = -Modelica.Constants.inf;
  pre(u) = u;
  pre(y) = u;
equation
  when initial() then
    y = {if sum(u[1:i]) <= u_max then u[i] else
     (if i>1 then u_max - sum(y[1:i-1]) else u_max) for i in 1:nin};
    entryTime = if Modelica.Math.BooleanVectors.anyTrue({change(y[i]) for i in 1:nin})
    then time else pre(entryTime);
  elsewhen {Modelica.Math.BooleanVectors.anyTrue({change(u[i]) for i in 1:nin}),
    time >= pre(entryTime) + holdDuration} then
    y=if time >= pre(entryTime) + holdDuration then
     {if sum(u[1:i]) <= u_max then u[i] else
     (if i>1 then u_max - sum(y[1:i-1]) else u_max) for i in 1:nin}
     else pre(y);
    entryTime = if Modelica.Math.BooleanVectors.anyTrue({change(y[i]) for i in 1:nin})
    then time else pre(entryTime);
  end when;
end HoldIntegerArray;

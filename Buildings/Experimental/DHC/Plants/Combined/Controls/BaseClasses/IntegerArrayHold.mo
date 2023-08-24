within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block IntegerArrayHold
  "Block that holds the value of an integer array for a given time"
  parameter Integer nin=0
    "Array dimension"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  final parameter Integer nout=nin
    "Output array dimension";
  parameter Real holdDuration(
    final quantity="Time",
    final unit="s")=1
    "Hold duration";

 Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u[nin]
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y[nout]
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Real time_change;
initial algorithm
  y := u;
  time_change := time;
algorithm
  when Modelica.Math.BooleanVectors.anyTrue({
    u[i] <> pre(y[i]) for i in 1:nin}) and time - time_change > holdDuration then
    y := u;
    time_change := time;
  end when;

  annotation (
  defaultComponentName="hol",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This blocks updates the value of the output array to 
match the value of the input array only if the time
since the last update exceeds <code>holdDuration</code>.
Otherwise, the value of the output array is kept equal
to its value at the time of the last update.
At initial time, the value of the output array is set 
to the value of the input array, and this is considered
as the first update time.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end IntegerArrayHold;

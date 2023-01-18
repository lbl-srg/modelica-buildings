within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block IntegerArrayHold
  parameter Integer nin
    "Array dimension";
  parameter Real holdDuration(
    final quantity="Time",
    final unit="s")=1
    "Hold duration";

 Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u[nin]
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y[nin]
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
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end IntegerArrayHold;

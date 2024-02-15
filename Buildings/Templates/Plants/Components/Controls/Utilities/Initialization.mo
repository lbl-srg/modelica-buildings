within Buildings.Templates.Plants.Components.Controls.Utilities;
block Initialization
  "Force signal value at initial time"
  parameter Boolean yIni=false
    "Initial value";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{98,-20},{138,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
equation
  y=if initial() then yIni else u;
  annotation (
    defaultComponentName="ini",
    Documentation(
      info="<html>
<p>
At initial time, this block returns the
value specified by the parameter <code>y1Ini</code>, which
is set to <code>false</code> by default.
Otherwise, this block returns the
value of the input value, i.e., it acts as a direct pass-through.
</p>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}));
end Initialization;

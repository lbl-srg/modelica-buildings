within Buildings.Templates.Plants.Components.Controls.Utilities;
block Initialization
  "Force signal value at initial time"
  parameter Boolean y1Ini=false
    "Initial value";
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Switch between initial and actual value"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{98,-20},{138,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=y1Ini)
    "Constant"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Utilities.Time.ModelTime modTim
    "Return model time"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=startTime,
    final h=0)
    "Time comparison to trigger the change from initial to actual value"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
protected
  parameter Real startTime(fixed=false)
    "Time at initialization";
initial equation
  startTime=time;
equation
  connect(logSwi.y, y1)
    annotation (Line(points={{44,0},{120,0}},color={255,0,255}));
  connect(u, logSwi.u1)
    annotation (Line(points={{-120,0},{-40,0},{-40,8},{20,8}},color={255,0,255}));
  connect(con.y, logSwi.u3)
    annotation (Line(points={{-58,-60},{0,-60},{0,-8},{20,-8}},color={255,0,255}));
  connect(modTim.y, greThr.u)
    annotation (Line(points={{-59,-20},{-42,-20}},color={0,0,127}));
  connect(greThr.y, logSwi.u2)
    annotation (Line(points={{-18,-20},{-10,-20},{-10,0},{20,0}},color={255,0,255}));
  annotation (
    defaultComponentName="ini",
    Documentation(
      info="<html>
FIXME: Not CDL compliant as it uses Buildings.Utilities.Time.ModelTime.
<p>
At initial time (<code>time=0</code>), this block returns the
value specified by the parameter <code>y1Ini</code>, which
is set to <code>false</code> by default.
Otherwise (<code>time&gt;0</code>), this block returns the
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

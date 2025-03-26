within Buildings.Examples.Tutorial.CDL.Controls;
block RadiatorSupply "Controller for mixing valve in radiator loop"

  parameter Real TSupMin(
    final unit="K",
    displayUnit="degC") = 294.15
    "Minimum supply water temperature";
  parameter Real TSupMax(
    final unit="K",
    displayUnit="degC") = 323.15
    "Maximum supply water temperature";
  parameter Real TRooMin(
    final unit="K",
    displayUnit="degC") = 292.15
    "Room air temperature at which supply water temperature is at TSupMax";

  parameter Real k=0.1 "Gain of controller";
  parameter Modelica.Units.SI.Time Ti=120 "Time constant of integrator block";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    displayUnit="degC")
    "Room air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC")
    "Measured supply water temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final unit="1")
    "Valve control signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDRad(
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=0,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI)
    "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Line TSetSup
    "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TMinSup(
    final k=TSupMin)
    "Minimum heating supply temperature"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TMaxSup(
    final k=TSupMax)
    "Maximum heating supply temperature"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TMinRoo(
    final k=TRooMin)
    "Minimum room air temperature"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
equation
  connect(TMinSup.y,TSetSup. x2) annotation (Line(points={{-28,-30},{-20,-30},{
          -20,-4},{-12,-4}}, color={0,0,127}));
  connect(TMinSup.y,TSetSup. f2) annotation (Line(points={{-28,-30},{-20,-30},{
          -20,-8},{-12,-8}}, color={0,0,127}));
  connect(TMaxSup.y,TSetSup. f1) annotation (Line(points={{-28,30},{-24,30},{
          -24,4},{-12,4}}, color={0,0,127}));
  connect(TSetSup.x1,TMinRoo. y) annotation (Line(points={{-12,8},{-20,8},{-20,
          70},{-28,70}},      color={0,0,127}));
  connect(conPIDRad.u_s,TSetSup. y) annotation (Line(points={{38,0},{12,0}},
         color={0,0,127}));
  connect(TSetSup.u, TRoo) annotation (Line(points={{-12,0},{-70,0},{-70,60},{-120,
          60}}, color={0,0,127}));
  connect(TSup, conPIDRad.u_m)
    annotation (Line(points={{-120,-60},{50,-60},{50,-12}}, color={0,0,127}));
  connect(conPIDRad.y, yVal)
    annotation (Line(points={{62,0},{120,0},{120,0}}, color={0,0,127}));
  annotation (
  defaultComponentName="conRadSup",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,82},{-42,42}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TRoo"),
        Text(
          extent={{40,24},{88,-16}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="yVal"),
        Text(
          extent={{-92,-40},{-44,-80}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="TSup"),
        Text(
          textColor={0,0,255},
          extent={{-154,104},{146,144}},
          textString="%name"),
    Polygon(
      points={{38,0},{-24,36},{-24,-32},{38,0}},
      lineColor={0,0,0},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,
          origin={-30,2},
          rotation=360),
    Polygon(
      points={{38,0},{-24,36},{-24,-32},{38,0}},
      lineColor={0,0,0},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,
          origin={8,-36},
          rotation=90),
    Polygon(
      points={{38,0},{-24,36},{-24,-32},{38,0}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
          origin={8,40},
          rotation=270)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Controller that takes as an input the room air temperature <code>TRoo</code> and
the supply water temperature <code>TSup</code>,
and outputs the commanded mixing valve position <code>yVal</code>.
</p>
<p>
Based on the room air temperature <code>TRoo</code>, and the user adjustable parameters
for the minimum supply water temperature <code>TSupMin</code>,
the maximum supply water temperature <code>TSupMax</code>
and the room air temperature <code>TRooMin</code>
at which the supply water temperature is at <code>TSupMax</code>,
the controller computes a set point for the supply water temperature.
This set point is then used with the measured supply water temperature <code>TSup</code>
as an input to a PI-controller that computes the commanded valve position <code>yVal</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2020, by Michael Wetter:<br/>
Corrected typo in comments.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1810\">issue 1810</a>.
</li>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RadiatorSupply;

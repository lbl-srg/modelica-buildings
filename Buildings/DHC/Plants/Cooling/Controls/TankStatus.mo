within Buildings.DHC.Plants.Cooling.Controls;
block TankStatus "Returns the tank status from its temperature sensors"

  parameter Real THig(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Higher threshold to consider the tank empty";
  parameter Real TLow(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Lower threshold to consider the tank full";
  parameter Real dTHys(
    min=0.1,
    final unit="K",
    final quantity="TemperatureDifference") = 0.5
    "Deadband for hysteresis";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[2](
    each final quantity="Temperature",
    each final unit="K",
    each displayUnit="degC") "Temperatures at the tank 1: top; and 2: bottom"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[2]
    "Tank status - y[1]=true is empty; y[2] = true is charged; both false means partially charged"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysCha(
    final uLow=TLow,
    final uHigh=TLow + dTHys) "Hysteresis, tank charged"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysEmp(
    final uHigh=THig,
    final uLow=THig - dTHys) "Hysteresis, tank empty"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TTanTopChe(
    final k(final unit="K", displayUnit="degC") = THig)
    "Set point for top temperatuer of tank"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TTanBotChe(
    final k(final unit="K", displayUnit="degC") = TLow)
    "Set point for bottom temperature of tank"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
   "Test for temperature set points"
  annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message = "THig must be greater than TLow.")
   "Assertion if temperature set points are not correct"
   annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

equation
  connect(hysCha.y, not1.u)
    annotation (Line(points={{-18,0},{18,0}},  color={255,0,255}));
  connect(TTan[1],hysCha. u) annotation (Line(points={{-120,-5},{-120,0},{-42,0}},
                        color={0,0,127}));
  connect(TTan[2],hysEmp. u) annotation (Line(points={{-120,5},{-120,0},{-60,0},
          {-60,50},{-42,50}}, color={0,0,127}));
  connect(TTanTopChe.y, gre.u1) annotation (
    Line(points={{-58,-40},{-50,-40},{-50,-60},{-42,-60}},  color = {0, 0, 127}));
  connect(TTanBotChe.y, gre.u2) annotation (
    Line(points={{-58,-80},{-50,-80},{-50,-68},{-42,-68}},  color = {0, 0, 127}));
  connect(gre.y, assMes.u) annotation (Line(points={{-18,-60},{-2,-60}}, color = {255, 0, 255}));
  connect(hysEmp.y, y[1]) annotation (Line(points={{-18,50},{80,50},{80,-5},{120,
          -5}}, color={255,0,255}));
  connect(not1.y, y[2]) annotation (Line(points={{42,0},{80,0},{80,5},{120,5}},
        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,72},{40,-72}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-30,-64},{28,-28}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-30,-20},{28,16}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,54},{22,30}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
                               Diagram(coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="tanSta",
   Documentation(info="<html>
<p>
This model outputs tank status signals using the temperatures
at the CHW tank top and the tank bottom as input.
The status has two separate boolean signals indicating whether the tank is
charged or empty (of cooling). The two output signals can be both false,
indicating an in-between state, but they can never both be true.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 10, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end TankStatus;

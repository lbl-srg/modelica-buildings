within Buildings.Experimental.DHC.Plants.Cooling.Controls;
block TankStatus "Returns the tank status from its temperature sensors"

  parameter Modelica.Units.SI.Temperature THig
    "Higher threshold to consider the tank empty";
  parameter Modelica.Units.SI.Temperature TLow
    "Lower threshold to consider the tank full";

  parameter Modelica.Units.SI.TemperatureDifference dTHys(min=0.1) = 0.5
    "Deadband for hysteresis";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTan[2](
    each final quantity="Temperature",
    each final unit="K",
    each displayUnit="degC") "Temperatures at the tank 1: top; and 2: bottom"
                                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysCha(
    final uLow=TLow,
    final uHigh=TLow + dTHys) "Hysteresis, tank charged"
    annotation (Placement(visible = true, transformation(origin = {0, 50}, extent = {{-40, -60}, {-20, -40}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysEmp(
    final uHigh=THig,
    final uLow=THig - dTHys) "Hysteresis, tank empty"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not block"
    annotation (Placement(visible = true, transformation(origin = {0, 50}, extent = {{20, -60}, {40, -40}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[2]
    "Tank status - y[1]=true is empty; y[2] = true is charged; both false means partially charged"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TTanTopChe(
    final k(final unit="K", displayUnit="degC") = THig) "Set point for top temperatuer of tank"
     annotation (
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TTanBotChe(
    final k(final unit="K", displayUnit="degC") = TLow) "Set point for bottom temperature of tank"
    annotation (
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
   "Test for temperature set points"
  annotation (
    Placement(visible = true, transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message = "THig must be greater than TLow.")
   "Assertion if temperature set points are not correct"
   annotation (
    Placement(visible = true, transformation(origin = {10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(hysCha.y, not1.u)
    annotation (Line(points={{-18,0},{18,0}},  color={255,0,255}));
  connect(TTan[1],hysCha. u) annotation (Line(points={{-110,-2.5},{-52,-2.5},{-52,
          0},{-42,0}},  color={0,0,127}));
  connect(TTan[2],hysEmp. u) annotation (Line(points={{-110,2.5},{-52,2.5},{-52,
          50},{-42,50}},
                     color={0,0,127}));
  connect(hysEmp.y, y[1]) annotation (Line(points={{-18,50},{60,50},{60,0},{110,
          0},{110,-2.5}}, color={255,0,255}));
  connect(not1.y, y[2]) annotation (Line(points={{42,0},{60,0},{60,2.5},{110,
          2.5}}, color={255,0,255}));
  connect(TTanTopChe.y, gre.u1) annotation (
    Line(points = {{-58, -30}, {-50, -30}, {-50, -50}, {-42, -50}}, color = {0, 0, 127}));
  connect(TTanBotChe.y, gre.u2) annotation (
    Line(points = {{-58, -70}, {-52, -70}, {-52, -58}, {-42, -58}}, color = {0, 0, 127}));
  connect(gre.y, assMes.u) annotation (
    Line(points = {{-18, -50}, {-2, -50}}, color = {255, 0, 255}));
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

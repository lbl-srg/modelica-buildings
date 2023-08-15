within Buildings.Experimental.DHC.Plants.Cooling.Controls;
block TankStatus "Returns the tank status from its temperature sensors"

  parameter Modelica.Units.SI.Temperature THig
    "Higher threshold to consider the tank empty";
  parameter Modelica.Units.SI.Temperature TLow
    "Lower threshold to consider the tank full";

  parameter Modelica.Units.SI.TemperatureDifference dTHys( min=0.1) = 0.5
    "Deadband for hysteresis";

  Modelica.Blocks.Interfaces.RealInput TTan[2](
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
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCha(
    final uLow=TLow + dTHys,
    final uHigh=TLow + 2*dTHys) "Hysteresis, tank charged"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysEmp(
    final uHigh=THig - dTHys,
    final uLow=THig - 2*dTHys) "Hysteresis, tank empty"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Interfaces.BooleanOutput y[2]
    "Tank status - y[1]=true is empty; y[2] = true is charged; both false means partially charged"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(hysCha.y, not1.u)
    annotation (Line(points={{-18,-50},{18,-50}},
                                               color={255,0,255}));
  connect(TTan[1],hysCha. u) annotation (Line(points={{-110,-2.5},{-52,-2.5},{-52,
          -50},{-42,-50}},  color={0,0,127}));
  connect(TTan[2],hysEmp. u) annotation (Line(points={{-110,2.5},{-52,2.5},{-52,
          50},{-42,50}},
                     color={0,0,127}));
  connect(hysEmp.y, y[1]) annotation (Line(points={{-18,50},{60,50},{60,0},{110,
          0},{110,-2.5}}, color={255,0,255}));
  connect(not1.y, y[2]) annotation (Line(points={{42,-50},{60,-50},{60,2.5},{110,
          2.5}}, color={255,0,255}));
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

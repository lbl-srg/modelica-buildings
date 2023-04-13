within Buildings.Fluid.Storage.Plant.BaseClasses;
model TankStatus
  "Returns the tank status from its temperature sensors"

  parameter Modelica.Units.SI.Temperature TLow
    "Lower threshold to consider the tank full";
  parameter Modelica.Units.SI.Temperature THig
    "Higher threshold to consider the tank depleted";
  parameter Modelica.Units.SI.TemperatureDifference dTUnc = 0.1
    "Temperature sensor uncertainty";
  parameter Modelica.Units.SI.TemperatureDifference dTHys = 1
    "Deadband for hysteresis";

  Modelica.Blocks.Interfaces.RealInput TTan[2](
    each final quantity="Temperature",
    each displayUnit="C")
    "Temperatures at the tank 1: top and 2: bottom" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Modelica.Blocks.Interfaces.BooleanOutput isFul "Tank is full" annotation (
      Placement(transformation(extent={{100,50},{120,70}}), iconTransformation(
          extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput isDep "Tank is depleted" annotation (
     Placement(transformation(extent={{100,-70},{120,-50}}), iconTransformation(
          extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysFul(
    final uLow = TLow + dTUnc,
    final uHigh = hysFul.uLow + dTHys)
    "Hysteresis" annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDep(
    final uHigh = THig - dTUnc,
    final uLow=hysDep.uHigh - dTHys) "Hysteresis"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
equation
  connect(hysFul.y, not1.u)
    annotation (Line(points={{22,60},{38,60}}, color={255,0,255}));
  connect(not1.y, isFul)
    annotation (Line(points={{62,60},{110,60}}, color={255,0,255}));
  connect(hysDep.y, isDep)
    annotation (Line(points={{22,-60},{110,-60}}, color={255,0,255}));
  connect(TTan[1], hysFul.u) annotation (Line(points={{-110,-2.5},{-12,-2.5},{
          -12,60},{-2,60}}, color={0,0,127}));
  connect(TTan[2], hysDep.u) annotation (Line(points={{-110,2.5},{-12,2.5},{-12,
          -60},{-2,-60}},
                     color={0,0,127}));
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
The status has two separate boolean signals indicating whether the tank is full
or depleted. The tank can be neither full nor depleted, but never both.
</p>
<p>
The CHW tank is considered full when the temperature at the bottom goes below
<i>T<sub>Low</sub> + &Delta; T<sub>Unc</sub></i> where
<i>T<sub>Low</sub></i> is the user-determined lower threshold and
<i>&Delta; T<sub>Unc</sub></i> is the sensor uncertainty.
This signal is reset when the the bottom temperature goes above
<i>T<sub>Low</sub> + &Delta; T<sub>Unc</sub> + &Delta; T<sub>Hys</sub></i>
where <i>&Delta; T<sub>Hys</sub></i> is the hysteresis deadband.
The tank being depleted is determined similarly.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 15, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end TankStatus;

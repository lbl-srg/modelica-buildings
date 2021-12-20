within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Validation;
model CoolingCoil "Validation of cooling coil model"
  final parameter Real TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Supply air temperature setpoint";
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil cooCoi(
      controllerTypeCooCoi=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      kCooCoi=1)
      "Cooling coil controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.Sources.Ramp TSup(
    final height=4,
    final offset=TSupSet - 2,
    final duration=3600*8)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Continuous.Sources.Constant TSupSetSig(
    final k=TSupSet)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  CDL.Logical.Sources.Constant fanStatus(k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Continuous.Sources.Pulse zonSta(
    offset=2,
    period=3600*2)
    "Zone state"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  CDL.Conversions.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{-48,-30},{-28,-10}})));
equation
  connect(TSup.y, cooCoi.TSup) annotation (Line(points={{-58,30},{-40,30},{-40,4},
          {-12,4}},      color={0,0,127}));
  connect(TSupSetSig.y, cooCoi.TSupCoo) annotation (Line(points={{-58,70},{-36,70},
          {-36,8},{-12,8}},     color={0,0,127}));
  connect(fanStatus.y, cooCoi.uSupFan) annotation (Line(points={{-58,-50},{-20,-50},
          {-20,-8},{-12,-8}},      color={255,0,255}));
  connect(zonSta.y, reaToInt.u)
    annotation (Line(points={{-58,-20},{-50,-20}},
                                                 color={0,0,127}));
  connect(reaToInt.y, cooCoi.uZonSta) annotation (Line(points={{-26,-20},{-24,-20},
          {-24,-4},{-12,-4}},
                            color={255,127,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=28000,
      Interval=600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Validation/CoolingCoil.mos"
    "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoil;

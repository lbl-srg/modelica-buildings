within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model HeatingCoolingControlLoops_TRoo
  "Validation model for heating and cooling coil control signal generator"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TRooCooSet=25 + 273.15 "Cooling zone temperature setpoint";
  parameter Modelica.SIunits.Temperature TRooHeaSet=20 + 273.15 "Heating zone temperature setpoint";

  CDL.Continuous.Sources.Constant TRooCooSetSig(k=TRooCooSet) "Cooling zone temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  CDL.Continuous.Sources.Constant TRooHeaSetSig(k=TRooHeaSet) "Heating zone temperature setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.Ramp TRoo(
    final duration=900,
    final offset=TRooHeaSet - 5,
    final height=TRooCooSet - TRooHeaSet + 10) "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  HeatingCoolingControlLoops conLoo
    "Heating and cooling control loop signal generator"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(TRooCooSetSig.y, conLoo.TRooCooSet)
    annotation (Line(points={{-19,0},{0,0},{0,2},{19,2}}, color={0,0,127}));
  connect(TRooHeaSetSig.y, conLoo.TRooHeaSet)
    annotation (Line(points={{-19,40},{0,40},{0,6},{19,6}}, color={0,0,127}));
  connect(TRoo.y, conLoo.TRoo)
    annotation (Line(points={{-19,-40},{0,-40},{0,-4},{19,-4}}, color={0,0,127}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/HeatingCoolingControlLoops_TRoo.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.HeatingCoolingControlLoops\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.HeatingCoolingControlLoops</a>
for zone temperature (<code>TRoo</code>) signal under fixed zone cooling (<code>TRooCooSet</code>) 
and heating (<code>TRooHeaSet</code>) temperature 
setpoints.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoolingControlLoops_TRoo;

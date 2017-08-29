within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model HeatingCoolingControlLoops_LoopDisable
  "Validation model for heating and cooling coil control signal generator"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TRooCooSet = 25 + 273.15 "Cooling zone temperature setpoint";
  parameter Modelica.SIunits.Temperature TRooHeaSet = 20 + 273.15 "Heating zone temperature setpoint";
  parameter Modelica.SIunits.Temperature TRooDea = (TRooHeaSet + TRooCooSet)/2
    "Measured zone air temperature is in deadband";

  CDL.Continuous.Sources.Constant TRooCooSetSig(final k=TRooCooSet)
    "Cooling zone temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  CDL.Continuous.Sources.Constant TRooHeaSetSig(final k=TRooHeaSet)
    "Heating zone temperature setpoint"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.Ramp TRoo(
    final duration=900,
    final offset=TRooHeaSet - 5,
    final height=TRooCooSet - TRooHeaSet + 10) "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  HeatingCoolingControlLoops conLoo(final intWin=true)
    "Heating and cooling control loop signal generator"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Continuous.Sources.Constant TRooCooSetSig1(final k=TRooCooSet)
    "Cooling zone temperature setpoint"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Continuous.Sources.Constant TRooHeaSetSig1(final k=TRooHeaSet)
    "Heating zone temperature setpoint"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  HeatingCoolingControlLoops conLoo1
    "Heating and cooling control loop signal generator"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  CDL.Continuous.Sources.Constant TRoo1(k=TRooDea)
    "Measured zone air temperature is in deadband"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

equation
  connect(TRooCooSetSig.y, conLoo.TRooCooSet)
    annotation (Line(points={{-99,0},{-80,0},{-80,2},{-61,2}},color={0,0,127}));
  connect(TRooHeaSetSig.y, conLoo.TRooHeaSet)
    annotation (Line(points={{-99,40},{-80,40},{-80,6},{-61,6}},color={0,0,127}));
  connect(TRoo.y, conLoo.TRoo)
    annotation (Line(points={{-99,-40},{-80,-40},{-80,-4},{-61,-4}},color={0,0,127}));
  connect(TRooCooSetSig1.y, conLoo1.TRooCooSet)
    annotation (Line(points={{1,0},{20,0},{20,2},{39,2}}, color={0,0,127}));
  connect(TRooHeaSetSig1.y, conLoo1.TRooHeaSet)
    annotation (Line(points={{1,40},{20,40},{20,6},{39,6}}, color={0,0,127}));
  connect(TRoo1.y, conLoo1.TRoo) annotation (Line(points={{1,-40},{20,-40},{20,-4},{39,-4}}, color={0,0,127}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/HeatingCoolingControlLoops_LoopDisable.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{200,100}})),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.HeatingCoolingControlLoops\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.HeatingCoolingControlLoops</a>
loop disable conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
Aug 25, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoolingControlLoops_LoopDisable;

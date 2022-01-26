within Buildings.Experimental.DHC.Plants.Cooling.Controls.Validation;
model ChilledWaterPumpSpeed
  "Example to test the chilled water pump speed controller"
  extends Modelica.Icons.Example;
  Buildings.Experimental.DHC.Plants.Cooling.Controls.ChilledWaterPumpSpeed chiWatPumSpe(
    dpSetPoi=68900,
    tWai=30,
    m_flow_nominal=0.5,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=60,
    Td=0.1)
    "Chilled water pump speed controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Pulse mFloTot(
    amplitude=0.4*chiWatPumSpe.m_flow_nominal,
    period=300,
    offset=0.5*chiWatPumSpe.m_flow_nominal,
    startTime=150)
    "Total chilled water mass flow rate"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant dpMea(
    k=0.6*chiWatPumSpe.dpSetPoi)
    "Measured demand side pressure difference"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(dpMea.y,chiWatPumSpe.dpMea)
    annotation (Line(points={{-39,-30},{-30,-30},{-30,-4},{-12,-4}},
      color={0,0,127}));
  connect(mFloTot.y,chiWatPumSpe.masFloPum)
    annotation (Line(points={{-39,30},{-30,30},{-30,4},{-12,4}},
      color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    experiment(
      StopTime=1200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Cooling/Controls/Validation/ChilledWaterPumpSpeed.mos"
      "Simulate and Plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model validates the variable speed pump control logic implemented in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.Controls.ChilledWaterPumpSpeed\">
Buildings.Experimental.DHC.Plants.Cooling.Controls.ChilledWaterPumpSpeed</a>.
</p>
</html>"));
end ChilledWaterPumpSpeed;

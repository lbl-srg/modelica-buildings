within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model PrimaryPumpsController "Constant speed primary pumps controller validation."

  Control.PrimaryPumpsConstantSpeed pumCon
    "Primary pumps(ETS side) controller"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.BooleanPulse reqHea(
    width=50, period=200)
    "Heating is required step signal."
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
  Modelica.Blocks.Sources.BooleanPulse reqCoo(
    width=50,
    period=250,
    startTime=100)
    "Cooling is required step signal."
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(pumCon.reqHea, reqHea.y)
   annotation (Line(points={{18.6,20},{0,20},{0,
          32},{-19,32}}, color={255,0,255}));
  connect(pumCon.reqCoo, reqCoo.y)
   annotation (Line(points={{18.6,0.2},{0,0.2},{
          0,-10},{-19,-10}}, color={255,0,255}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}}),
    graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Line(points={{-22,22}}, color={28,108,200})}),
        experiment(StopTime=300,Tolerance=1e-06,__Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/PrimaryPumpsController.mos"
        "Simulate and plot"),
 Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed\">
Buildings.Applications.DHC.EnergyTransferStations.Control.PrimaryPumpsConstantSpeed</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 20, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrimaryPumpsController;

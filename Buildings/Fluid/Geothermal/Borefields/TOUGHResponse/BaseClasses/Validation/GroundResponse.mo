within Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.Validation;
model GroundResponse
  "Validation ground response function with python as interface with TOUGH"

  Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.GroundResponse
    touRes "Ground response calculated by TOUGH simulator"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[10](
    final k={273.15+10,273.15+10.2,273.15+10.4,273.15+10.6,273.15+10.8,
             273.15+11.0,273.15+11.2,273.15+11.4,273.15+11.6,273.15+11.8})
    "Initial borehole wall temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin [10](
    each amplitude=1000,
    each freqHz=1/3600) "Heat flow to ground"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outTem(
    final k=273.15 + 20)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(sin.y, touRes.QBor_flow)
    annotation (Line(points={{-38,50},{0,50},{0,6},{39,6}}, color={0,0,127}));
  connect(con.y, touRes.TBorWal_start)
    annotation (Line(points={{-38,0},{39,0}}, color={0,0,127}));
  connect(outTem.y, touRes.TOut) annotation (Line(points={{-38,-50},{0,-50},{0,
          -6},{39,-6}}, color={0,0,127}));
annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/TOUGHResponse/BaseClasses/Validation/GroundResponse.mos"
        "Simulate and plot"),
  experiment(StopTime=3600,Tolerance=1e-6),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model demonstrates the calculation of ground response through TOUGH simulator,
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.GroundResponse\">
Buildings.Fluid.Geothermal.Borefields.TOUGHResponse.BaseClasses.GroundResponse</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundResponse;

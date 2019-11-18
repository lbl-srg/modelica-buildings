within Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.Validation;
model ResponsePython
  "Validation ground response function with python as interface with TOUGH"

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.ResponsePython
    toughRes annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[10](
    final k={273.15+10,273.15+10.2,273.15+10.4,273.15+10.6,273.15+10.8,
             273.15+11.0,273.15+11.2,273.15+11.4,273.15+11.6,273.15+11.8})
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[10](
    each final k=1000)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  connect(con1.y, toughRes.QBor_flow)
    annotation (Line(points={{-38,30},{0,30},{0,6},{39,6}}, color={0,0,127}));
  connect(con.y, toughRes.TBorWal_start) annotation (Line(points={{-38,-30},{0,-30},
          {0,-6},{39,-6}}, color={0,0,127}));

annotation (
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
    experiment(StopTime=3600));
end ResponsePython;

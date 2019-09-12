within Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.Validation;
model Response
  Buildings.Fluid.Geothermal.Borefields.BaseClasses.GroundResponse.Response
    response(nSeg=2, steadyStateInitial=false)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp heaFlo(height=2000, duration=3600)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=273.15 + 10)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp heaFlo1(height=5000, duration=3600)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con1(k=273.15 + 12)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(heaFlo.y, response.QBor_flow[1]) annotation (Line(points={{-38,70},{
          40,70},{40,15.5},{59,15.5}}, color={0,0,127}));
  connect(heaFlo1.y, response.QBor_flow[2]) annotation (Line(points={{-38,30},{
          20,30},{20,16.5},{59,16.5}}, color={0,0,127}));
  connect(con.y, response.TExt_start[1]) annotation (Line(points={{-38,-20},{20,
          -20},{20,3.5},{59,3.5}}, color={0,0,127}));
  connect(con1.y, response.TExt_start[2]) annotation (Line(points={{-38,-60},{
          40,-60},{40,4.5},{59,4.5}}, color={0,0,127}));
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
end Response;

within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Configurator_uChiAva
  "Validate stage capacities sequence for chiller stage inputs"

  Configurator conf(
    nSta=4,
    nChi=3,
    staMat={{1,0,0},{1,1,0},{0,1,1},{1,1,1}},
    chiTyp={1,1,2},
    chiNomCap={10,20,10},
    chiMinCap={1,2,2})
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva[3](final k={true,
        true,true}) "Chiller availability array"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

equation
  connect(chiAva.y, conf.uChiAva) annotation (Line(points={{-39,10},{-20,10},{
          -20,16},{38,16}}, color={255,0,255}));
annotation (
 experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uSta.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Configurator_uChiAva;

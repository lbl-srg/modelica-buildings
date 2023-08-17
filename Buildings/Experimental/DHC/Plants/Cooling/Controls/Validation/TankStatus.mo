within Buildings.Experimental.DHC.Plants.Cooling.Controls.Validation;
model TankStatus "Validation model for TankStatus"
  extends Modelica.Icons.Example;
  Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus tanSta(
    TLow=280.15,
    THig=286.15,
    dTHys=1) "Tank Status"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.TimeTable TTanBot(table=[0,273.15 + 11; 0.25,273.15 +
        13.5; 0.5,273.15 + 12.5; 0.75,273.15 + 13.5; 1,273.15 + 11])
    "Temperature at tank bottom"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.TimeTable TTanTop(table=[0,273.15 + 9; 0.25,273.15 + 6.5;
        0.5,273.15 + 7.5; 0.75,273.15 + 6.5; 1,273.15 + 9])
    "Temperature at tank top"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(TTanTop.y, tanSta.TTan[1]) annotation (Line(points={{-39,30},{-6,30},{
          -6,9.75},{-1,9.75}}, color={0,0,127}));
  connect(TTanBot.y, tanSta.TTan[2]) annotation (Line(points={{-39,-10},{-6,-10},
          {-6,10.25},{-1,10.25}}, color={0,0,127}));
          annotation(experiment(Tolerance=1e-6, StopTime=1),
          __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Cooling/Controls/Validation/TankStatus.mos"
      "Simulate and Plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
August 11, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus\">
Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus</a>.
Note that the output signals turn true as soon as their respective temperature
input crosses the threshold, but there is a delay for it to turn back false
due to hysteresis.
</p>
</html>"));
end TankStatus;

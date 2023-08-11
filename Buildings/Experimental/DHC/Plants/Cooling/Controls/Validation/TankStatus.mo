within Buildings.Experimental.DHC.Plants.Cooling.Controls.Validation;
model TankStatus "Validation model for TankStatus"
  extends Modelica.Icons.Example;
  Buildings.Experimental.DHC.Plants.Cooling.Controls.TankStatus tanSta(
    TLow=280.15,
    THig=286.15,
    dTHys=0.5)
             "Tank Status"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1.5,
    f=0.3,
    offset=273.15 + 10)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TTanTop(p=-1.5,
    y(unit="K"))
    "Temperature at tank top"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter TTanBot(p=1.5,
    y(unit="K"))
    "Temperature at tank bottom"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(sine.y, TTanTop.u) annotation (Line(points={{-59,10},{-52,10},{-52,30},
          {-42,30}}, color={0,0,127}));
  connect(sine.y, TTanBot.u) annotation (Line(points={{-59,10},{-52,10},{-52,-10},
          {-42,-10}}, color={0,0,127}));
  connect(TTanTop.y, tanSta.TTan[1]) annotation (Line(points={{-18,30},{-6,30},{
          -6,9.75},{-1,9.75}}, color={0,0,127}));
  connect(TTanBot.y, tanSta.TTan[2]) annotation (Line(points={{-18,-10},{-6,-10},
          {-6,10.25},{-1,10.25}},
                            color={0,0,127}));
          annotation(experiment(Tolerance=1e-6, StopTime=10),
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
</p>
</html>"));
end TankStatus;

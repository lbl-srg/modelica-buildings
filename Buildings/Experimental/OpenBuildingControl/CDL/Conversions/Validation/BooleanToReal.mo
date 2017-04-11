within Buildings.Experimental.OpenBuildingControl.CDL.Conversions.Validation;
model BooleanToReal "Validation model for the BooleanToReal block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Conversions.BooleanToReal booToRea
    "Block that convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc
    "Generate output cyclc on and off"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant const(k=50)
    "Percentage of the cycle ON time"
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));

equation
  connect(const.y, dutCyc.u)
    annotation (Line(points={{-43,0},{-32,0},{-22,0}}, color={0,0,127}));
  connect(dutCyc.y, booToRea.u)
    annotation (Line(points={{1,0},{28,0},{28,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=4.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Conversions/Validation/BooleanToReal.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Conversions.BooleanToReal\">
Buildings.Experimental.OpenBuildingControl.CDL.Conversions.BooleanToReal</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation..
</li>
</ul>

</html>"));
end BooleanToReal;

within Buildings.Fluid.Sources.Validation;
model BoundaryWithX_in
  "Validation model for boundary with different media and mass fraction input"
  extends Modelica.Icons.Example;

  Buildings.Fluid.Sources.Validation.BaseClasses.BoundarySystemWithX_in bouMoiAir(
    redeclare package Medium = Buildings.Media.Air)
    "Boundary with moist air"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Fluid.Sources.Validation.BaseClasses.BoundarySystemWithX_in bouMoiAirCO2(
    redeclare package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}))
    "Boundary with moist air"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Fluid.Sources.Validation.BaseClasses.BoundarySystemWithX_in bouProFluGas(
   redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents)
    "Boundary with flue gas"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Fluid.Sources.Validation.BaseClasses.BoundarySystemWithX_in bouNatGas(
    redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas)
    "Boundary with natural gas"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Modelica.Blocks.Sources.Constant X_2[2](k={0.015, 0.985})
    "Prescribed mass fraction"
    annotation (Placement(transformation(extent={{-20,66},{0,86}})));
  Modelica.Blocks.Sources.Constant X_6[6](k={0.5,0.2,0.0,0.3,0.0,0.0})
    "Prescribed mass fraction"
    annotation (Placement(transformation(extent={{-20,-14},{0,6}})));

equation
  connect(X_6.y, bouProFluGas.X_in)
    annotation (Line(points={{1,-4},{10,-4},{10,0},{18,0}}, color={0,0,127}));
  connect(X_2.y, bouMoiAir.X_in) annotation (Line(points={{1,76},{10,76},{10,80},
          {18,80}}, color={0,0,127}));
  connect(X_6.y, bouNatGas.X_in) annotation (Line(points={{1,-4},{10,-4},{10,-40},
          {18,-40}}, color={0,0,127}));
  connect(X_2.y, bouMoiAirCO2.X_in) annotation (Line(points={{1,76},{10,76},{10,
          40},{18,40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Validation model for <a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>
for different media and with mass fraction <code>X</code> prescribed by an input.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2019 by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">Buildings, #1205</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Sources/Validation/BoundaryWithX_in.mos"
        "Simulate and plot"),
experiment(
      StopTime=1,
      Tolerance=1e-06));
end BoundaryWithX_in;

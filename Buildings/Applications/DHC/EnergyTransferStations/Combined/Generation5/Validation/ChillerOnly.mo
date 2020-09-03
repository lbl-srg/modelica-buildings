within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerOnly
  "Validation of the ETS model with heat recovery chiller"
  extends BaseClasses.PartialChillerBorefield;

  Modelica.Blocks.Sources.CombiTimeTable loaRat(
    tableName="tab1",
    table=[0,0,0; 5,0,0; 6,0,1; 10,0.5,0.5; 12,0.5,0.6; 13,0.7,0; 16,0.4,0.4; 17,
        0,0.1; 21,0,0],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={0,0},
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-288,160},{-268,180}})));
equation
  connect(loaRat.y[2], heaLoaNor.u) annotation (Line(points={{-267,170},{-260,170},
          {-260,60},{-252,60}}, color={0,0,127}));
  connect(loaRat.y[1], loaCooNor.u) annotation (Line(points={{-267,170},{280,170},
          {280,60},{272,60}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerOnly.mos"
"Simulate and plot"),
  experiment(
      StopTime=172800,
      Tolerance=1e-06),
  Documentation(
revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield</a>
in a system configuration with no geothermal borefield.
</p>
<ul>
<li>
A fictitious load profile is used.
</li>
<li>
The district water supply temperature is constant.
</li>
<li>
The building distribution pumps are variable speed and the flow rate
is considered to vary linearly with the load (with no inferior limit).
</li>
<li>
The Boolean enable signals for heating and cooling typically provided
by the building automation system are here computed
as false if the load if lower than 1% of the nominal load for more than 300s.
</li>
<li>
Simplified chiller performance data are used, which only represent a linear
variation of the EIR with the evaporator outlet temperature and the
condenser inlet temperature (the capacity is fixed and
no variation of the performance at part load is considered).
</li>
</ul>
</html>"));
end ChillerOnly;

within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerOnly
  "Validation of the ETS model with heat recovery chiller"
  extends BaseClasses.PartialChillerBorefield(
    ets(
      Ti=120));
  Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
    tableName="tab1",
    table=[
      0,11;
      49,11;
      50,20;
      100,20],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600,
    offset={273.15},
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-330,-150},{-310,-130}})));
equation
  connect(TDisWatSup.y[1],disWat.T_in)
    annotation (Line(points={{-309,-140},{-140,-140},{-140,-136},{-122,-136}},color={0,0,127}));
  connect(loa.y[2],heaLoaNor.u)
    annotation (Line(points={{-309,160},{-300,160},{-300,60},{-252,60}},color={0,0,127}));
  connect(loa.y[1],loaCooNor.u)
    annotation (Line(points={{-309,160},{280,160},{280,60},{272,60}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerOnly.mos" "Simulate and plot"),
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
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield</a>
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
as falseif the load is lower than 1% of the nominal load for more than 300s.
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

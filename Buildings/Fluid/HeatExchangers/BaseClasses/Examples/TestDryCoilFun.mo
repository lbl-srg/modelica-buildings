within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model TestDryCoilFun
  "Validate dryCoilFun versus text-book example"
  extends Modelica.Icons.Example;

  // PARAMETERS
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration cfg=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed
    "The configuration of the heat exchanger";
  // - water
  parameter Modelica.SIunits.ThermalConductance UAWat=
    1.67225472 * 5678.2633411134878
    "UA for water side";
  parameter Modelica.SIunits.MassFlowRate masFloWat = 3.7799364166666667
    "Mass flow rate for water";
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat = 4199.3603999999999999
    "Specific heat capacity of water";
  parameter Modelica.SIunits.Temperature TWatIn=
    Modelica.SIunits.Conversions.from_degF(42)
    "Water temperature at inlet";
  // -- air
  parameter Modelica.SIunits.ThermalConductance UAAir=
    33.4450944 * 283.91316705567439
    "UA for air side";
  parameter Modelica.SIunits.MassFlowRate masFloAir = 2.6459554916666667
    "Mass flow rate of air";
  parameter Modelica.SIunits.SpecificHeatCapacity cpAir = 1021.5792
    "Specific heat capacity of moist air at constant pressure";
  parameter Modelica.SIunits.Temperature TAirIn=
    Modelica.SIunits.Conversions.from_degF(80)
    "Temperature of air at inlet";

  // VARIABLES
  Modelica.SIunits.HeatFlowRate Q
    "Heat transferred from 'water' to 'air'";
  Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  Modelica.SIunits.Temperature TSurAirOut
    "Temperature at the coil surface on the air side at outlet.
    Braun 1988, eqn 4.1.10";
  Real NtuWat
    "Ntu for water side, Braun 1988 eqn 4.1.5";
  Real NtuAir
    "Ntu for air side, Braun 1988 eqn 4.1.6";
  Real NtuDry
    "Overall number of transfer units for the dry coil,
    Braun 1988, eq 4.1.7";
  Real CSta
    "capacitance rate ratio (C*)";

equation
  (Q, TWatOut, TAirOut, TSurAirOut, NtuWat, NtuAir, NtuDry, CSta) =
    Buildings.Fluid.HeatExchangers.BaseClasses.dryCoil(
      UAWat = UAWat,
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = TWatIn,
      UAAir = UAAir,
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = TAirIn,
      cfg=cfg);
  annotation (
    experiment(StopTime = 1.0),
    __Dymola_Commands__Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/TestDryCoilFun.mos"
      "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestDryCoilFun;

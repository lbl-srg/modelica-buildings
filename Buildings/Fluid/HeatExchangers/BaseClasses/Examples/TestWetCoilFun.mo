within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model TestWetCoilFun "Validate wetCoilFun versus text-book example"
  extends Modelica.Icons.Example;

  // PACKAGES
  replaceable package MedAir = Buildings.Media.Air;

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
  parameter Modelica.SIunits.Pressure pAir = 101325
    "Pressure on air-side of coil";
  parameter Modelica.SIunits.MassFraction wAirIn = 0.0089757
    "Mass fraction of water in moist air at inlet";
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn=
    MedAir.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={wAirIn,1-wAirIn})
    "Specific enthalpy of air at inlet conditions";

  // VARIABLES
  Modelica.SIunits.HeatFlowRate QTot
    "Total heat flow from 'air' into 'water' stream";
  Modelica.SIunits.HeatFlowRate QSen
    "Sensible heat flow from 'water' into 'air' stream";
  Modelica.SIunits.Temperature TWatOut(start=TWatIn+1)
    "Temperature of water at outlet";
  Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  Modelica.SIunits.Temperature TSurAirIn
    "Surface temperature of the coil at inlet, Braun 1988, eq 4.1.22";
  Modelica.SIunits.MassFlowRate masFloCon
    "The amount of condensate removed from 'air' stream";
  Modelica.SIunits.Temperature TCon
    "Temperature of the condensate removed from airstream";

equation
  (QTot, QSen, TWatOut, TAirOut, TSurAirIn, masFloCon, TCon) =
    Buildings.Fluid.HeatExchangers.BaseClasses.wetCoilFun(
      UAWat = UAWat,
      masFloWat = masFloWat,
      cpWat = cpWat,
      TWatIn = TWatIn,
      TWatOutGuess = TWatOut,
      UAAir = UAAir,
      masFloAir = masFloAir,
      cpAir = cpAir,
      TAirIn = TAirIn,
      pAir = pAir,
      wAirIn = wAirIn,
      hAirIn = hAirIn,
      cfg=cfg);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestWetCoilFun;

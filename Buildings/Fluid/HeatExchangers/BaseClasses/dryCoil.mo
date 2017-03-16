within Buildings.Fluid.HeatExchangers.BaseClasses;
function dryCoil
  "Dry Coil effectiveness-NTU Calculations"

  // INPUTS
  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Modelica.SIunits.MassFlowRate masFloWat
    "Mass flow rate for water";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  // -- air
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate masFloAir
    "Mass flow rate of air";
  input Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of moist air at constant pressure";
  input Modelica.SIunits.Temperature TAirIn
    "Temperature of air at inlet";
  // -- misc.
  input Buildings.Fluid.Types.HeatExchangerConfiguration cfg
    "The configuration of the heat exchanger";

  // OUTPUTS
  output Modelica.SIunits.HeatFlowRate Q
    "Heat transferred from 'water' to 'air'";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  output Modelica.SIunits.Temperature TSurAirOut
    "Temperature at the coil surface on the air side at outlet.
    Braun 1988, eqn 4.1.10";
  output Real NtuWat
    "Ntu for water side, Braun 1988 eqn 4.1.5";
  output Real NtuAir
    "Ntu for air side, Braun 1988 eqn 4.1.6";
  output Real NtuDry
    "Overall number of transfer units for the dry coil,
    Braun 1988, eq 4.1.7";
  output Real CSta
    "capacitance rate ratio (C*)";

protected
  Real eff
    "Effectiveness for heat exchanger";
  Real CWat
    "Capacitance rate of water";
  Real CAir
    "Capacitance rate of air";
  Real CMin
    "minimum capacity rate";
  Real CMax
    "maximum capacity rate";
  Modelica.SIunits.ThermalResistance ResAir
    "Thermal resistance on the air side including fins";
  Modelica.SIunits.ThermalResistance ResWat
    "Thermal resistance on the water side including metal of coil";
  Modelica.SIunits.ThermalResistance ResTot
    "Total resistance between air and water";
  Modelica.SIunits.ThermalConductance UA
    "Overall heat transfer coefficient";
  Real Ntu
    "dry coil number of transfer units";

algorithm
  if masFloAir < 1e-4 or masFloWat < 1e-4
    or UAAir < 1e-4 or UAWat < 1e-4 then
    // No mass flow so no heat transfer
    Q := 0;
    TWatOut := TWatIn;
    TAirOut := TAirIn;
    TSurAirOut := (TWatIn + TAirIn) / 2;
    NtuAir := 0;
    NtuWat := 0;
    NtuDry := 0;
  else
    CWat := masFloWat * cpWat;
    CAir := masFloAir * cpAir;
    CMin := min(CWat, CAir);
    CMax := max(CWat, CAir);
    CSta := CMin/CMax "Braun 1988 eq 4.1.10";
    ResAir := 1/UAAir;
    ResWat := 1/UAWat;
    ResTot := ResAir + ResWat;
    UA := 1/ResTot "UA is for the overall coil (i.e., both sides)";
    Ntu := UA/CMin;
    eff := effCalc(CSta=CSta, Ntu=Ntu, cfg=cfg);
    Q := eff * CMin * (TWatIn - TAirIn)
      "Note: positive heat transfer is water to air";
    TAirOut := TAirIn - eff * (TAirIn - TWatIn)
      "Braun 1988 eq 4.1.8";
    TWatOut := TWatIn + CSta * (TAirIn - TAirOut)
      "Braun 1988 eq 4.1.9";
    NtuAir := UAAir / (masFloAir * cpAir)
      "Braun 1988, eq 4.1.6, called Ntu_o in the text";
    NtuWat := UAWat / (masFloWat * cpWat)
      "Braun 1988, eq 4.1.5, called Ntu_i in the text";
    NtuDry := NtuAir / (1 + CSta * (NtuAir / NtuWat))
      "Braun 1988, eq 4.1.7";
    TSurAirOut := TWatIn + ((CSta * NtuDry * (TAirOut - TWatIn)) / NtuWat)
      "Braun 1988, eq 4.1.10, calculation for T_s,o";
  end if;
end dryCoil;

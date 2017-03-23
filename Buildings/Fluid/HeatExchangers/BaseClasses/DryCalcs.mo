within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryCalcs
  "Dry coil calculations for effectiveness-NTU model"

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
  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
    "The flow regime of the heat exchanger";

  output Modelica.SIunits.HeatFlowRate Q
    "Heat transferred from 'water' to 'air'";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";

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
  Real Z
    "capacitance rate ratio (C*)";
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

equation
  if noEvent(masFloAir < 1e-4 or masFloWat < 1e-4
    or UAAir < 1e-4 or UAWat < 1e-4) then
    // No mass flow so no heat transfer
    Q = 0;
    TWatOut = TWatIn;
    TAirOut = TAirIn;
    eff = 0;
    CWat = 0;
    CAir = 0;
    CMin = 0;
    CMax = 0;
    Z = 0;
    ResAir = 0;
    ResWat = 0;
    ResTot = 0;
    UA = 0;
    Ntu = 0;
  else
    CWat = masFloWat * cpWat;
    CAir = masFloAir * cpAir;
    CMin = min(CWat, CAir);
    CMax = max(CWat, CAir);
    ResAir = 1 / UAAir;
    ResWat = 1 / UAWat;
    ResTot = ResAir + ResWat;
    UA = 1/ResTot "UA is for the overall coil (i.e., both sides)";
    Z = CMin / CMax "Braun 1988 eq 4.1.10";
    Ntu = UA/CMin;
    eff = epsilon_ntuZ(
      Z = Z,
      NTU = Ntu,
      flowRegime = Integer(cfg));
    Q = eff * CMin * (TWatIn - TAirIn)
      "Note: positive heat transfer is water to air";
    TAirOut = TAirIn - eff * (TAirIn - TWatIn)
      "Braun 1988 eq 4.1.8";
    TWatOut = TWatIn + Z * (TAirIn - TAirOut)
      "Braun 1988 eq 4.1.9";
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DryCalcs;

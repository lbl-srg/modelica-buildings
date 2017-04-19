within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryCalcs
  "Dry coil calculations for effectiveness-NTU model"

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  // -- air
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate mAir_flow
    "Mass flow rate of air";
  input Modelica.SIunits.SpecificHeatCapacity cpAir
    "Specific heat capacity of moist air at constant pressure";
  input Modelica.SIunits.Temperature TAirIn
    "Temperature of air at inlet";
  // -- misc.
  input Buildings.Fluid.Types.HeatExchangerFlowRegime cfg
    "The flow regime of the heat exchanger";

  output Modelica.SIunits.HeatFlowRate Q_flow
    "Heat transferred from water to air";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";

  Real eff(min=0, max=1, unit="1")
    "Effectiveness for heat exchanger";
  Modelica.SIunits.ThermalConductance CWat_flow
    "Capacitance rate of water";
  Modelica.SIunits.ThermalConductance CAir_flow
    "Capacitance rate of air";
  Modelica.SIunits.ThermalConductance CMin_flow
    "minimum capacity rate";
  Modelica.SIunits.ThermalConductance CMax_flow
    "maximum capacity rate";
  Real Z(unit="1")
    "capacitance rate ratio (C*)";
  Modelica.SIunits.ThermalResistance resAir
    "Thermal resistance on the air side including fins";
  Modelica.SIunits.ThermalResistance resWat
    "Thermal resistance on the water side including metal of coil";
  Modelica.SIunits.ThermalResistance resTot
    "Total resistance between air and water";
  Modelica.SIunits.ThermalConductance UA
    "Overall heat transfer coefficient";
  Real NTU
    "Dry coil number of transfer units";

equation
    // fixme: check condition
  if noEvent(mAir_flow < 1e-4 or mWat_flow < 1e-4
    or UAAir < 1e-4 or UAWat < 1e-4) then
    // No mass flow so no heat transfer
    Q_flow = 0;
    TWatOut = TWatIn;
    TAirOut = TAirIn;
    eff = 0;
    CWat_flow = 0;
    CAir_flow = 0;
    CMin_flow = 0;
    CMax_flow = 0;
    Z = 0;
    resAir = 0;
    resWat = 0;
    resTot = 0;
    UA = 0;
    NTU = 0;
  else
    CWat_flow = mWat_flow * cpWat;
    CAir_flow = mAir_flow * cpAir;
    CMin_flow = min(CWat_flow, CAir_flow);
    CMax_flow = max(CWat_flow, CAir_flow);
    resAir = 1 / UAAir;
    resWat = 1 / UAWat;
    resTot = resAir + resWat;
    UA = 1/resTot "UA is for the overall coil (i.e., both sides)";
    Z = CMin_flow / CMax_flow "Braun 1988 eq 4.1.10";
    NTU = UA/CMin_flow;
    eff = epsilon_ntuZ(
      Z = Z,
      NTU = NTU,
      flowRegime = Integer(cfg));
    Q_flow = eff * CMin_flow * (TWatIn - TAirIn)
      "Note: positive heat transfer is air to water";
    TAirOut = TAirIn + eff * (TWatIn - TAirIn)
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
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
April 14, 2017, by Michael Wetter:<br/>
Changed sign of heat transfer so that sensible and total heat transfer
have the same sign.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>", info="<html>
<p>
This model implements the calculation for a 100% dry coil.
</p>

<p>
Extensive documentation can be found in the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
WetEffectivenessNTU</a> model.
</p>
</html>"));
end DryCalcs;

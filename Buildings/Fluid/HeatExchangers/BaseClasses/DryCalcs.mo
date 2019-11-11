within Buildings.Fluid.HeatExchangers.BaseClasses;
model DryCalcs
  "Dry coil calculations for effectiveness-NTU model"

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
  input Real fraHex(min=0, max=1)
    "Fraction of heat exchanger to which UA is to be applied";
  input Modelica.SIunits.MassFlowRate mWat_flow
    "Mass flow rate for water";
  input Modelica.SIunits.MassFlowRate mWatNonZer_flow(min=Modelica.Constants.eps)
    "Mass flow rate for water, bounded away from zero";

  input Modelica.SIunits.SpecificHeatCapacity cpWat
    "Specific heat capacity of water";
  input Modelica.SIunits.Temperature TWatIn
    "Water temperature at inlet";
  // -- air
  input Modelica.SIunits.ThermalConductance UAAir
    "UA for air side";
  input Modelica.SIunits.MassFlowRate mAir_flow(min=Modelica.Constants.eps)
    "Mass flow rate of air";
  input Modelica.SIunits.MassFlowRate mAirNonZer_flow(min=Modelica.Constants.eps)
    "Mass flow rate for air, bounded away from zero";

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

  Real eps(min=0, max=1, unit="1")
    "Effectiveness for heat exchanger";
  Modelica.SIunits.ThermalConductance CWat_flow
    "Capacitance rate of water";
  Modelica.SIunits.ThermalConductance CAir_flow
    "Capacitance rate of air";
  Modelica.SIunits.ThermalConductance CMin_flow
    "Minimum capacity rate";
  Real Z(unit="1")
    "capacitance rate ratio (C*)";
  Modelica.SIunits.ThermalConductance UA
    "Overall heat transfer coefficient";
  Real NTU
    "Dry coil number of transfer units";
protected
  Modelica.SIunits.ThermalConductance CWatNonZer_flow
    "Non-zero capacitance rate of water";
  Modelica.SIunits.ThermalConductance CAirNonZer_flow
    "Non-zero capacitance rate of air";
  Modelica.SIunits.ThermalConductance CMinNonZer_flow
    "Non-zero minimum capacity rate";
  Modelica.SIunits.ThermalConductance CMaxNonZer_flow
    "Non-zero maximum capacity rate";

equation
  CWat_flow = mWat_flow * cpWat;
  CAir_flow = mAir_flow * cpAir;
  CMin_flow = min(CWat_flow, CAir_flow);

  CWatNonZer_flow = mWatNonZer_flow * cpWat;
  CAirNonZer_flow = mAirNonZer_flow * cpAir;
  CMinNonZer_flow = min(CWatNonZer_flow, CAirNonZer_flow);
  CMaxNonZer_flow = max(CWatNonZer_flow, CAirNonZer_flow);
  UA = 1/ (1 / UAAir + 1 / UAWat) "UA is for the overall coil (i.e., both sides)";
  Z = CMinNonZer_flow / CMaxNonZer_flow "Braun 1988 eq 4.1.10";
  NTU = fraHex*UA/CMinNonZer_flow;

  eps = epsilon_ntuZ(
      Z = Z,
      NTU = NTU,
      flowRegime = Integer(cfg));
  // Use CMin to compute Q_flow
  Q_flow = eps * CMin_flow * (TWatIn - TAirIn)
      "Note: positive heat transfer is air to water";
  // fixme: the next two equations are only valid if CWat >= CAir,
  // but this is not true if the water flow is small
  TAirOut = TAirIn + eps * (TWatIn - TAirIn)
      "Braun 1988 eq 4.1.8";
  TWatOut = TWatIn + Z * (TAirIn - TAirOut)
      "Braun 1988 eq 4.1.9";

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
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetEffectivenessNTU</a> for documentation.
</p>
</html>"));
end DryCalcs;

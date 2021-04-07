within Buildings.Fluid.HeatExchangers.BaseClasses;
model WetCoilDryRegime
  "Fully dry coil model"

  // - water
  input Modelica.SIunits.ThermalConductance UAWat
    "UA for water side";
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
  input Modelica.SIunits.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate for air";
  input Modelica.SIunits.MassFlowRate mWat_flow_nominal
    "Nominal mass flow rate for water";

  parameter Real delta = 1E-3 "Small value used for smoothing";

  output Modelica.SIunits.HeatFlowRate QTot_flow
    "Heat transferred from water to air";
  output Modelica.SIunits.Temperature TWatOut
    "Temperature of water at outlet";
  output Modelica.SIunits.Temperature TAirOut
    "Temperature of air at the outlet";
  output Real eps(min=0, max=1, unit="1")
    "Effectiveness for heat exchanger";
  Modelica.SIunits.ThermalConductance CWat_flow=mWat_flow*cpWat
    "Capacitance rate of water";
  Modelica.SIunits.ThermalConductance CAir_flow=mAir_flow*cpAir
    "Capacitance rate of air";
  Modelica.SIunits.ThermalConductance CMin_flow_nominal=
    min(mAir_flow_nominal*cpAir,mWat_flow_nominal*cpWat)
    "Minimum capacity rate";
  Modelica.SIunits.ThermalConductance CMax_flow_nominal=
    max(mAir_flow_nominal*cpAir,mWat_flow_nominal*cpWat)
    "Maximum capacity rate";
  Modelica.SIunits.ThermalConductance CMin_flow=
    Buildings.Utilities.Math.Functions.smoothMin(
      x1=CAir_flow,x2=CWat_flow,deltaX=1E-3*(CMax_flow_nominal-CMin_flow_nominal))
    "Minimum capacity rate";
  Modelica.SIunits.ThermalConductance UA
    "Overall heat transfer coefficient";
  output Modelica.SIunits.Temperature TSurAirOut
    "Surface Temperature at air outlet";
equation
  UA = 1/ (1 / UAAir + 1 / UAWat);

  eps=epsilon_C(
    UA=UA,
    C1_flow=CWat_flow,
    C2_flow=CAir_flow,
    flowRegime=Integer(cfg),
    CMin_flow_nominal= CMin_flow_nominal,
    CMax_flow_nominal=CMax_flow_nominal,
    delta= delta);

  QTot_flow = eps*CMin_flow*(TAirIn-TWatIn);
  TAirOut=TAirIn-QTot_flow/(mAirNonZer_flow*cpAir);
  TWatOut=TWatIn+QTot_flow/(mWatNonZer_flow*cpWat);

  (TAirOut-TSurAirOut)*UAAir=(TSurAirOut-TWatIn)*UAWat;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Jan 21, 2021, by Donghun Kim:<br/>First implementation of the fuzzy model.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">issue 622</a>
for more information.</li>
</ul>
</html>", info="<html>
<p>This model implements the calculation for a 100% dry coil.</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>
for documentation.
</p>
</html>"));
end WetCoilDryRegime;

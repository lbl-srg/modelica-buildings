within Buildings.Media.Conversions.Validation;
model PressureDrop_massFlowRate
  "Validation model for Buildings.Media.Conversions.FlowResistance.pressureDrop_massFlowRate"
  extends Modelica.Icons.Example;

  package FloRes = Buildings.Media.Conversions.FlowResistance(
    redeclare package MediumOri = Buildings.Media.Water,
    redeclare package MediumNew =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
            T=293.15,
            phi=0.25)));

  parameter Real n=1.688
    "Flow coefficient n, n=1 for laminar, n=1.688 for turbulent flow";

  Real ratio_m_flow(min=0, unit="1") = 0.5 + time
    "Ratio of mass flow rates, varies from 0.5 to 1.5 as time goes from 0 to 1";

  Real dpRat_m_flow(min=0, unit="1") = FloRes.pressureDrop_massFlowRate(
    ratio_m_flow=ratio_m_flow,
    n=n)
    "Pressure drop ratio for turbulent flow";

  Real ratio_V_flow(min=0, unit="1") = 0.5 + time
    "Ratio of volume flow rates, varies from 0.5 to 1.5 as time goes from 0 to 1";

  Real dpRat_V_flow(min=0, unit="1") = FloRes.pressureDrop_volumeFlowRate(
    ratio_V_flow=ratio_V_flow,
    n=n)
    "Pressure drop ratio for turbulent flow";

  parameter Real dpRat_equalHeatFlowRate(min=0, unit="1") =
    FloRes.pressureDrop_equalHeatFlowRate(
      n=n)
    "Pressure drop ratio for equal heat flow rate at turbulent flow";

  annotation (
    experiment(
      Tolerance=1e-06,
      StopTime=1.5),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Conversions/Validation/PressureDrop_massFlowRate.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model for
<a href=\"modelica://Buildings.Media.Conversions.FlowResistance.pressureDrop_massFlowRate\">
Buildings.Media.Conversions.FlowResistance.pressureDrop_massFlowRate</a>.
</p>
<p>
The model computes the ratio of pressure drops <code>dpRat_m_flow</code>
when the working fluid is changed from water to a 25% volume fraction
propylene glycol-water mixture, both evaluated at 20&deg;C.
The mass flow rate ratio <code>ratio_m_flow</code> varies linearly from
0.5 to 1.5 over the simulation period of 1 second.
The pressure drop ratio is computed for turbulent flow, i.e., <code>n=2</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 11, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PressureDrop_massFlowRate;
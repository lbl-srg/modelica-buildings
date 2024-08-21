within Buildings.Applications.BaseClasses.Equipment;
model FlowMachine_m "Identical m_flow controlled pumps"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPumpParallel(
    redeclare final Buildings.Fluid.Movers.FlowControlled_m_flow pum(
      each final m_flow_nominal = m_flow_nominal,
      final m_flow_start=yPump_start*m_flow_nominal,
      each final dpMax=dpMax),
    rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  // Note: Below we set a huge value for dpMax. This is needed for Dymola 2023
  // to run
  // simulateModel("Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimarySecondaryEconomizer", stopTime=86400, method="Cvode", tolerance=1e-07, resultFile="IntegratedPrimarySecondaryEconomizer");
  // on commit 3362be949be55b3c1e320faec8c8bac999f98ba4.
  // It seems to be an issue of Dymola evaluating the assertion before convergence,
  // because the result file does not show such large a pressure, and the model
  // works fine with Optimica.
  parameter Modelica.Units.SI.Pressure dpMax(
    displayUnit="Pa")=2*max(pum.per.pressure.dp)+6E11
    "Maximum pressure allowed to operate the model, if exceeded, the simulation stops with an error"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Math.Gain gaiM_flow[num](each final k=m_flow_nominal)
    "Gain for mass flow rate"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

equation
  connect(swi.y, gaiM_flow.u)
    annotation (Line(points={{-26,-30},{28,-30},{28,54},{-38,54},{-38,40},{-32,40}},
                                                 color={0,0,127}));
  connect(gaiM_flow.y, pum.m_flow_in) annotation (Line(points={{-9,40},{0,40},{0,
          12}},               color={0,0,127}));
  annotation (    Documentation(info="<html>
<p>This model implements a parallel of identical pumps with <code>m_flow</code> being controlled.
The number can be specified by setting a value of <code>num</code>.
The shutoff valves are used to avoid circulating flow among pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
November 16, 2022, by Michael Wetter:<br/>
Improved sequence to avoid switching pump on when the valve is commanded off.
</li>
<li>
July 27, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowMachine_m;

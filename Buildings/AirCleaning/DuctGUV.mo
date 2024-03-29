within Buildings.AirCleaning;
model DuctGUV "In Duct GUV"
  extends Buildings.AirCleaning.BaseClasses.PartialDuctGUV(final
      m_flow_turbulent=if computeFlowResistance then deltaM*m_flow_nominal_pos
         else 0, vol(nPorts=2));

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

  parameter Real kpow(min=0) = 120
    "Rated power";

  parameter Real kGUV[Medium.nC](min=0)
    "Inactivation constant";

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  final parameter Real k = if computeFlowResistance then
        m_flow_nominal_pos / sqrt(dp_nominal_pos) else 0
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  Buildings.AirCleaning.BaseClasses.InDuctGUVCalc guvCal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    kGUV=kGUV) annotation (Placement(transformation(extent={{44,-10},{64,10}})));
protected
  final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
    "Flag to enable/disable computation of flow resistance"
   annotation(Evaluate=true);
  final parameter Real coeff=
    if linearized and computeFlowResistance
    then if from_dp then k^2/m_flow_nominal_pos else m_flow_nominal_pos/k^2
    else 0
    "Precomputed coefficient to avoid division by parameter";
protected
  Modelica.Blocks.Math.Gain pGUV(final k=kpow) "power of GUV"
    annotation (Placement(transformation(extent={{-48,-60},{-28,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prePow(final alpha=0)
 if addPowerToMedium
    "Prescribed power (=heat and flow work) flow for dynamic model"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
initial equation
 if computeFlowResistance then
   assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
 end if;

 assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
equation
  // Pressure drop calculation

  /*if computeFlowResistance then
    if linearized then
      if from_dp then
        m_flow = dp*coeff;
      else
        dp = m_flow*coeff;
      end if;
    else
      if homotopyInitialization then
        if from_dp then
          m_flow=homotopy(
            actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
              dp=dp,
              k=k,
              m_flow_turbulent=m_flow_turbulent),
            simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
        else
          dp=homotopy(
            actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow,
              k=k,
              m_flow_turbulent=m_flow_turbulent),
            simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
         end if;  // from_dp
      else // do not use homotopy
        if from_dp then
          m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
            dp=dp,
            k=k,
            m_flow_turbulent=m_flow_turbulent);
        else
          dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
            m_flow=m_flow,
            k=k,
            m_flow_turbulent=m_flow_turbulent);
        end if;  // from_dp
      end if; // homotopyInitialization
    end if; // linearized
  else // do not compute flow resistance
    dp = 0;
    end if;  // computeFlowResistance */

  connect(pGUV.y, prePow.Q_flow)
    annotation (Line(points={{-27,-50},{-20,-50}}, color={0,0,127}));
  connect(guvCal.port_b, port_b)
    annotation (Line(points={{64,0},{100,0}}, color={0,127,255}));
  connect(booleanToReal.y, pGUV.u) annotation (Line(points={{-59,-80},{-54,-80},
          {-54,-50},{-50,-50}}, color={0,0,127}));
  connect(u, guvCal.u) annotation (Line(points={{-120,-80},{-90,-80},{-90,-18},
          {14,-18},{14,-8},{42,-8}}, color={255,0,255}));
  connect(prePow.port, vol.heatPort) annotation (Line(points={{0,-50},{0,0}},
                                 color={191,0,0}));
  connect(port_a, vol.ports[1]) annotation (Line(points={{-100,0},{-6,0},{-6,
          -12},{2,-12},{2,-14},{8,-14},{8,-10}}, color={0,127,255}));
  connect(vol.ports[2], guvCal.port_a) annotation (Line(points={{12,-10},{56,
          -10},{56,0},{44,0}}, color={0,127,255}));
  annotation (defaultComponentName="res",
Documentation(info="<html>
<p>Model of an in-duct GUV. </p>
<h4>Assumptions</h4>
<h4>Important parameters</h4>
<h4>Notes</h4>
<h4>Implementation</h4>
</html>", revisions="<html>
<ul>
<li>
September 21, 2018, by Michael Wetter:<br/>
Decrease value of <code>deltaM(min=...)</code> attribute.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1026\">#1026</a>.
</li>
<li>
February 3, 2018, by Filip Jorissen:<br/>
Revised implementation of pressure drop equation
such that it depends on <code>from_dp</code>
when <code>linearized=true</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/884\">#884</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Simplified model by removing the geometry dependent parameters into the new
model
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>.
</li>
<li>
November 23, 2016, by Filip Jorissen:<br/>
Removed <code>dp_nominal</code> and
<code>m_flow_nominal</code> labels from icon.
</li>
<li>
October 14, 2016, by Michael Wetter:<br/>
Updated comment for parameter <code>use_dh</code>.
</li>
<li>
November 26, 2014, by Michael Wetter:<br/>
Added the required <code>annotation(Evaluate=true)</code> so
that the system of nonlinear equations in
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PressureDropsExplicit\">
Buildings.Fluid.FixedResistances.Validation.PressureDropsExplicit</a>
remains the same.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Rewrote the warning message using an <code>assert</code> with
<code>AssertionLevel.warning</code>
as this is the proper way to write warnings in Modelica.
</li>
<li>
August 5, 2014, by Michael Wetter:<br/>
Corrected error in documentation of computation of <code>k</code>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
January 16, 2012 by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.PressureDrop</code>.
</li>
<li>
May 30, 2008 by Michael Wetter:<br/>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-74,94},{72,76}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,70},{-60,-14}}, color={28,108,200}),
        Line(points={{-40,70},{-40,-14}}, color={28,108,200}),
        Line(points={{0,70},{0,-14}}, color={28,108,200}),
        Line(points={{60,70},{60,-14}}, color={28,108,200}),
        Line(points={{40,70},{40,-14}}, color={28,108,200}),
        Line(points={{20,70},{20,-14}}, color={28,108,200}),
        Line(points={{-20,70},{-20,-14}}, color={28,108,200})}),
    experiment(StopTime=7200, __Dymola_Algorithm="Dassl"));
end DuctGUV;

within Buildings.Fluid.BaseClasses;
partial model PartialResistance "Partial model for a hydraulic resistance"
    extends Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface(
     show_T=false, show_V_flow=false);

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Medium.MassFlowRate m_flow_nominal(min=0) "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"                                annotation(Dialog(group = "Nominal condition"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Real k(unit="") "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  Medium.MassFlowRate m_flow_turbulent
    "Turbulent flow if |m_flow| >= m_flow_turbulent, not a parameter because k can be a function of time"
     annotation(Evaluate=true);

protected
  parameter Medium.ThermodynamicState sta0=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.DynamicViscosity eta_nominal=Medium.dynamicViscosity(sta0)
    "Dynamic viscosity, used to compute transition to turbulent flow regime";
  parameter Modelica.SIunits.SpecificEnthalpy h0=Medium.h_default
    "Initial value for solver for specific enthalpy";           //specificEnthalpy(sta0)
 constant Real conv(unit="m.s2/kg") = 1 "Factor, needed to satisfy unit check";
 constant Real conv2 = sqrt(conv) "Factor, needed to satisfy unit check";
 final parameter Boolean computeFlowResistance=(dp_nominal > Modelica.Constants.eps)
    "Flag to enable/disable computation of flow resistance"
   annotation(Evaluate=true);
equation
  // Pressure drop calculation
  if computeFlowResistance then
    if homotopyInitialization then
      if from_dp then
        m_flow=homotopy(actual=FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                   m_flow_turbulent=m_flow_turbulent,
                                   linearized=linearized),
                        simplified=m_flow_nominal*dp/dp_nominal);
      else
        dp=homotopy(actual=FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                   m_flow_turbulent=m_flow_turbulent,
                                   linearized=linearized),
                    simplified=dp_nominal*m_flow/m_flow_nominal);
      end if;
    else // do not use homotopy
      if from_dp then
        m_flow=FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_turbulent, linearized=linearized);
      else
        dp=FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent, linearized=linearized);
      end if;
    end if; // homotopyInitialization
  else
    dp = 0;
  end if;  // computeFlowResistance

  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          visible=linearized,
          extent={{-100,22},{100,-24}},
          fillPattern=FillPattern.Backward,
          fillColor={0,128,255},
          pattern=LinePattern.None,
          lineColor={255,255,255})}),
          defaultComponentName="res",
Documentation(info="<html>
<p>
Partial model for a flow resistance, possible with variable flow coefficient.
The pressure drop is computed by an instance of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel\">
Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel</a>,
i.e., using a regularized implementation of the equation
<pre>
  m_flow = sign(dp) * k * sqrt(|dp|).
</pre>
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2011 by Michael Wetter:<br>
Added homotopy operator.
</li>
<li>
March 30, 2010 by Michael Wetter:<br>
Changed base classes to allow easier initialization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
March 27, 2011, by Michael Wetter:<br>
Added <code>homotopy</code> operator.
</li>
<li>
April 13, 2009, by Michael Wetter:<br>
Extracted pressure drop computation and implemented it in the
new model
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel\">
Buildings.Fluid.BaseClasses.FlowModels.BasicFlowModel</a>.
</li>
<li>
September 18, 2008, by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end PartialResistance;

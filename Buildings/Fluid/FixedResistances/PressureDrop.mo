within Buildings.Fluid.FixedResistances;
model PressureDrop
  "Fixed flow resistance with dp and m_flow as parameter"
  extends Buildings.Fluid.BaseClasses.PartialResistance(
    final m_flow_turbulent = if computeFlowResistance then deltaM * m_flow_nominal_pos else 0);

  parameter Real n(min=1, max=2) = 2
    "Flow exponent, n=1 for laminar, n=2 for turbulent"
    annotation(Evaluate=true);

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

  final parameter Real k = if computeFlowResistance and not (linearized or fullyLaminar) then
        m_flow_nominal_pos / dp_nominal_pos^(1/n) else 0
    "Flow coefficient, k=m_flow/dp^(1/n)";
protected
  parameter Boolean disableComputeFlowResistance_internal=false
    "=false to disable computation of flow resistance"
    annotation(Evaluate=true);
  final parameter Boolean computeFlowResistance=
    (dp_nominal_pos > Modelica.Constants.eps) and not disableComputeFlowResistance_internal
    "Flag to enable/disable computation of flow resistance"
   annotation(Evaluate=true);
  final parameter Real coeM(final unit="kg/(s.Pa)")=
    if (linearized or fullyLaminar) and computeFlowResistance
    then m_flow_nominal_pos/dp_nominal_pos else 0
    "Precomputed coefficient for linearized or fully laminar flow";
  final parameter Real coeP(final unit="s.Pa/kg")=
    if (linearized or fullyLaminar) and computeFlowResistance
    then dp_nominal_pos/m_flow_nominal_pos else 0
    "Precomputed coefficient for linearized or fully laminar flow";

  // Coefficients for partially turbulent model
  parameter Boolean fullyTurbulent = n > 1.99999999 and n < 2.00000001
    "If true, fully turbulent, simpler model, is used"
    annotation(Evaluate=true);
  parameter Boolean fullyLaminar = n > 0.99999999 and n < 1.00000001
    "If true, fully turbulent, simpler model, is used"
    annotation(Evaluate=true);

  // Coefficients for the power law model, computed once as parameters
  final parameter Boolean computePowerLaw=
    computeFlowResistance and not (linearized or fullyLaminar or fullyTurbulent)
    "Flag, true if the power law model coefficients need to be computed"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(
    displayUnit="Pa", fixed=false)
    "Pressure difference where turbulent flow occurs";
  parameter Real m(fixed=false)
    "Flow exponent for the pressure drop";
  parameter Real a1(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a3(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a5(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real C(fixed=false)
    "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  parameter Real b1(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b3(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b5(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";

initial equation
 if computePowerLaw then
   (dp_turbulent, m, a1, a3, a5, C, b1, b3, b5) =
     Buildings.Fluid.BaseClasses.FlowModels.powerLawData(
       k=k, n=n, m_flow_turbulent=m_flow_turbulent);
 else
   dp_turbulent = 0;
   m = 1/n;
   a1 = 0;
   a3 = 0;
   a5 = 0;
   C = 0;
   b1 = 0;
   b3 = 0;
   b5 = 0;
 end if;
 if computeFlowResistance then
   assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
 end if;

 assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
equation
  // Pressure drop calculation
  if computeFlowResistance then
    if linearized or fullyLaminar then
      if from_dp then
        m_flow = dp*coeM;
      else
        dp = m_flow*coeP;
      end if;
    else
      if fullyTurbulent then
        // Case for n=2, which uses a simpler implementation
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
      else
        // Case for n < 2.
        if homotopyInitialization then
            m_flow=homotopy(
              actual=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
                dp=dp, k=k, n=n,
                m_flow_turbulent=m_flow_turbulent,
                dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5,
                C=C, b1=b1, b3=b3, b5=b5),
              simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
        else // do not use homotopy
          m_flow=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
                dp=dp, k=k, n=n,
                m_flow_turbulent=m_flow_turbulent,
                dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5,
                C=C, b1=b1, b3=b3, b5=b5);
        end if; // homotopyInitialization
      end if;
    end if; // linearized
  else // do not compute flow resistance
    dp = 0;
  end if;  // computeFlowResistance

  annotation (defaultComponentName="res",
Documentation(info="<html>
<p>
Model of a flow resistance with a fixed flow coefficient.
The mass flow rate and pressure loss relationship is
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = k
&Delta;p<sup>1/n</sup>,
</p>
<p>
where
<i>k</i> is a constant and
<i>&Delta;p</i> is the pressure drop and
<i>n</i> is the pressure drop coefficient, set by default to <i>n=2</i>.
The constant <i>k</i> is equal to
<code>k=m_flow_nominal/sqrt(dp_nominal)</code>,
where <code>m_flow_nominal</code> and <code>dp_nominal</code>
are parameters.
</p>
<h4>Assumptions</h4>
<p>
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>,
the square root is replaced by a differentiable function
with finite slope.
The value of <code>m_flow_turbulent</code> is
computed as
<code>m_flow_turbulent = deltaM * abs(m_flow_nominal)</code>,
where <code>deltaM=0.3</code> and
<code>m_flow_nominal</code> are parameters that can be set by the user.
</p>
<p>
The figure below shows the pressure drop for the parameters
<code>m_flow_nominal=5</code> kg/s,
<code>dp_nominal=10</code> Pa and
<code>deltaM=0.3</code> and <code>n=2</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/PressureDrop.png\"/>
</p>
<h4>Important parameters</h4>
<p>
The pressure loss coefficient <code>n</code> determines how the
mass flow rate and pressure loss are related.
Use <code>n=1</code> for laminar flow and <code>n=2</code> for fully
turbulent flow.
Intermediate values may be used for components such as filters,
micro-channel heat exchangers or very smooth plastic pipes.
</p>
<p>
The parameter <code>from_dp</code> is used to determine
whether the mass flow rate is computed as a function of the
pressure drop (if <code>from_dp=true</code>), or vice versa.
This setting can affect the size of the nonlinear system of equations.
</p>
<p>
If the parameter <code>linearized</code> is set to <code>true</code>,
then the pressure drop is computed as a linear function of the
mass flow rate.
</p>
<p>
To disable any pressure drop calculation, set <code>dp_nominal = 0</code>.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler
equations. However, this should only be set to <code>false</code>
if one can guarantee that the flow never reverses its direction.
This can be difficult to guarantee, as pressure imbalance after
the initialization, or due to medium expansion and contraction,
can lead to reverse flow.
</p>
<p>
If the parameter
<code>show_T</code> is set to <code>true</code>,
then the model will compute the
temperature at its ports. Note that this can lead to state events
when the mass flow rate approaches zero,
which can increase computing time.
</p>
<h4>Notes</h4>
<p>
For more detailed models that compute the actual flow friction,
models from the package
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
can be used and combined with models from the
<code>Buildings</code> library.
</p>
<p>
For a model that uses the hydraulic parameter and flow velocity at nominal conditions
as a parameter, use
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>.
</p>
<h4>Implementation</h4>
<p>
For <code>n=2</code>, the pressure drop is computed by calling a function in the package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
and its inverse function.
</p>
<p>
For other values of <code>n</code>, a computationally more expensive implementation is used
through a call of the function
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>.
</p>
<p>
To decouple the energy equation from the mass equations,
the pressure drop is a function of the mass flow rate,
and not the volume flow rate.
This leads to simpler equations.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2026, by Michael Wetter:<br/>
Updated implementation to allow a flow coefficient <code>n</code> that is different from <code>2</code>.
This allows use of the model for not fully turbulent flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">#4620</a>.
</li>
<li>
March 31, 2026, by Michael Wetter:<br/>
Corrected unit propagation error that causes Dymola 2026x to not show certain units.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2100\">#2100</a>.
</li>
<li>
April 25, 2025, by Fabian Wuelhorst and Michael Wetter:<br/>
Add option to disable <code>computeFlowResistance</code> for extending classes.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2001\">#2001</a>.
</li>
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
    Icon(graphics={Text(
          extent={{-34,-54},{34,-84}},
          textColor={28,108,200},
          visible = not (fullyTurbulent or fullyLaminar),
          textString="n=n")}));
end PressureDrop;

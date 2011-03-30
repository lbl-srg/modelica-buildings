within Buildings.Fluid.Movers;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>This package contains models that can be used for fans and pumps. 
</p>
<h4>Model description</h4>
<p>
This package contains models for fans and pumps. The same models
are used for both devices. The models are parameterized by
performance curves that compute pressure rise, 
electrical power draw or efficiency as a function 
of the flow rate.
These performance curves are described in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</p>
<p>
The models
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a>
take as an input a control signal, and then compute the pressure difference for the
current flow rate.
The models <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>
take as an input signal the pressure difference or the mass flow rate.
This pressure difference or mass flow rate will be provided by the fan or pump. 
These two models do not have a performance curve for the flow
characteristics. The reason is that at zero pressure difference,
solving for the flow rate and the revolution leads to a singularity.
</p>
<p>
All models can be configured to have a fluid volume at the low-pressure side.
Adding such a volume sometimes helps the solver to find a solution during
initialization and time integration of large models.
</p>
<p>
All models compute the motor power draw <code>PEle</code>,
the hydraulic power input <code>WHyd</code>, the flow work
<code>WFlo</code> and the heat dissipated into the medium
<code>Q_flow</code>. From the first law and the definition of efficiency, we have
</p>
<pre>
  WFlo = | V_flow * dp |
  WHyd = WFlo + Q_flow
  eta = WFlo / PEle = etaHyd * etaMot
  etaHyd = WFlo/WHyd
  etaMot = WHyd/PEle
</pre>
<p>
</p>
<p>
All models take as a parameter an efficiency curve for the motor. This function
has the form
</p>
<pre>
  etaMot = f(V_flow/V_flow_max)
</pre>
<p>
where <code>V_flow_max</code> is the maximum flow rate. The models 
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_y\">
Buildings.Fluid.Movers.FlowMachine_y</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_Nrpm\">
Buildings.Fluid.Movers.FlowMachine_Nrpm</a> set
</p>
<pre>
  V_flow_max = flowCharacteristics(dp=0, r_N=1);
</pre>
<p>
where <code>r_N</code> is the ratio of actual to nominal speed.
Since <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a> and
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>
do not have a <code>flowCharacteristics</code>, the parameter
<code>V_flow_max</code> must be set by the user for these models.
</p>
<p>
For a detailed description of the models with names <code>FlowMachine_*</code>,
see their base class <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine\">
Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine.</a>
</p>
<p>
The model <a href=\"modelica://Buildings.Fluid.Movers.FlowMachinePolynomial\">
Buildings.Fluid.Movers.FlowMachinePolynomial</a> is in this package for compatibility 
with older versions of this library. It is recommended to use the other models as they optionally
allow use of a medium volume that provides state variables which are needed in some models 
when the flow rate is zero.



<h4>Differences to models in Modelica.Fluid.Machines</h4>
<p>The models with names <code>FlowMachine_*</code> have similar parameters than the
models in the package <a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a>. 
However, the models in this package differ primarily in the following points:
<ul>
<li>
They use a different base class, which allows to have zero mass flow rate.
The models in <code>Modelica.Fluid</code> restrict the number of revolutions, and hence the flow
rate, to be non-zero.
</li>
<li>
For the model with prescribed pressure, the input signal is the 
pressure difference between the two ports, and not the absolute
pressure at <code>port_b</code>.
</li>
<li>
The pressure calculations are based on total pressure in Pascals instead of the pump head in meters. 
This change was done to avoid ambiguities in the parameterization if the models are used as a fan 
with air as the medium. The original formulation in 
<a href=\"Modelica.Fluid.Machines\">Modelica.Fluid.Machines</a> converts head to pressure using the density <code>medium.d</code>. Therefore, for fans, head would be converted to pressure using the density of air. However, for fans, manufacturers typically publish the head in millimeters water (mmH20). Therefore, to avoid confusion when using these models with media other than water, 
we changed the models to use total pressure in Pascals instead of head in meters.
</li>
<li>
Additional performance curves have been added to the package <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</li>
</ul>
</html>"));

end UsersGuide;

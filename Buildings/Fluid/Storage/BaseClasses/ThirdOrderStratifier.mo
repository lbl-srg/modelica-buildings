within Buildings.Fluid.Storage.BaseClasses;
model ThirdOrderStratifier
  "Model to reduce the numerical dissipation in a tank"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0)
    "Small mass flow rate for regularization of zero flow";

  parameter Integer nSeg(min=4) "Number of volume segments";

  parameter Real alpha(
    min=0,
    max=1) = 0.5
    "Under-relaxation coefficient (1: QUICK; 0: 1st order upwind)";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heatPort
    "Heat input into the volumes"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput m_flow
    "Mass flow rate from port a to port b"
    annotation (Placement(transformation(extent={{-140,62},{-100,102}})));

  Modelica.Blocks.Interfaces.RealInput[nSeg + 1] H_flow
    "Enthalpy flow between the volumes"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Fluid.Interfaces.FluidPort_a[nSeg + 2] fluidPort(redeclare each
      package Medium = Medium)
    "Fluid port, needed to get pressure, temperature and species concentration"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

protected
  Modelica.Units.SI.SpecificEnthalpy[nSeg + 1] hOut
    "Extended vector with new outlet enthalpies to reduce numerical dissipation (at the boundary between two volumes)";

  Modelica.Units.SI.SpecificEnthalpy[nSeg + 2] h
    "Extended vector with port enthalpies, needed to simplify loop";

  Modelica.Units.SI.HeatFlowRate Q_flow[nSeg]
    "Heat exchange computed using upwind third order discretization scheme";

  //    Modelica.Units.SI.HeatFlowRate Q_flow_upWind
  //     "Heat exchange computed using upwind third order discretization scheme"; //Used to test the energy conservation
  Real sig
    "Sign used to implement the third order upwind scheme without triggering a state event";

  Real comSig
    "Sign used to implement the third order upwind scheme without triggering a state event";

equation
  assert(nSeg >= 4,
  "Number of segments of the enhanced stratified tank should be no less than 4 (nSeg>=4).");

  // assign zero flow conditions at port
  fluidPort[:].m_flow = zeros(nSeg + 2);
  fluidPort[:].h_outflow = zeros(nSeg + 2);
  fluidPort[:].Xi_outflow = zeros(nSeg + 2, Medium.nXi);
  fluidPort[:].C_outflow = zeros(nSeg + 2, Medium.nC);

  // assign extended enthalpy vectors
  for i in 1:nSeg + 2 loop
    h[i] = inStream(fluidPort[i].h_outflow);
  end for;

  // Value that transitions between 0 and 1 as the flow reverses.
  sig = Modelica.Fluid.Utilities.regStep(
    m_flow,
    1,
    0,
    m_flow_small);
             // at surface between port_a and vol1

  comSig = 1 - sig;

  // at surface between port_a and vol1
  hOut[1] = sig*h[1] + comSig*h[2];
  // at surface between vol[nSeg] and port_b
  hOut[nSeg + 1] = sig*h[nSeg + 1] + comSig*h[nSeg + 2];

  // Pros: These two equations can further reduce the temperature overshoot by using the upwind
  // Cons: The minimum of nSeg hase to be 4 instead of 2.
  hOut[2] = sig*h[2] + comSig*h[3];
  // at surface between vol1 and vol2
  hOut[nSeg] = sig*h[nSeg] + comSig*h[nSeg + 1];
  // at surface between vol[nSeg-1] and vol[nSeg]

  for i in 3:nSeg - 1 loop
    // at surface between vol[i-1] and vol[i]
    // QUICK method
    hOut[i] = 0.5*(h[i] + h[i + 1]) - comSig*0.125*(h[i + 2] + h[i] - 2*h[i + 1])
       - sig*0.125*(h[i - 1] + h[i + 1] - 2*h[i]);
    //     hOut[i] = 0.5*(h[i]+h[i+1]); // Central difference method
  end for;

  for i in 1:nSeg loop
    // difference between QUICK and UPWIND; index of H_flow is same as hOut
    Q_flow[i] = m_flow*(hOut[i + 1] - hOut[i]) - (H_flow[i + 1] - H_flow[i]);
  end for;

  //   Q_flow_upWind = sum(Q_flow[i] for i in 1:nSeg); //Used to test the energy conservation

  for i in 1:nSeg loop
    // Add the difference back to the volume as heat flow. An under-relaxation is needed to reduce
    // oscillations caused by high order method
    heatPort[i].Q_flow = Q_flow[i]*alpha;
  end for;
  annotation (Documentation(info="<html>
<p>
This model reduces the numerical dissipation that is introduced
by the standard first-order upwind discretization scheme which is
created when connecting fluid volumes in series.
</p>
<p>
The model is used in conjunction with
<a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>.
It computes a heat flux that needs to be added to each volume of <a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a> in order to give the results that a third-order upwind discretization scheme (QUICK) would give.
</p>
<p>
The QUICK method can cause oscillations in the tank temperatures since the high order method introduces numerical dispersion.
There are two ways to reduce the oscillations:</p>
<ul>
<li>
To use an under-relaxation coefficient <code>alpha</code> when adding the heat flux into the volume.
</li>
<li>
To use the first-order upwind for <code>hOut[2]</code> and <code>hOut[nSeg]</code>. Note: Using it requires <code>nSeg &ge; 4</code>.
</li>
</ul>
<p>
Both approaches are implemented in the model.
</p>
<p>
The model is used by
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</p>
<h4>Limitations</h4>
<p>
The model requires at least 4 fluid segments. Hence, set <code>nSeg</code> to 4 or higher.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Removed unused protected parameters <code>sta0</code> and <code>cp0</code>.
</li>
<li>
March 29, 2012 by Wangda Zuo:<br/>
Revised the implementation to reduce the temperature overshoot.
</li>
<li>
July 28, 2010 by Wangda Zuo:<br/>
Rewrote third order upwind scheme to avoid state events.
This leads to more robust and faster simulation.
</li>
<li>
June 23, 2010 by Michael Wetter and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),graphics={
        Rectangle(
          extent={{-48,66},{48,34}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,34},{48,2}},
          fillColor={166,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-48,2},{48,-64}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}));
end ThirdOrderStratifier;

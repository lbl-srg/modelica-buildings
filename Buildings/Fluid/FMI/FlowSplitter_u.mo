within Buildings.Fluid.FMI;
block FlowSplitter_u "Model of a flow splitter that can be exported as an FMU"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nout](each min=0)
    "Nominal mass flow rate for each outlet";
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nout(min=1) "Number of outlets";

 parameter Boolean use_p_in=true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Interfaces.Inlet inlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Fluid inlet"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Interfaces.Outlet outlet[nout](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final use_p_in=use_p_in) "Fluid outlet"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput u[nout](
    each unit="1") "Control signal for the mass flow rates"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
protected
  final parameter Modelica.Units.SI.MassFlowRate mAve_flow_nominal=sum(
      m_flow_nominal)/nout "Average nominal mass flow rate";
protected
  Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_out_internal = 0
    "Internal connector for mass fraction of backward flow properties";

initial equation
  for i in 1:nout loop
    assert(m_flow_nominal[i] > 0,
      "Nominal mass flow rate must be bigger than zero.");
  end for;
equation
  for i in 1:nout loop
    assert(u[i] >= 0, "Control signal must be non-negative.");
    // Dymola 2015 FD01 (on Linux 64) does not automatically
    // remove the conditional equation below. We thus have to manually check
    // if use_p_in is true before connecting the inlet and outlet pressures.
    if use_p_in then
      connect(inlet.p, outlet[i].p);
    end if;
    outlet[i].m_flow = u[i]*m_flow_nominal[i];
    connect(outlet[i].forward, inlet.forward);
  end for;

  // As reverse flow is not supported, we assign
  // default values for the inlet.backward properties
  bacPro_internal.T = Medium.T_default;
  connect(bacPro_internal.X_w, X_w_out_internal);
  bacPro_internal.C  = zeros(Medium.nC);

  // Conditional connector
  connect(bacPro_internal, inlet.backward);
  annotation(defaultComponentName="spl",
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-100,98},{-60,60}},
          textColor={0,0,127},
          textString="u"),
        Rectangle(
          extent={{-100,14},{-22,-10}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-22,66},{100,54}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{16,80},{56,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{24,74},{24,46},{54,60},{24,74}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-22,-54},{100,-66}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{16,-40},{56,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{26,-44},{26,-76},{56,-60},{26,-44}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-40,66},{-22,-66}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder)}),
    Documentation(
info="<html>
<p>
Block that takes as an input the inflowing fluid at the port <code>inlet</code>
and a vector of control signals for the mass flow rates <code>u</code>.
The mass flow of all outlet ports <code>i</code>
is set to the value of <code>u[i] m_flow_nominal[i]</code>.
If the inflowing mass flow rate at the port <code>inlet</code> is not equal
to the sum of <code>u[i] m_flow_in[i]</code>, the simulation stops with an assert.
</p>
<h4>Assumptions and limitations</h4>
<p>
The mass flow rates at all outlet ports must be non-negative.
Reverse flow is not yet implemented.
If either of these limitations are violated, then
the model stops with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
June 9, 2016, by Thierry S. Nouidui:<br/>
Removed <code>assert()</code> statement which was triggered
when the model was exported as an FMU
depending on the execution sequence of the master algorithm.
</li>
<li>
May 27, 2016, by Michael Wetter:<br/>
Replaced <code>outlet[i].forward = inlet.forward;</code>
with a <code>connect</code> statement as
accesses to composite components other than records are not allowed.
This was done for JModelica compliance.
</li>
<li>
July 28, 2015, by Thierry S. Nouidui:<br/>
Corrected wrong <code>assert</code> statement.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
April 15, 2015 by Michael Wetter:<br/>
Changed connector variable to be temperature instead of
specific enthalpy.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowSplitter_u;

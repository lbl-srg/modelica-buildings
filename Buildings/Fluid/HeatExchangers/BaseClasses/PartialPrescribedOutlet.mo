within Buildings.Fluid.HeatExchangers.BaseClasses;
partial model PartialPrescribedOutlet
  "Ideal heater, cooler, humidifier or dehumidifier with prescribed outlet conditions"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));

protected
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Interfaces.PrescribedOutlet outCon(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    final show_T=false,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau) "Model to set outlet conditions"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(port_a, preDro.port_a) annotation (Line(
      points={{-100,0},{-50,0}},
      color={0,127,255}));
  connect(preDro.port_b,outCon. port_a) annotation (Line(
      points={{-30,0},{20,0}},
      color={0,127,255}));
  connect(outCon.port_b, port_b) annotation (Line(
      points={{40,0},{100,0}},
      color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Base class for model for an ideal heater, cooler, humidifier or dehumidifier
with a prescribed outlet conditions.
</p>
<p>
Models that extend this model need to configure the instance <code>outCon</code>
and connect its input signals, in they are enabled.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">Buildings, #1341</a>.
</li>
<li>
May 3, 2017, by Michael Wetter:<br/>
Updated protected model for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">#763</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Updated model as <code>use_dh</code> is no longer a parameter in the pressure drop model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
<li>
November 11, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
March 19, 2014, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPrescribedOutlet;

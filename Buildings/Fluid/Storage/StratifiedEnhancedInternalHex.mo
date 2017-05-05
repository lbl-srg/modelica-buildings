within Buildings.Fluid.Storage;
model StratifiedEnhancedInternalHex
  "A model of a water storage tank with a secondary loop and intenral heat exchanger"
  extends StratifiedEnhanced;

  replaceable package MediumHex =
      Modelica.Media.Interfaces.PartialMedium "Medium in the heat exchanger"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Height hHex_a
    "Height of portHex_a of the heat exchanger, measured from tank bottom"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Height hHex_b
    "Height of portHex_b of the heat exchanger, measured from tank bottom"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Integer hexSegMult(min=1) = 2
    "Number of heat exchanger segments in each tank segment"
    annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.Diameter dExtHex = 0.025
    "Exterior diameter of the heat exchanger pipe"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat transfer at nominal conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature TTan_nominal
    "Temperature of fluid inside the tank at nominal heat transfer conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature THex_nominal
    "Temperature of fluid inside the heat exchanger at nominal heat transfer conditions"
    annotation(Dialog(tab="General", group="Heat exchanger"));
  parameter Real r_nominal(min=0, max=1)=0.5
    "Ratio between coil inside and outside convective heat transfer at nominal heat transfer conditions"
          annotation(Dialog(tab="General", group="Heat exchanger"));

  parameter Modelica.SIunits.MassFlowRate mHex_flow_nominal
    "Nominal mass flow rate through the heat exchanger"
    annotation(Dialog(group="Heat exchanger"));

  parameter Modelica.SIunits.PressureDifference dpHex_nominal(displayUnit="Pa") = 2500
    "Pressure drop across the heat exchanger at nominal conditions"
    annotation(Dialog(group="Heat exchanger"));

  parameter Boolean computeFlowResistance=true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Real deltaM=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance heat exchanger"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance for heat exchanger internal fluid mass"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamicsHex=
    energyDynamicsHex "Formulation of mass balance for heat exchanger"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHexSolid=energyDynamicsHex
    "Formulation of energy balance for heat exchanger solid mass"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.Length lHex=
    rTan*abs(segHex_a-segHex_b)*Modelica.Constants.pi
    "Approximate length of the heat exchanger"
     annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.Area ACroHex=
    (dExtHex^2-(0.8*dExtHex)^2)*Modelica.Constants.pi/4
    "Cross sectional area of the heat exchanger"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.SpecificHeatCapacity cHex=490
    "Specific heat capacity of the heat exchanger material"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.Density dHex=8000
    "Density of the heat exchanger material"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));

  parameter Modelica.SIunits.HeatCapacity CHex=
    ACroHex*lHex*dHex*cHex
    "Capacitance of the heat exchanger without the fluid"
    annotation(Dialog(tab = "Dynamics heat exchanger", group="Equations"));
  parameter Boolean allowFlowReversalHex = true
    "= true to allow flow reversal in heat exchanger, false restricts to design direction (portHex_a -> portHex_b)"
    annotation(Dialog(tab="Assumptions", group="Heat exchanger"), Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPort_a portHex_a(
    redeclare final package Medium =MediumHex,
     m_flow(min=if allowFlowReversalHex then -Modelica.Constants.inf else 0))
    "Heat exchanger inlet"
   annotation (Placement(transformation(extent={{-110,-48},{-90,-28}}),
                   iconTransformation(extent={{-110,-48},{-90,-28}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHex_b(
     redeclare final package Medium = MediumHex,
     m_flow(max=if allowFlowReversalHex then Modelica.Constants.inf else 0))
    "Heat exchanger outlet"
   annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}),
        iconTransformation(extent={{-110,-90},{-90,-70}})));

  BaseClasses.IndirectTankHeatExchanger indTanHex(
    redeclare final package MediumTan = Medium,
    redeclare final package MediumHex = MediumHex,
    final nSeg=nSegHex,
    final CHex=CHex,
    final volHexFlu=volHexFlu,
    final Q_flow_nominal=Q_flow_nominal,
    final TTan_nominal=TTan_nominal,
    final THex_nominal=THex_nominal,
    final r_nominal=r_nominal,
    final dExtHex=dExtHex,
    final dp_nominal=dpHex_nominal,
    final m_flow_nominal=mHex_flow_nominal,
    final energyDynamics=energyDynamicsHex,
    final energyDynamicsSolid=energyDynamicsHexSolid,
    final massDynamics=massDynamicsHex,
    final computeFlowResistance=computeFlowResistance,
    from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversalHex,
    final m_flow_small=1e-4*abs(mHex_flow_nominal))
    "Heat exchanger inside the tank"
     annotation (Placement(
        transformation(
        extent={{-10,-15},{10,15}},
        rotation=180,
        origin={-87,32})));

  Modelica.SIunits.HeatFlowRate QHex_flow = -sum(indTanHex.port.Q_flow)
    "Heat transferred from the heat exchanger to the tank";
protected
  final parameter Integer segHex_a = nSeg-integer(hHex_a/segHeight)
    "Tank segment in which port a1 of the heat exchanger is located in"
    annotation(Evaluate=true, Dialog(group="Heat exchanger"));

  final parameter Integer segHex_b = nSeg-integer(hHex_b/segHeight)
    "Tank segment in which port b1 of the heat exchanger is located in"
    annotation(Evaluate=true, Dialog(group="Heat exchanger"));

  final parameter Modelica.SIunits.Height segHeight = hTan/nSeg
    "Height of each tank segment (relative to bottom of same segment)";

  final parameter Modelica.SIunits.Length dHHex = abs(hHex_a-hHex_b)
    "Vertical distance between the heat exchanger inlet and outlet";

  final parameter Modelica.SIunits.Volume volHexFlu=
    Modelica.Constants.pi * (0.8*dExtHex)^2/4 *lHex
    "Volume of the heat exchanger";

  final parameter Integer nSegHexTan=
    if segHex_a > segHex_b then segHex_a-segHex_b + 1 else segHex_b-segHex_a + 1
    "Number of tank segments the heat exchanger resides in";

  final parameter Integer nSegHex = nSegHexTan*hexSegMult
    "Number of heat exchanger segments";

initial equation
  assert(hHex_a >= 0 and hHex_a <= hTan,
    "The parameter hHex_a is outside its valid range.");

  assert(hHex_b >= 0 and hHex_b <= hTan,
    "The parameter hHex_b is outside its valid range.");

  assert(dHHex > 0,
    "The parameters hHex_a and hHex_b must not be equal.");
equation
  for j in 0:nSegHexTan-1 loop
    for i in 1:hexSegMult loop
      connect(indTanHex.port[j*hexSegMult+i], heaPorVol[segHex_a + (if hHex_a > hHex_b then j else -j)])
        annotation (Line(
       points={{-87,41.8},{-20,41.8},{-20,-2.22045e-16},{0,-2.22045e-16}},
       color={191,0,0},
       smooth=Smooth.None));
    end for;
  end for;
  connect(portHex_a, indTanHex.port_a) annotation (Line(
      points={{-100,-38},{-68,-38},{-68,32},{-77,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(indTanHex.port_b, portHex_b) annotation (Line(
      points={{-97,32},{-98,32},{-98,18},{-70,18},{-70,-80},{-100,-80}},
      color={0,127,255},
      smooth=Smooth.None));

  annotation (Line(
      points={{-73.2,69},{-70,69},{-70,28},{-16,28},{-16,-2.22045e-16},{0,-2.22045e-16}},
      color={191,0,0},
      smooth=Smooth.None), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-94,-38},{28,-42}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,-50},{28,-54}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-78},{-68,-82}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,-50},{-68,-80}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,-48},{28,-50}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Rectangle(
          extent={{-4,-42},{28,-46}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,-44},{-2,-48}},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid)}),
defaultComponentName = "tan",
Documentation(info = "<html>
<p>
This is a model of a stratified storage tank for thermal energy storage with built-in heat exchanger.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">
Buildings.Fluid.Storage.UsersGuide</a>
for more information.
</p>
<h4>Limitations</h4>
<p>
The model requires at least 4 fluid segments. Hence, set <code>nSeg</code> to 4 or higher.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 23, 2016, by Michael Wetter:<br/>
Corrected computation of the heat exchanger location which was wrong
if <code>hHex_a &lt; hHex_b</code>, e.g., the port a of the heat exchanger
is below the port b.
This closes
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/531\">issue 531</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
July 2, 2015, by Michael Wetter:<br/>
Set the default value <code>energyDynamicsHexSolid=energyDynamicsHex</code>
rather than
<code>energyDynamicsHexSolid=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</code>
as users are not likely to want different settings.
</li>
<li>
July 1, 2015, by Filip Jorissen:<br/>
Added parameter <code>energyDynamicsHexSolid</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/434\">
#434</a>.
</li>
<li>
March 28, 2015, by Filip Jorissen:<br/>
Propagated <code>allowFlowReversal</code> and <code>m_flow_small</code>.
</li>
<li>
September 2, 2014 by Michael Wetter:<br/>
Replaced the <code>abs()</code> function in the assignment of the parameter
<code>nSegHexTan</code> as the return value of <code>abs()</code>
is a <code>Real</code> which causes a type error during model check.
</li>
<li>
August 29, 2014 by Michael Wetter:<br/>
Corrected issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>
which led to a compilation error if the heat exchanger and the tank
had different media.
</li>
<li>
April 18, 2014 by Michael Wetter:<br/>
Added missing ceiling function in computation of <code>botHexSeg</code>.
Without this function, this parameter can take on zero, which is wrong
because the Modelica uses one-based arrays.

Revised the model as the old version required the port<sub>a</sub>
of the heat exchanger to be located higher than port<sub>b</sub>.
This makes sense if the heat exchanger is used to heat up the tank,
but not if it is used to cool down a tank, such as in a cooling plant.
The following parameters were changed:
<ol>
<li>Changed <code>hexTopHeight</code> to <code>hHex_a</code>.</li>
<li>Changed <code>hexBotHeight</code> to <code>hHex_b</code>.</li>
<li>Changed <code>topHexSeg</code> to <code>segHex_a</code>,
 and made it protected as this is deduced from <code>hHex_a</code>.</li>
<li>Changed <code>botHexSeg</code> to <code>segHex_b</code>,
 and made it protected as this is deduced from <code>hHex_b</code>.</li>
</ol>
The names of the following ports have been changed:
<ol>
<li>Changed <code>port_a1</code> to <code>portHex_a</code>.</li>
<li>Changed <code>port_b1</code> to <code>portHex_b</code>.</li>
</ol>
The conversion script should update old instances of
this model automatically in Dymola for all of the above changes.
</li>
<li>
May 10, 2013 by Michael Wetter:<br/>
Removed <code>m_flow_nominal_tank</code> which was not used.
</li>
<li>
January 29, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end StratifiedEnhancedInternalHex;

within Buildings.ThermalZones.ReducedOrder.Examples;
model SimpleRoomFourElementsTraceSubstance
  "Illustrates the use of a thermal zone considering a trace substance"
  extends Modelica.Icons.Example;
  extends Buildings.ThermalZones.ReducedOrder.Examples.SimpleRoomFourElements(thermalZoneFourElements(
      redeclare package Medium = Medium,
      use_C_flow=true,
      nPorts=2));

  replaceable package Medium = Buildings.Media.Air (
    extraPropertiesNames={"C_flow"}) "Medium model"
    annotation (choicesAllMatching=true);

  parameter Real airChaRat(final unit="1/s") = 2/3600 "Air change rate";

  Modelica.Blocks.Sources.Pulse traSub(
    amplitude=10.4*2*(28.949/44.01),
    width=50,
    period=86400,
    offset=0) "Source of trace substance (for example CO2)"
    annotation (Placement(transformation(extent={{-88,-58},{-68,-38}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = Medium,
    use_C_in=true,
    m_flow=airChaRat*rho_default*thermalZoneFourElements.VAir,
    nPorts=1) "Source of air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-70})));
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium,
    C={400},
    nPorts=1) "Sink of air"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-28,-90})));
  Modelica.Blocks.Sources.Ramp traSubAmb(
    height=200,
    duration(displayUnit="d") = 259200,
    offset=200) "Source for CO2 concentration in fresh air"
    annotation (Placement(transformation(extent={{-88,-88},{-68,-68}})));

protected
  final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";

  final parameter Modelica.Units.SI.Density rho_default=Medium.density(state=
      state_default) "Density, used to compute fluid mass";

equation
  connect(traSub.y, thermalZoneFourElements.C_flow[1])
    annotation (Line(points={{-67,-48},{0,-48},{0,26},{43,26}},color={0,0,127}));
  connect(souAir.ports[1], thermalZoneFourElements.ports[1])
    annotation (Line(points={{-20,-70},{2,-70},{2,-24},{44,-24},{44,-4},{84,-4},
          {84,-1.95},{83,-1.95}},                                                      color={0,127,255}));
  connect(sinAir.ports[1], thermalZoneFourElements.ports[2])
    annotation (Line(points={{-18,-90},{4,-90},{4,-26},{46,-26},{46,-4},{86,-4},
          {86,-1.95},{83,-1.95}},                                                      color={0,127,255}));
  connect(traSubAmb.y, souAir.C_in[1])
    annotation (Line(points={{-67,-78},{-42,-78}}, color={0,0,127}));
  annotation ( Documentation(info="<html>
<p>
This example shows the application of
<a href=\"Buildings.ThermalZones.ReducedOrder.RC.FourElements\">
Buildings.ThermalZones.ReducedOrder.RC.FourElements</a>
considering a trace substance such as CO2
in combination with
<a href=\"Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow\">
Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow</a>
and
<a href=\"Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane\">
Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane</a>.
Solar radiation on tilted surface is calculated using models of
Buildings. The thermal zone is a simple room defined in Guideline
VDI 6007 Part 1 (VDI, 2012).
The trace substance calculation is based on the CO2 emissions of 2 persons.
They stay in the thermal zone for 12 hours every 24 hours. The air exchange rate is 2 air changes per hour.
All further models, parameters and inputs
except sunblinds, separate handling of heat transfer through
windows, no wall element for internal walls and solar radiation
are similar to the ones defined for the guideline&apos;s test
room. For solar radiation, the example relies on the standard
weather file in Buildings.
</p>
<p>
The idea of the example is to show a typical application of all
sub-models and to use the example in unit tests. The results are
reasonable, but not related to any real use case or measurement
data.
</p>
<h4>References</h4>
<p>VDI. German Association of Engineers Guideline VDI 6007-1
March 2012. Calculation of transient thermal response of rooms
and buildings - modelling of rooms.</p>
</html>",   revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
April 15, 2020, by Katharina Brinkmann:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(Tolerance=1e-6, StopTime=604800),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Examples/SimpleRoomFourElementsTraceSubstance.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end SimpleRoomFourElementsTraceSubstance;

within Buildings.Templates.Plants.Chillers;
model AirCooled "Air-cooled chiller plant"
  /* FIXME: Add comment for
  typArrChi_select
  typDisChiWat
  typArrPumChiWatPri_select
  have_pumChiWatPriVar_select
  chi(typValChiWatChiIso_select
  and make them final after testing
  */
  extends
    Buildings.Templates.Plants.Chillers.Interfaces.PartialChilledWaterLoop(
    redeclare replaceable package MediumCon=Buildings.Media.Air,
    redeclare final Buildings.Templates.Plants.Chillers.Components.Economizers.None eco,
    ctl(final typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.BuiltIn),
    final typChi=Buildings.Templates.Components.Types.Chiller.AirCooled,
    final typCoo=Buildings.Templates.Components.Types.Cooler.None,
    final nCoo=0,
    final nPumConWat=0,
    final typValCooInlIso=Buildings.Templates.Components.Types.Valve.None,
    final typValCooOutIso=Buildings.Templates.Components.Types.Valve.None,
    typArrChi_select=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only,
    typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    have_pumChiWatPriVar_select=false,
    chi(typValChiWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData souAir[nChi](
    redeclare each final package Medium = MediumCon,
    each final nPorts=1,
    each final use_m_flow_in=true)
    "Air flow source"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,-192})));

  // Air loop
  Buildings.Fluid.Sources.Boundary_pT bouCon(
    redeclare final package Medium = MediumCon,
    final nPorts=1)
    "Air pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-80,0})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Chi[nChi]
    "Convert chiller Start/Stop signal into real value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-260,110})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mCon_flow[nChi](
    final k=chi.mConChi_flow_nominal)
    "Compute air mass flow rate at condenser"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-260,70})));
protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-280, 120},{-240,160}}),
    iconTransformation(extent={{-756,-40},{-716,0}})));
equation
  for i in 1:nChi loop
      connect(busWea, souAir[i].weaBus) annotation (Line(
      points={{0,280},{0,260},{-100,260},{-100,-192.2},{-90,-192.2}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(souAir.ports[1], inlConChi.ports_a)
    annotation(Line(
      points={{-70,-192},{-70,-192}},   color={0,127,255}));
  connect(outConChi.port_b, bouCon.ports[1])
    annotation (Line(points={{-60,0},{-70,0}},
     color={0,127,255}));
  connect(y1Chi.y, mCon_flow.u)
    annotation (Line(points={{-260,98},{-260,82}},   color={0,0,127}));
  connect(mCon_flow.y, souAir.m_flow_in) annotation (Line(points={{-260,58},{
          -260,-200},{-90,-200}},        color={0,0,127}));
  connect(busChi.y1, y1Chi.u) annotation (Line(
      points={{-260,140},{-260,122}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.chi, busChi) annotation (Line(
      points={{-300,200},{-280,200},{-280,140},{-260,140}},
      color={255,204,51},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p>
This template represents a chilled water plant with air-cooled compression chillers.
</p>
<p>
The table below lists all available equipment configurations. 
The first option (shown in <b>bold</b>) represents the default plant configuration.
Options shown in <font color=\"gray\"><em>gray italics</em></font> are not currently
supported by the plant controller         
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller</a>
and cannot be selected.
The user may refer to ASHRAE (2021) for further details.
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Configuration parameter</th><th>Options</th><th>Notes</th></tr>
<tr><td>Chiller arrangement</td>
<td>
<b>Parallel chillers</b><br/>
<font color=\"gray\"><em>Series chillers</em></font>
</td>
<td></td>
</tr>
<tr><td>Chiller CHW isolation valve</td>
<td>
<b>Two-way modulating valve</b><br/>
<font color=\"gray\"><em>Two-way two-position valve</em></font><br/>
<font color=\"gray\"><em>No valve</em></font>
</td>
<td>
If the primary CHW pumps are dedicated, the option with no isolation valve
is automatically selected.<br/>
If the primary CHW pumps are headered, the choice between
two-way modulating valves and two-way two-position valves is possible.
A modulating valve is recommended on primary-only variable flow systems
to allow for slow changes in flow during chiller staging.
Sometimes electric valve timing may be sufficiently slow that two-position
valves can provide stable performance.
Two-position valves are acceptable on primary-secondary systems.
</td>
</tr>
<tr><td>CHW distribution</td>
<td>
<b>Variable primary-only</b><br/>
<font color=\"gray\"><em>Constant primary-only</em></font><br/>
<font color=\"gray\"><em>Constant primary-variable secondary</em></font><br/>
<font color=\"gray\"><em>Variable primary-variable secondary with centralized secondary pumps</em></font><br/>
<font color=\"gray\"><em>Variable primary-variable secondary with distributed secondary pumps</em></font>
</td>
<td>
Constant primary-only systems are typically encountered when
only one or two very large air handlers are served by the plant.<br/>
Variable primary-variable secondary with centralized secondary pumps
refers to configurations with a single group of secondary pumps that
is typically integrated into the plant.<br/>
Variable secondary with distributed secondary pumps refers to configurations
with multiple secondary loops, each loop being served by a dedicated group
of secondary pumps.
</td>
</tr>
<tr><td>Primary CHW pump arrangement</td>
<td>
<b>Headered</b><br/>
<font color=\"gray\"><em>Dedicated</em></font>
</td>
<td>
Headered pumps are required (and automatically selected) for configurations with
series chillers.
</td>
</tr>
<tr><td>Type of primary CHW pumps for constant flow configurations</td>
<td>
<font color=\"gray\"><em><b>Constant speed pumps</b></em></font><br/>
<font color=\"gray\"><em>Variable speed pumps operated at a constant speed</em></font>
</td>
<td>
Variable speed pumps operated at a constant speed most commonly applies
to constant flow primary-only plants, for example, a plant serving
only one or two very large air handlers.
</td>
</tr>
<tr><td>Waterside economizer</td>
<td>
<b>No waterside economizer</b>
</td>
<td>Waterside economizers are not supported within air-cooled chiller plants.</td>
</tr>
<tr><td>Controller</td>
<td>
<b>ASHRAE Guideline 36 controller</b>
</td>
<td>An open loop controller is also available for validation purposes only.</td>
</tr>
</table>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirCooled;

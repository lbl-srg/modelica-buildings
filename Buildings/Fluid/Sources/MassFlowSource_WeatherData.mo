within Buildings.Fluid.Sources;
model MassFlowSource_WeatherData
  "Ideal flow source that produces a prescribed mass flow with prescribed
  trace substances, outside specific enthalpy and mass fraction "
  extends Buildings.Fluid.Sources.BaseClasses.PartialAirSource(final verifyInputs=true);
  parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Modelica.Units.SI.MassFlowRate m_flow=0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable=not use_m_flow_in));
  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Dialog(enable = (not use_C_in) and Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s")
    if use_m_flow_in "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}}),
      iconTransformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-18},{-80,22}})));

protected
  Modelica.Blocks.Interfaces.RealOutput TDryBul(
    final unit="K",
    displayUnit="degC")
    "Needed to calculate specific enthalpy";
  Modelica.Blocks.Interfaces.RealOutput pAtm(
    final unit="Pa")
    "Needed to calculate specific enthalpy";
  Modelica.Blocks.Interfaces.RealOutput h_out_internal(
    final unit="J/kg")
    "Needed to connect to conditional connector";

  final parameter Boolean singleSubstance = (Medium.nX == 1)
     "True if single substance medium";
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi if (not singleSubstance)
      "Block to compute water vapor concentration";
  Modelica.Blocks.Interfaces.RealOutput m_flow_in_internal(
    final unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput h_in_internal(
    final unit="J/kg")
    "Needed to connect to conditional connector";

equation
  Modelica.Fluid.Utilities.checkBoundary(
    Medium.mediumName,
    Medium.substanceNames,
    Medium.singleState,
    true,
    X_in_internal,
    "MassFlowSourceFromOutside_h");

  // Connections and calculation to find specific enthalpy
  connect(weaBus.pAtm, pAtm);
  connect(weaBus.TDryBul, TDryBul);
  h_out_internal = Medium.specificEnthalpy(Medium.setState_pTX(
    pAtm, TDryBul, X_in_internal));

  // Connections to compute species concentration
  connect(weaBus.pAtm, x_pTphi.p_in);
  connect(weaBus.TDryBul, x_pTphi.T);
  connect(weaBus.relHum, x_pTphi.phi);
  connect(x_pTphi.X, X_in_internal);

  connect(m_flow_in, m_flow_in_internal);
  connect(C_in, C_in_internal);
  connect(h_out_internal, h_in_internal);

  if singleSubstance then
    X_in_internal = ones(Medium.nX);
  end if;
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;
  if not use_C_in then
    C_in_internal = C;
  end if;

  sum(ports.m_flow) = -m_flow_in_internal;
  connect(medium.h, h_in_internal);
  connect(medium.Xi, Xi_in_internal);
  ports.C_outflow = fill(C_in_internal, nPorts);

  connect(X_in_internal[1:Medium.nXi], Xi_in_internal);

  if not verifyInputs then
    h_in_internal = Medium.h_default;
    p_in_internal = Medium.p_default;
    X_in_internal = Medium.X_default;
    TDryBul       = Medium.T_default;
  end if;

  for i in 1:nPorts loop
    ports[i].p          = p_in_internal;
    ports[i].h_outflow  = h_in_internal;
    ports[i].Xi_outflow = Xi_in_internal;
  end for;

  annotation (defaultComponentName="bou",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{35,45},{100,-45}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          textColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_m_flow_in,
          extent={{-185,132},{-45,100}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          visible=use_C_in,
          extent={{-155,-98},{-35,-126}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C"),        Text(
          extent={{-161,110},{139,150}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
Models an ideal flow source, with prescribed values of flow rate and trace
substances, with temperature and specific enthalpy from outside:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Boundary composition (trace-substance flow).</li>
<li> Outside specific enthalpy.</li>
<li> Multi-substance composition (e.g. water vapor) from outside.</li>
</ul>
<p>If <code>use_m_flow_in</code> is false (default option), the <code>m_flow
</code> parameter is used as boundary flow rate, and the <code>m_flow_in</code>
input connector is disabled;
if <code>use_m_flow_in</code> is true, then the <code>m_flow</code> parameter
is ignored, and the value provided by the input connector is used instead.</p>
<p>The same applies to the trace substances.</p>
<p>The <a href=\"modelica://Buildings.Utilities.Psychrometrics.X_pTphi\">
Buildings.Utilities.Psychrometrics.X_pTphi</a> block is used with the input data
including <code>pAtm</code>, <code>TDryBul</code>, <code>relHum</code> from
weather bus <code>weaBus</code>, to calculate <code>X</code>.</p>
<p>The same applies to the specific enthalpy.</p>
<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 09, 2023, by Jianjun Hu:<br/>
Changed base class to constrain medium to moist air.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1681\">IBPSA, #1681</a>.
</li>
<li>
November 14, 2019, by Michael Wetter:<br/>
Removed duplicate connector.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1248\"> #1248</a>.
</li>
<li>
January 14, 2019 by Jianjun Hu:<br/>
Changed to extend <a href=\"modelica://Buildings.Fluid.Sources.BaseClasses.PartialSource\">
Buildings.Fluid.Sources.BaseClasses.PartialSource</a>. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\"> #1050</a>.
</li>
<li>
May 21, 2017, by Jianjun Hu:<br/>
First implementation. Created flow source with prescribed mass flow and trace
substances, outside enthalpy and composition. Weather bus is used.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/777\">#777</a>.
</li>
</ul>
</html>"));
end MassFlowSource_WeatherData;

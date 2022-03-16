within Buildings.Fluid.Geothermal.Boreholes;
model UTube "Single U-tube borehole heat exchanger"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    show_T=true);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=false, final linearizeFlowResistance=false);
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic matSoi
    "Thermal properties of soil"
    annotation (choicesAllMatching=true, Dialog(group="Soil"),
    Placement(transformation(extent={{2,70},{22,90}})));
  replaceable parameter Buildings.HeatTransfer.Data.BoreholeFillings.Generic matFil
    "Thermal properties of the filling material"
    annotation (choicesAllMatching=true, Dialog(group="Borehole"),
    Placement(transformation(extent={{-68,70},{-48,90}})));

  parameter Modelica.Units.SI.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.ThermalConductivity kTub=0.5
    "Thermal conductivity of the tube" annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length eTub=0.002 "Thickness of a tube"
    annotation (Dialog(group="Tubes"));

  parameter Modelica.Units.SI.Height hBor "Total height of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Integer nVer=10
    "Number of segments used for discretization in the vertical direction"
      annotation(Dialog(group="Borehole"));
  parameter Modelica.Units.SI.Radius rBor=0.1 "Radius of the borehole";

  parameter Modelica.Units.SI.Radius rExt=3
    "Radius of the soil used for the external boundary condition"
    annotation (Dialog(group="Soil"));
  parameter Integer nHor(min=1) = 10
    "Number of state variables in each horizontal layer of the soil"
    annotation (Dialog(group="Soil"));

  parameter Modelica.Units.SI.Temperature TExt0_start=283.15
    "Initial far field temperature"
    annotation (Dialog(tab="Initial temperature", group="Soil"));
  parameter Modelica.Units.SI.Temperature TExt_start[nVer]={if z[i] >= z0 then
      TExt0_start + (z[i] - z0)*dT_dz else TExt0_start for i in 1:nVer}
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Initial temperature", group="Soil"));

  parameter Modelica.Units.SI.Temperature TFil0_start=TExt0_start
    "Initial temperature of the filling material for h = 0...z0"
    annotation (Dialog(tab="Initial temperature", group="Filling material"));
  parameter Modelica.Units.SI.Temperature TFil_start[nVer]=TExt_start
    "Temperature of the undisturbed ground"
    annotation (Dialog(tab="Initial temperature", group="Filling material"));

  parameter Modelica.Units.SI.Height z0=10
    "Depth below which the temperature gradient starts"
    annotation (Dialog(tab="Initial temperature", group="Temperature profile"));
  parameter Real dT_dz(unit="K/m") = 0.01
    "Vertical temperature gradient of the undisturbed soil for h below z0"
    annotation (Dialog(tab="Initial temperature", group="Temperature profile"));

  parameter Modelica.Units.SI.Time samplePeriod
    "Sample period for the external boundary condition"
    annotation (Dialog(group="Soil"));
  parameter Modelica.Units.SI.Length xC=0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Borehole"));
  parameter Real B0=17.44 "Shape coefficient for grout resistance"
    annotation(Dialog(group="Borehole"));
  parameter Real B1=-0.605 "Shape coefficient for grout resistance"
    annotation(Dialog(group="Borehole"));

  Buildings.Fluid.Geothermal.Boreholes.BaseClasses.BoreholeSegment borHol[nVer](
    redeclare each final package Medium = Medium,
    each final matSoi=matSoi,
    each final matFil=matFil,
    each final hSeg=hBor/nVer,
    each final samplePeriod=samplePeriod,
    each final rTub=rTub,
    each final rBor=rBor,
    each final rExt=rExt,
    each final xC=xC,
    each final eTub=eTub,
    each final kTub=kTub,
    each final nSta=nHor,
    each final m_flow_nominal=m_flow_nominal,
    each final m_flow_small=m_flow_small,
    final dp_nominal={if i == 1 then dp_nominal else 0 for i in 1:nVer},
    TExt_start=TExt_start,
    TFil_start=TExt_start,
    each final homotopyInitialization=homotopyInitialization,
    each final show_T=show_T,
    each final computeFlowResistance=computeFlowResistance,
    each final from_dp=from_dp,
    each final linearizeFlowResistance=linearizeFlowResistance,
    each final deltaM=deltaM,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each T_start=T_start,
    each X_start=X_start,
    each C_start=C_start,
    each C_nominal=C_nominal,
    each allowFlowReversal=allowFlowReversal) "Discretized borehole segments"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Units.SI.Temperature Tdown[nVer] "Medium temperature in pipe 1";
  Modelica.Units.SI.Temperature Tup[nVer] "Medium temperature in pipe 2";
protected
  parameter Modelica.Units.SI.Height z[nVer]={hBor/nVer*(i - 0.5) for i in 1:
      nVer} "Distance from the surface to the considered segment";

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  Tdown[:] = borHol[:].pipFil.vol1.heatPort.T;
  Tup[:] = borHol[:].pipFil.vol2.heatPort.T;
  connect(port_a, borHol[1].port_a1) annotation (Line(
      points={{-100,5.55112e-16},{-60,5.55112e-16},{-60,6},{-20,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, borHol[1].port_b2) annotation (Line(
      points={{100,5.55112e-16},{20,5.55112e-16},{20,-40},{-40,-40},{-40,-6},{
          -20,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHol[nVer].port_b1, borHol[nVer].port_a2) annotation (Line(
      points={{5.55112e-16,6},{10,6},{10,-6},{5.55112e-16,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nVer - 1 loop
    connect(borHol[i].port_b1, borHol[i + 1].port_a1) annotation (Line(
        points={{5.55112e-16,6},{5.55112e-16,20},{-20,20},{-20,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(borHol[i].port_a2, borHol[i + 1].port_b2) annotation (Line(
        points={{5.55112e-16,-6},{5.55112e-16,-20},{-20,-20},{-20,-6}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;
    annotation (
    defaultComponentName="borehole",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,-52},{62,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,58},{62,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,6},{62,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,92},{46,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,-88},{-46,92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,80},{-62,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{62,80},{72,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}),
    Documentation(info="<html>
<p>
Model of a single U-tube borehole heat exchanger.
The borehole heat exchanger is vertically discretized into <i>n<sub>seg</sub></i>
elements of height <i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
Each segment contains a model for the heat transfer in the borehole,
for heat transfer in the soil and for the far-field boundary condition.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer coefficient
that depends on the fluid velocity, a heat resistance between the two pipes, and
a heat resistance between the pipes and the circumference of the borehole.
The heat capacity of the fluid, and the heat capacity of the grout, is taken into account.
The thermal resistance and capacity network inside the borehole is computed according
to Bauer et al., (2011).
</p>
<p>
The heat transfer in the soil is computed using transient heat conduction in cylindrical
coordinates for the spatial domain <i>r<sub>bor</sub> &le; r &le; r<sub>ext</sub></i>.
In the radial direction, the spatial domain is discretized into
<i>n<sub>hor</sub></i> segments with uniform material properties.
Thermal properties can be specified separately for each horizontal layer.
</p>
<p>
The far-field temperature, i.e., the temperature at the radius
<i>r<sub>ext</sub></i>, is computed using a power-series solution
to a line-source heat transfer problem. This temperature boundary condition
is updated every <i>t<sub>sample</sub></i> seconds.
</p>
<p>
The initial far-field temperature <i>T<sub>ext,start</sub></i>, which
is the temperature of the soil at a radius <i>r<sub>ext</sub></i>,
is computed
as a function of the depth <i>z &gt; 0</i>.
For a depth between <i>0 &le; z &le; z<sub>0</sub></i>, the temperature
is set to <i>T<sub>ext,0,start</sub></i>.
The value of <i>z<sub>0</sub></i> is a parameter with a default of 10 meters.
However, there is large variability in the depth where the undisturbed soil temperature
starts.
For a depth of <i>z<sub>0</sub> &le; z &le; h<sub>bor</sub></i>,
the temperature is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  T<sup>i</sup><sub>ext,start</sub> = T<sub>ext,0,start</sub> + (z<sup>i</sup> - z<sub>0</sub>)  dT &frasl; dz
</p>
<p>
with <i>i &isin; {1, ..., n<sub>ver</sub>}</i>,
where the temperature gradient <i>dT &frasl; dz &ge; 0</i> is a parameter.
As with <i>z<sub>0</sub></i>, there is large variability in
<i>dT &frasl; dz &ge; 0</i>. The default value is set to <i>1</i> Kelvin per 100 meters.
For the temperature of the grout, the same equations are applied, with
<i>T<sub>ext,0,start</sub></i> replaced with
<i>T<sub>fil,0,start</sub></i>, and
<i>T<sup>i</sup><sub>ext,start</sub></i> replaced with
<i>T<sup>i</sup><sub>fil,start</sub></i>.
The default setting uses the same temperature for the soil and the filling material.
</p>
<h4>Assumptions and limitations</h4>
<p>
The vertical heat flow is assumed to be zero and hence there is no heat flow from
the ground surface to the soil that could be used to regenerate the soil temperature.
</p>
<p>
There is no ground water flow.
</p>
<h4>Implementation</h4>
<p>
Each horizontal layer is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.BoreholeSegment\">
Buildings.HeatExchangers.Fluid.Boreholes.BaseClasses.BoreholeSegment</a>.
This model is composed of the model
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.HexInternalElement\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.HexInternalElement</a> which computes
the heat transfer in the pipes and the borehole filling,
of the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.SingleLayerCylinder\">
Buildings.HeatTransfer.Conduction.SingleLayerCylinder</a> which computes
the heat transfer in the soil, and
of the model
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.SingleUTubeBoundaryCondition\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.SingleUTubeBoundaryCondition</a> which computes
the far-field temperature boundary condition.
The thermal resistor and capacitor network is computed in
<a href=\"modelica://Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances\">
Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances</a>.
</p>
<h4>References</h4>
<p>
D. Bauer, W. Heidemann, H. M&uuml;ller-Steinhagen, and H.-J. G. Diersch.
<i>
<a href=\"http://dx.doi.org/10.1002/er.1689\">
Thermal resistance and capacity models for borehole heat exchangers
</a>
</i>.
International Journal Of Energy Research, 35:312&ndash;320, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
December 23, 2015, by Michael Wetter:<br/>
Updated documentation and added section about model assumptions and limitations.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 27, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> in propagation of material properties.
</li>
<li>
August 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end UTube;

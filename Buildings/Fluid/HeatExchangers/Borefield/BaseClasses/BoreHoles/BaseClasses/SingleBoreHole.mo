within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model SingleBoreHole "Single U-tube borehole heat exchanger"

  extends Interface.PartialSingleBoreHole(final m_flow_nominal = gen.m_flow_nominal_bh,final T_start=gen.T_start,final dp_nominal=gen.dp_nominal);

  BaseClasses.BoreHoleSegmentFourPort borHolSeg[gen.nVer](
    redeclare each package Medium =  Medium,
    each final   soi=soi,
    each final   fil=fil,
    each final   gen=gen,
    final dp_nominal={if i == 1 then gen.dp_nominal else 0 for i in 1:gen.nVer},
    TExt_start=gen.TExt_start,
    TFil_start=gen.TExt_start,
    each final   show_T=show_T,
    each final   computeFlowResistance=computeFlowResistance,
    each final   from_dp=from_dp,
    each final   linearizeFlowResistance=linearizeFlowResistance,
    each final   deltaM=deltaM,
    each final   energyDynamics=energyDynamics,
    each final   massDynamics=massDynamics,
    each final   p_start=p_start,
    each T_start=gen.T_start,
    each X_start=X_start,
    each C_start=C_start,
    each C_nominal=C_nominal) "Discretized borehole segments"
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));

  Modelica.SIunits.Temperature TDown[gen.nVer] "Medium temperature in pipe 1";
  Modelica.SIunits.Temperature TUp[gen.nVer] "Medium temperature in pipe 2";

equation
  TWallAve = sum(borHolSeg[:].intHEX.port.T)/gen.nVer;

  TDown[:] = borHolSeg[:].intHEX.vol1.heatPort.T;
  TUp[:] = borHolSeg[:].intHEX.vol2.heatPort.T;
  connect(port_a, borHolSeg[1].port_a1) annotation (Line(
      points={{-100,5.55112e-016},{-60,5.55112e-016},{-60,6},{-18,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, borHolSeg[1].port_b2) annotation (Line(
      points={{100,5.55112e-016},{20,5.55112e-016},{20,-40},{-40,-40},{-40,-6},
          {-18,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHolSeg[gen.nVer].port_b1, borHolSeg[gen.nVer].port_a2) annotation (
     Line(
      points={{5.55112e-16,6},{10,6},{10,-6},{5.55112e-16,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:gen.nVer - 1 loop
    connect(borHolSeg[i].port_b1, borHolSeg[i + 1].port_a1) annotation (Line(
        points={{2,6},{2,20},{-18,20},{-18,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(borHolSeg[i].port_a2, borHolSeg[i + 1].port_b2) annotation (Line(
        points={{2,-6},{2,-20},{-18,-20},{-18,-6}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;
  annotation (
    Dialog(group="Borehole"),
    Dialog(group="Borehole"),
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
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString=""),Text(
          extent={{50,-32},{90,-38}},
          lineColor={0,0,255},
          textString="")}),
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
All thermal mass is assumed to be at the two bulk temperatures of the down-flowing 
and up-flowing fluid.
</p>
<p>
The heat transfer in the soil is computed using transient heat conduction in cylindrical
coordinates for the spatial domain <i>r<sub>bor</sub> &le; r &le; r<sub>ext</sub></i>. 
In the radial direction, the spatial domain is discretized into 
<i>n<sub>hor</sub></i> segments with uniform material properties.
Thermal properties can be specified separately for each horizontal layer.
The vertical heat flow is assumed to be zero, and there is assumed to be 
no ground water flow. 
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
<h4>Implementation</h4>
<p>
Each horizontal layer is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.BoreholeSegment\">
Buildings.HeatExchangers.Fluid.Boreholes.BaseClasses.BoreholeSegment</a>.
This model is composed of the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement</a> which computes
the heat transfer in the pipes and the borehole filling,
of the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.SingleLayerCylinder\">
Buildings.HeatTransfer.Conduction.SingleLayerCylinder</a> which computes
the heat transfer in the soil, and
of the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.TemperatureBoundaryCondition\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.TemperatureBoundaryCondition</a> which computes
the far-field temperature boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end SingleBoreHole;

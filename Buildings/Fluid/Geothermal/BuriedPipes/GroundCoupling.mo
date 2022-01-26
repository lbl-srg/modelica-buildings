within Buildings.Fluid.Geothermal.BuriedPipes;
model GroundCoupling "Thermal coupling between buried pipes and ground"
  parameter Integer nPip(min=1) "Number of buried pipes";
  parameter Integer nSeg(min=1) = 1 "Number of axial segments";

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat
    "Soil thermal properties";
  replaceable parameter
    Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic
    cliCon "Surface temperature climatic conditions";

  parameter Modelica.Units.SI.Length len[nSeg] "Pipes length";

  parameter Modelica.Units.SI.Length dep[nPip] "Pipes buried depth";
  parameter Modelica.Units.SI.Length pos[nPip]
    "Pipes horizontal coordinate (to an arbitrary reference point)";
  parameter Modelica.Units.SI.Length rad[nPip] "Pipes external radius";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a ports[nPip, nSeg]
    "Buried pipes heatports"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={0,-100})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    soi(cliCon=cliCon, soiDat=soiDat, dep=depMea) "Soil temperature";

protected
  parameter Modelica.Units.SI.Length depMea=sum(dep)/nPip "Average depth";
  parameter Real P[nPip,nPip]=BaseClasses.groundCouplingFactors(
      nPip,
      dep,
      pos,
      rad) "Thermal coupling geometric factors";

equation
  for seg in 1:nSeg loop
    ports[:,seg].T .- soi.T = P * ports[:,seg].Q_flow /
        (2 * Modelica.Constants.pi * soiDat.k * len[seg]);
  end for;

  annotation (Icon(graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,26},{100,100}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,20},{100,26}},
          lineColor={0,0,0},
          fillColor={0,255,128},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,0},
          fillColor={211,168,137},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-74,4},{-36,-34}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-70,0},{-40,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,-26},{26,-68}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-28},{24,-66}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,-10},{78,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,-12},{76,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-56,-14},{-84,-14}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{4,-48},{-24,-48}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{64,-24},{36,-24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-80,24},{-80,-10}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-20,24},{-20,-44}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{40,24},{40,-22}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-56,-14},{-56,-66}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{4,-48},{4,-76}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{64,-24},{64,-86}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-82,-64},{-58,-64}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-82,-74},{0,-74}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-82,-84},{60,-84}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-56,-14},{-46,0}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{4,-48},{18,-32}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{64,-24},{72,-14}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-76,-54},{-62,-64}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="pos[1]"),
        Text(
          extent={{-26,-64},{-12,-74}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="pos[2]"),
        Text(
          extent={{40,-74},{54,-84}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="pos[3]"),
        Text(
          extent={{7,-3},{-7,3}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="dep[1]",
          origin={-85,7},
          rotation=90),
        Text(
          extent={{7,-3},{-7,3}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          origin={-25,7},
          rotation=90,
          textString="dep[2]"),
        Text(
          extent={{7,-3},{-7,3}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          origin={35,7},
          rotation=90,
          textString="dep[3]"),
        Text(
          extent={{-64,-2},{-52,-8}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="rad[1]"),
        Text(
          extent={{0,-32},{12,-38}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="rad[2]"),
        Text(
          extent={{54,-14},{66,-20}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="rad[3]"),
        Line(
          points={{-84,-52},{-84,-92}},
          color={0,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p>
This model simulates the heat transfer between multiple buried pipes and the 
ground, using climate and soil information and the geometry of the pipes 
network.
</p>
<p>
The model can take any number of pipes, and can be discretized axially 
in any number of segments. Currently, the model only allows for pipes 
that run co-axially and parallel to the ground, and the axial segmentation 
must be the same for each pipe.
</p>
<p>
The heat transfer solution is based upon the potential flow theory and 
obtained by the use of \"mirror-image\" technique suggested by Eckert (1959).
This technique is extended to a network with multiple pipes by Kusuda (1981) 
in the equation:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/BuriedPipes/GroundCoupling.svg\" />
</p>
<p>
where: <br>
<i>L</i> = pipe length [m] <br>
<i>k<sub>s</sub></i> = soil thermal conductivity [W/(m.K)] <br>
<i>P<sub>ij</sub></i> = geometric factor (see 
<a href=\"modelica://Buildings.Fluid.Geothermal.BuriedPipes.BaseClasses.groundCouplingFactors\">
Buildings.Fluid.Geothermal.BuriedPipes.BaseClasses.groundCouplingFactors</a>
for more information) <br>
<i>Q<sub>i</sub></i> = net heat transfer from pipe <i>i</i> [W]<br>
<i>T<sub>i</sub></i> = temperature at the exterior surface of pipe <i>i</i> [degC]<br>
<i>T<sub>g</sub></i> = undisturbed ground temperature at the depth of the 
network. [degC]
</p>
<p>
This model relies on the following assumptions.
</p>
<ul>
<li>Heat transfer is in steady state.</li>
<li>The heat transfer is radial (no axial diffusion).</li>
<li>The exterior surfaces for each pipe segment are isothermic planes.</li>
<li>The ground surface is an isothermic plane.</li>
<li>The soil conductivity is homogeneous and isotropic.</li>
</ul>
<h4>References</h4>
<p>
Eckert, E. R. G. (1959). <i>Heat and Mass Transfer</i>. McGraw-Hill Book Company.<br/>
Kusuda, T. (1981). <i>Heat transfer analysis of underground heat 
and chilled-water distribution systems</i>. National Bureau of Standards.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroundCoupling;

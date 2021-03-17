within Buildings.Fluid.BuriedPipes;
model GroundCoupling
  parameter Integer nPipes(min=1, fixed=true) "Number of buried pipes";

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soil "Soil thermal properties";
  replaceable parameter Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Generic climate "Climatic Conditions";

  parameter Modelica.SIunits.Length len "Pipes length";

  parameter Modelica.SIunits.Length dep[nPipes] "Pipes Buried Depth";
  parameter Modelica.SIunits.Length pos[nPipes] "Pipes Horizontal Coordinate (to an arbitrary reference point)";
  parameter Modelica.SIunits.Length rad[nPipes] "Pipes external radius";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a ports[nPipes] "Buried pipes heatports" annotation (Placement(transformation(extent={{82,-34},
            {102,46}}), iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={0,-100})));

  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature soi(climate=climate, soil=soil, depth=depMea) "Soil temperature";

protected
  parameter Modelica.SIunits.Length depMea = sum(dep) / nPipes "Average depth";
  parameter Real P[nPipes,nPipes] = BaseClasses.make_ground_coupling_factors(
          nPipes, dep, pos, rad) "Thermal coupling geometric factors";

equation
  ports.T .- soi.port.T = P * ports.Q_flow / (2 * Modelica.Constants.pi * soil.k * len);

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,26},{100,100}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,20},{100,26}},
          lineColor={0,0,0},
          fillColor={0,140,72},
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
          points={{-94,-64},{-58,-64}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-94,-74},{2,-74}},
          color={0,0,0},
          thickness=0.5,
          arrow={Arrow.Open,Arrow.Open}),
        Line(
          points={{-94,-84},{62,-84}},
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
          extent={{-84,-54},{-70,-64}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="pos[1]"),
        Text(
          extent={{-32,-64},{-18,-74}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="pos[2]"),
        Text(
          extent={{40,-74},{54,-84}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="pos[3]"),
        Text(
          extent={{7,-3},{-7,3}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="dep[1]",
          origin={-85,7},
          rotation=90),
        Text(
          extent={{7,-3},{-7,3}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          origin={-25,7},
          rotation=90,
          textString="dep[2]"),
        Text(
          extent={{7,-3},{-7,3}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          origin={35,7},
          rotation=90,
          textString="dep[3]"),
        Text(
          extent={{-64,-2},{-52,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="rad[1]"),
        Text(
          extent={{0,-32},{12,-38}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="rad[2]"),
        Text(
          extent={{54,-14},{66,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={122,20,25},
          fillPattern=FillPattern.Solid,
          textString="rad[3]"),
        Line(
          points={{-96,-52},{-96,-92}},
          color={0,0,0},
          thickness=0.5)}));
end GroundCoupling;

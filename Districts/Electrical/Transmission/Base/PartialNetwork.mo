within Districts.Electrical.Transmission.Base;
partial model PartialNetwork "Partial model that represent an electric network"
  replaceable parameter Districts.Electrical.Transmission.Grids.PartialGrid grid
    "Record that describe the grid (number of nodes, links, connections, etc.)"
    annotation (choicesAllMatching=true);
  replaceable Districts.Electrical.Interfaces.Terminal terminal[grid.Nnodes]
    "Electric terminals for each node of the network"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  replaceable Districts.Electrical.Transmission.Base.PartialLine lines[grid.Nlinks](
      each mode = Districts.Electrical.Types.CableMode.commercial,
      l = grid.L,
      commercialCable = grid.cables,
      each P_nominal = 0,
      each V_nominal = 220)
    "Array of line models. Each line connect two nodes of the grid";
equation
  for i in 1:grid.Nlinks loop
    connect(lines[i].terminal_p, terminal[grid.FromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.FromTo[i,2]]);
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Ellipse(
          extent={{-6,86},{6,74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-86,46},{-74,34}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-24},{-24,-36}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{74,46},{86,34}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{74,-54},{86,-66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,-74},{6,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-66,6},{-54,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{54,6},{66,-6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,40},{0,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,0},{0,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-80},{60,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-32,-28},{-60,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,40},{0,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-80},{0,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{80,-62},{80,40}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-140,140},{140,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}));
end PartialNetwork;

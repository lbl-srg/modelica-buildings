within Buildings.Fluid.Storage;
  model StratifiedMultipleInlet "Stratified tank with a default inlet and outlet at the top and bottom and an inlet and outlet at a user defined height."
    extends Buildings.Fluid.Storage.Stratified(final nPorts = {if i==nVolIn or i==nVolOut then 3 else 2 for i in 1:nSeg});
    parameter Integer nVolIn(min=1,max=nSeg) = 1
      "Position where to inject the fluid, starting from the uppermost layer";
    parameter Integer nVolOut(min=1,max=nSeg) = nSeg
      "Position where to extract the fluid, starting from the uppermost layer";
    Modelica.Fluid.Interfaces.FluidPort_a port_a2(
      redeclare final package Medium = Medium,
       m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,-110},{-30,-90}}),
          iconTransformation(extent={{-50,-110},{-30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b2(
      redeclare final package Medium = Medium,
      m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,-110},{30,-90}}),iconTransformation(extent={{50,-110},
              {30,-90}})));
  equation
    connect(port_a2,vol[nVolIn].ports[3]);
    connect(port_b2,vol[nVolOut].ports[3]);

    connect(port_a2, port_a2) annotation (Line(points={{-40,-100},{-40,-97},{-40,
            -97},{-40,-100}}, color={0,127,255}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{52,1},{-52,-1}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            origin={-45,-50},
            rotation=90,
            lineThickness=0.5),
          Rectangle(
            extent={{51,1},{-51,-1}},
            lineColor={0,0,255},
            pattern=LinePattern.None,
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            origin={45,-49},
            rotation=90,
            lineThickness=0.5),
          Line(
            points={{-44,0},{-38,34},{-44,0},{-34,0},{-44,0},{-34,-32}},
            color={0,0,127},
            thickness=1),
          Line(
            points={{46,0},{36,34},{46,0},{32,0},{46,0},{32,-32}},
            color={0,0,127},
            thickness=1)}),
  Documentation(info="<html>
<p>
This is a model of a stratified storage tank.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">
Buildings.Fluid.Storage.UsersGuide</a>
for more information.
</p>
<p>
For a model with enhanced stratification, use
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
June 16, 2015, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
  end StratifiedMultipleInlet;
within Buildings.Electrical.Examples.BaseClasses;
model Cable

  AC.OnePhase.Lines.TwoPortRL line(
    V_nominal=V_nominal,
    R=R,
    L=L) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Modelica.SIunits.Voltage V_nominal=15000
    "Nominal voltage at district level";
  parameter Modelica.SIunits.Length l(min=0) "Length of the line";
  AC.OnePhase.Interfaces.Terminal_p n
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  AC.OnePhase.Interfaces.Terminal_n p annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{
            -90,10}})));
protected
  parameter Modelica.SIunits.Resistance R = RCha*l
    "Resistance at temperature T_ref";
  parameter Modelica.SIunits.Inductance L = XCha*l/omega "Inductance";
  parameter Buildings.Electrical.Types.CharacteristicResistance RCha=0.5e-003;
  parameter Buildings.Electrical.Types.CharacteristicReactance XCha=0.1e-003;
  parameter Modelica.SIunits.AngularVelocity omega = 2*Modelica.Constants.pi*f;
  parameter Modelica.SIunits.Frequency f = 50
    "Frequency for which cabple properties are computed";
equation
  connect(line.terminal_n, p) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, n) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-72,10},{-52,-10}},
          lineColor={0,0,0},
          fillColor={0,94,94},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,10},{58,-10}},
          fillColor={0,94,94},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{48,10},{68,-10}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,0},{-92,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,10},{58,10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-62,-10},{58,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{94,0},{58,0}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Cable;

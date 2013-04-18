within Districts.Electrical.AC.Sources;
model VoltageSource "Constant AC voltage"
  extends Districts.Electrical.AC.Sources.BaseClasses.SinglePhaseSource;
  parameter Modelica.SIunits.Frequency f(start=1) "frequency of the source";
  parameter Modelica.SIunits.Voltage V(start=1) "RMS voltage of the source";
  parameter Modelica.SIunits.Angle phi(start=0) "phase shift of the source";
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=f,
    V=V,
    phi=phi) annotation (Placement(transformation(extent={{-14,-10},{6,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin n
    "Negative pin"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation

  connect(voltageSource.pin_p, sPhasePlug.phase[1]) annotation (Line(
      points={{-14,4.44089e-16},{-10,4.44089e-16},{-10,0},{-100,0},{-100,
          4.44089e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_n, sPhasePlug.neutral) annotation (Line(
      points={{6,0},{20,0},{20,-18},{-56,-18},{-56,8.88178e-16},{-100,
          8.88178e-16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_n, n) annotation (Line(
      points={{6,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-124,50},{-24,0}},
          lineColor={0,0,255},
          textString=
                  "+"),
        Text(
          extent={{26,48},{126,-2}},
          lineColor={0,0,255},
          textString=
                  "-"),
        Line(points={{50,0},{-50,0}}, color={0,0,0}),
        Line(
          points={{-60,0},{-92,0}},
          color={0,0,0},
          smooth=Smooth.None)}),
      Documentation(info="<html>

<p>
This is a constant voltage source, specifying the complex voltage by the RMS voltage and the phase shift.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end VoltageSource;

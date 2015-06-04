within Buildings.HeatTransfer.Radiosity.Examples;
model OpaqueSurface "Test model for indoor source as an opaque surface"
  extends Modelica.Icons.Example;

  Buildings.HeatTransfer.Sources.FixedTemperature T2(T=303.15)
    "Boundary condition for surface 2"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.HeatTransfer.Radiosity.OpaqueSurface bod1( absIR=0.3, A=1)
    "Surface 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.HeatTransfer.Sources.FixedTemperature T1(T=293.15)
    "Boundary condition for surface 1"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.HeatTransfer.Radiosity.OpaqueSurface bod2( absIR=0.3, A=1)
    "Surface 2"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
equation
  connect(T1.port, bod1.heatPort) annotation (Line(
      points={{-60,-10},{-49.2,-10},{-49.2,20.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T2.port, bod2.heatPort) annotation (Line(
      points={{40,-10},{49.2,-10},{49.2,20.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bod1.JOut, bod2.JIn) annotation (Line(
      points={{-39,34},{12,34},{12,26},{39,26}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(bod2.JOut, bod1.JIn) annotation (Line(
      points={{39,34},{16,34},{16,24},{-20,24},{-20,26},{-39,26}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Radiosity/Examples/OpaqueSurface.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples demonstrates two opaque surfaces that radiate toward each other.
The model assumes that the view factor between the surfaces is equal to one.
</p>
</html>"));
end OpaqueSurface;

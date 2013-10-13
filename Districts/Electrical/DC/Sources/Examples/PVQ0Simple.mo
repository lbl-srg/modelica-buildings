within Districts.Electrical.DC.Sources.Examples;
model PVQ0Simple "Example for the PVSimple model with constant load"
  import Districts;
  extends Modelica.Icons.Example;
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-92,-40},{-72,-20}})));
  Districts.Electrical.DC.Loads.Resistor    res(R=0.5)
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Districts.Electrical.DC.Lines.TwoPortResistance lin(R=0.05)
    "Transmission line"
    annotation (Placement(transformation(extent={{-38,30},{-18,50}})));
  Districts.Electrical.DC.Sources.Examples.BaseClasses.IrradiationSimple
    irradiationSimple
    annotation (Placement(transformation(extent={{-52,78},{-32,98}})));
  Districts.Electrical.DC.Sources.Examples.BaseClasses.PVSimpleR0 pVSimpleR0_1(
      A=10) annotation (Placement(transformation(extent={{36,30},{56,50}})));
equation
  connect(sou.terminal, res.terminal) annotation (Line(
      points={{-62,0},{-2,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, ground.p) annotation (Line(
      points={{-82,0},{-82,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lin.terminal_n, res.terminal) annotation (Line(
      points={{-38,40},{-50,40},{-50,0},{-2,0},{-2,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pVSimpleR0_1.terminal, lin.terminal_p) annotation (Line(
      points={{36,40},{-18,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(irradiationSimple.solarIrradiation, pVSimpleR0_1.G) annotation (Line(
      points={{-31.8,87.8},{46,87.8},{46,52}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-140,
            -100},{100,140}}),      graphics),
    experiment(StopTime=172800, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of the photovoltaic model.
The total solar irradiation is computed based
on a weather data file. 
The PV is connected to a circuit that has a constant voltage
source and a resistance.
This voltage source may be a DC grid to which the 
circuit is connected.
The power sensor shows how much electrical power is consumed or fed into the voltage source.
In actual systems, the voltage source may be an AC/DC converter.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 4, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/DC/Sources/Examples/PVSimple.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end PVQ0Simple;

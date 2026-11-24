within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation;
model CylindricalSteadyState "Test the steady-state heat conduction of the Cylindrical model"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Temperature TExt=293.15
    "Temperature at the external surface";
  parameter Modelica.Units.SI.Radius r_a=0.075 "Internal radius";
  parameter Modelica.Units.SI.Radius r_b=3 "External radius";
  parameter Modelica.Units.SI.Height h=1 "Height of the cylinder";
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Soil.Template soiDat=
    Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone(cSoi=0)
    "Soil data record without heat capacity, hence steady-state heat conduction";

  Modelica.Units.SI.HeatFlowRate QAna_flow =
    2*Modelica.Constants.pi*soiDat.kSoi*h*(soiSma.port_a.T - TExt)/Modelica.Math.log(r_b/r_a)
    "Analytical steady-state heat flow rate";

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical soiSma(
    soiDat=soiDat,
    h=h,
    r_a=r_a,
    r_b=r_b,
    nSta=4,
    TInt_start=TExt,
    TExt_start=TExt) "Cylinder discretized with four cells"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical soiLar(
    soiDat=soiDat,
    h=h,
    r_a=r_a,
    r_b=r_b,
    nSta=20,
    gridFac=1.2,
    tMinEsk=3600,
    TInt_start=TExt,
    TExt_start=TExt) "Cylinder discretized with twenty cells"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Modelica.Blocks.Sources.Ramp ram(
    duration=3600,
    height=10,
    offset=TExt) "Increase the temperature at the internal surface"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribe the temperature at the internal surface"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.HeatTransfer.Sources.FixedTemperature fixTem(T=TExt)
    "Fix the temperature at the external surface"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
equation
  assert(soiDat.steadyState,
    "Error: The soil data record does not trigger steady-state heat conduction.");
  assert(abs(soiSma.port_a.Q_flow - QAna_flow) <= 1E-6*max(abs(QAna_flow), 1E-3),
    "Error: The steady-state heat flow rate is not the analytical solution.");
  assert(abs(soiLar.port_a.Q_flow - soiSma.port_a.Q_flow) <=
    1E-6*max(abs(QAna_flow), 1E-3),
    "Error: The steady-state heat flow rate depends on the discretization.");

  connect(ram.y, preTem.T) annotation (Line(points={{-69,20},{-62,20}},
          color={0,0,127}));
  connect(preTem.port, soiSma.port_a) annotation (Line(points={{-40,20},{-10,20}},
          color={191,0,0}));
  connect(preTem.port, soiLar.port_a) annotation (Line(points={{-40,20},{-30,20},
          {-30,-20},{-10,-20}}, color={191,0,0}));
  connect(fixTem.port, soiSma.port_b) annotation (Line(points={{40,20},{10,20}},
          color={191,0,0}));
  connect(fixTem.port, soiLar.port_b) annotation (Line(points={{40,20},{30,20},{
          30,-20},{10,-20}}, color={191,0,0}));
  annotation (
    experiment(StopTime=7200, Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/Validation/CylindricalSteadyState.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the steady-state heat conduction computed by
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical</a>.
</p>
<p>
To the two cylinders, whose heat capacity is set to zero by
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone\">
Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone</a> with
<code>cSoi=0</code>, a temperature that ramps up over one hour is applied at the
internal surface, while the external surface is kept at a constant temperature.
The model asserts that
</p>
<ul>
<li>
the heat flow rate at the internal surface is equal to the analytical solution
<span style=\"font-style:italic;\">Q = 2&pi;k h (T<sub>a</sub>-T<sub>b</sub>)/ln(r<sub>b</sub>/r<sub>a</sub>)</span>, and
</li>
<li>
the heat flow rate is the same for both cylinders, although they are discretized
with <code>nSta=4</code> and <code>nSta=20</code> cells, and with different values of
<code>gridFac</code> and <code>tMinEsk</code>.
</li>
</ul>
<p>
The second assertion holds because the thermal resistances of the cells are in series,
such that their sum is independent of the grid, as long as the grid is strictly
increasing.
</p>
</html>", revisions="<html>
<ul>
<li>
November 20, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CylindricalSteadyState;

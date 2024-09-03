within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model InternalResistancesOneUTube "Validation of InternalResistancesOneUTube"
  extends Modelica.Icons.Example;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Length hSeg=borFieDat.conDat.hBor/nSeg
    "Length of the internal heat exchanger";
  parameter Modelica.Units.SI.ThermalResistance Rgb_val=0.0430511
    "Grout node to borehole wall thermal resistance";
  parameter Modelica.Units.SI.ThermalResistance Rgg_val=0.00605573
    "Grout node to grout node thermal resistance";
  parameter Modelica.Units.SI.ThermalResistance RCondGro_val=0.14285
    "Pipe to grout node thermal resistance";
  parameter Modelica.Units.SI.Temperature T_start=298.15 "Initial temperature";

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesOneUTube
    intRes1UTub(
    hSeg=hSeg,
    T_start=T_start,
    borFieDat=borFieDat,
    Rgb_val=Rgb_val,
    RCondGro_val=RCondGro_val,
    Rgg_val=Rgg_val,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                     "Thermal resistance and capacitances of the borehole"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TWal(T=T_start)
    "Borehole wall temperature"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TPip2(T=T_start + 15)
    "Wall temperature of pipe 2"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TPip1
    "Wall temperature of pipe 1"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.Blocks.Sources.Ramp T_ramp(
    height=20,
    duration=600,
    offset=T_start)
                   "Temperature ramp of pipe 1"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDat(conDat=
        Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        use_Rb=false))
    "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation

  connect(TWal.port, intRes1UTub.port_wall)
    annotation (Line(points={{-50,0},{-26,0},{0,0}}, color={191,0,0}));
  connect(TPip2.port, intRes1UTub.port_2)
    annotation (Line(points={{50,0},{10,0}}, color={191,0,0}));
  connect(TPip1.port, intRes1UTub.port_1)
    annotation (Line(points={{-10,40},{0,40},{0,10}}, color={191,0,0}));
  connect(T_ramp.y, TPip1.T)
    annotation (Line(points={{-49,40},{-40,40},{-32,40}}, color={0,0,127}));
  annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/InternalResistancesOneUTube.mos"
        "Simulate and plot"),
  Documentation(info="<html>
  This example tests the implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesOneUTube\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesOneUTube</a>
for the dynamic behavior of the filling material in a single U-tube borehole.
</html>", revisions="<html>
<ul>
<li>
July 19, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalResistancesOneUTube;

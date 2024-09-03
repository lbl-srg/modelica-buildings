within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model InternalResistancesTwoUTube "Validation of InternalResistancesTwoUTube"
  extends Modelica.Icons.Example;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Length hSeg=borFieDat.conDat.hBor/nSeg
    "Length of the internal heat exchanger";
  parameter Modelica.Units.SI.ThermalResistance Rgb_val=0.572601
    "Grout node to borehole wall thermal resistance";
  parameter Modelica.Units.SI.ThermalResistance Rgg1_val=0.0406121
    "Grout node to grout node thermal resistance";
  parameter Modelica.Units.SI.ThermalResistance Rgg2_val=0.216904
    "Thermal resistance between two grout nodes opposite to each other";
  parameter Modelica.Units.SI.ThermalResistance RCondGro_val=0.195099
    "Pipe to grout node thermal resistance";
  parameter Modelica.Units.SI.Temperature T_start=298.15 "Initial temperature";

  Buildings.HeatTransfer.Sources.FixedTemperature TWal(T=T_start)
    "Borehole wall temperature"
    annotation (Placement(transformation(extent={{-70,-4},{-50,16}})));
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
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_Rb=false))
    "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube
    intRes2UTub(
    hSeg=hSeg,
    T_start=T_start,
    borFieDat=borFieDat,
    Rgb_val=Rgb_val,
    RCondGro_val=RCondGro_val,
    Rgg1_val=Rgg1_val,
    Rgg2_val=Rgg2_val,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                       "Thermal resistance and capacitances of the borehole"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TPip3(T=T_start + 25)
    "Wall temperature of pipe 2"
    annotation (Placement(transformation(extent={{30,-50},{10,-30}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TPip4(T=T_start + 10)
    "Wall temperature of pipe 2"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
equation

  connect(T_ramp.y,TPip1. T)
    annotation (Line(points={{-49,40},{-40,40},{-32,40}}, color={0,0,127}));
  connect(TPip1.port, intRes2UTub.port_1)
    annotation (Line(points={{-10,40},{0,40},{0,10}}, color={191,0,0}));
  connect(TPip2.port, intRes2UTub.port_2)
    annotation (Line(points={{50,0},{30,0},{10,0}}, color={191,0,0}));
  connect(TWal.port, intRes2UTub.port_wall) annotation (Line(points={{-50,6},{0,
          6},{0,4},{0,0}},             color={191,0,0}));
  connect(TPip4.port, intRes2UTub.port_4) annotation (Line(points={{-50,-30},{-30,
          -30},{-30,0},{-10,0}}, color={191,0,0}));
  connect(TPip3.port, intRes2UTub.port_3)
    annotation (Line(points={{10,-40},{0,-40},{0,-10}}, color={191,0,0}));
  annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/InternalResistancesTwoUTube.mos"
        "Simulate and plot"),
  Documentation(info="<html>
This example tests the implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalResistancesTwoUTube</a>
for the dynamic behavior of the filling material in a double U-tube borehole.
</html>", revisions="<html>
<ul>
<li>
July 19, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalResistancesTwoUTube;

within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Validation;
model Direct
  "Validation model for a direct evaporative cooler"

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    "Medium";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 2
    "Nominal supply air volume flowrate";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct dirEvaCoo(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal = 10,
    final dep=0.2,
    final padAre=0.6)
    "Direct evaporative cooler"
    annotation (Placement(transformation(origin={0,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = MediumA,
    final T=340,
    final use_T_in=false,
    final nPorts=1)
    "Sink"
    annotation (Placement(transformation(origin={102,0}, extent={{10,-10},{-10,10}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    final columns = 2:10,
    final fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/Humidifiers/EvaporativeCoolers/Direct/Direct.dat"),
    final tableName = "EnergyPlus",
    final tableOnFile = true,
    final timeScale = 1)
    "EnergyPlus data"
    annotation (Placement(transformation(origin={-120,40}, extent ={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare final package Medium = MediumA,
    final m_flow=1,
    final use_C_in=false,
    final use_T_in=true,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final nPorts=1)
    "Mass flow rate source"
    annotation (Placement(transformation(origin={-30,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = MediumA,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final m_flow_nominal=m_flow_nominal,
    final T_start = 293.15)
    "Outlet air temperature sensor"
    annotation (Placement(transformation(origin={30,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m_flow_nominal)
    "Outlet air water mass fraction sensor"
    annotation (Placement(transformation(origin={60,0}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Mean mea(
    final f=1/600)
    "Mean block to average output data"
    annotation (Placement(transformation(origin={50,60}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Mean mea1(
    final f=1/600)
    "Mean block to average output data"
    annotation (Placement(transformation(origin={90,30}, extent={{-10,-10},{10,10}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert inlet air humidity ratio denominator from dry air to total air"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirOut
    "Convert outlet air humidity ratio denominator from dry air to total air"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degCIn
    "Convert inlet temperature from deg C to Kelvin"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Modelica.Blocks.Math.UnitConversions.To_degC to_degCOut
    "Convert outlet temperature from Kelvin to deg C"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

equation
  connect(combiTimeTable.y[9], sou.m_flow_in) annotation (Line(points={{-109,40},
          {-100,40},{-100,8},{-42,8}}, color={0,0,127}));
  connect(dirEvaCoo.port_b, senTem.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(senTem.T, mea.u)
    annotation (Line(points={{30,11},{30,60},{38,60}}, color={0,0,127}));
  connect(senMasFra.X, mea1.u)
    annotation (Line(points={{60,11},{60,30},{78,30}}, color={0,0,127}));
  connect(combiTimeTable.y[6], toTotAirIn.XiDry) annotation (Line(points={{-109,40},
          {-100,40},{-100,-50},{-91,-50}}, color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, sou.Xi_in[1]) annotation (Line(points={{-69,-50},
          {-50,-50},{-50,-4},{-42,-4}}, color={0,0,127}));
  connect(combiTimeTable.y[8], toTotAirOut.XiDry)
    annotation (Line(points={{-109,40},{-81,40}},  color={0,0,127}));
  connect(combiTimeTable.y[5], from_degCIn.u) annotation (Line(points={{-109,40},
          {-100,40},{-100,-20},{-92,-20}}, color={0,0,127}));
  connect(from_degCIn.y, sou.T_in) annotation (Line(points={{-69,-20},{-60,-20},
          {-60,4},{-42,4}}, color={0,0,127}));
  connect(mea.y, to_degCOut.u)
    annotation (Line(points={{61,60},{78,60}}, color={0,0,127}));
  connect(senMasFra.port_a, senTem.port_b)
    annotation (Line(points={{50,0},{40,0}}, color={0,127,255}));
  connect(senMasFra.port_b, sin.ports[1])
    annotation (Line(points={{70,0},{92,0}}, color={0,127,255}));
  connect(sou.ports[1], dirEvaCoo.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));

annotation (
  Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
  experiment(StartTime=350000, StopTime=1200000, Interval=60, Tolerance=1e-6),
  Documentation(info="<html>
<p>
This model validates the direct evaporative cooler model
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct</a>.
</p>
<p>
The EnergyPlus results were generated using the example file <code>Direct.idf</code>
from EnergyPlus 23.1. The results were then used to set-up the boundary conditions
for the model as well as the input signals. To compare the results, the Modelica
outputs are averaged over 600 seconds.
</p>
<p>
Note that EnergyPlus mass fractions (<code>Xi</code>) are in mass of water
vapor per mass of dry air, whereas Modelica uses the total mass as a reference.
Also, the temperatures in Modelica are in Kelvin whereas they are in Celsius in EnergyPlus.
Hence, the EnergyPlus values are corrected by using the appropriate conversion blocks.
</p>
<p>
The validation generates three subplots.
</p>
<ul>
<li>
Subplot 1 shows the inlet air mass flowrate from the EnergyPlus model varying with the cooling load.
</li>
<li>
Subplot 2 compares the outlet air humidity ratio generated by Modelica and EnergyPlus model.
</li>
<li>
Subplot 3 compares the outlet air dry bulb temperature generated by Modelica and EnergyPlus model.
</li>
</ul>
<p>
The validation results demostrate that, with time-varying air flow rate, the
Modelica model can effectively capture the dynamics of outlet air humidity ratio
and dry bulb temperature, which match the data generated by Energyplus.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/Validation/Direct.mos"
        "Simulate and plot"));
end Direct;

within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Validation;
model IndirectDry
  "Validation model for indirect dry evaporative cooler"

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    "Medium";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal= 2
    "Primary air nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=2
    "Primary air nominal mass flow rate";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.IndirectDry indDryEvaCoo(
    redeclare final package Medium1 = MediumA,
    redeclare final package Medium2 = MediumA,
    final dp1_nominal=200,
    final dp2_nominal=200,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final eps=0.67,
    final padAre=0.6,
    final dep=0.2)
    "Indirect dry evaporative cooler"
    annotation (Placement(transformation(origin={-2,0}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = MediumA,
    final nPorts=1)
    "Sink for primary airflow"
    annotation (Placement(transformation(origin={130,0}, extent={{10,-10},{-10,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare final package Medium = MediumA,
    final nPorts=1)
    "Sink for secondary airflow"
    annotation (Placement(transformation(origin={130,-36}, extent={{10,-10},{-10,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souPri(
    redeclare final package Medium = MediumA,
    final use_T_in=true,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final nPorts=1)
    "Source for primary flow"
    annotation (Placement(transformation(origin={-80,10}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    final columns=2:12,
    final fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/Humidifiers/EvaporativeCoolers/IndirectDry/IndirectDry.dat"),
    final tableName = "EnergyPlus",
    final tableOnFile = true,
    final timeScale = 1)
    "Table input from EnergyPlus"
    annotation (Placement(transformation(origin={-178,90}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m1_flow_nominal)
    "Outlet air drybulb temperature sensor"
    annotation (Placement(transformation(origin={30,20}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degCPriIn
    "Primary air inlet temperature to Kelvin"
    annotation (Placement(transformation(origin={-130,50}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m1_flow_nominal)
    "Measured primary outlet air mass fraction"
    annotation (Placement(transformation(origin={60,20}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Mean TOut_mean(
    final f=1/600)
    "Measured outlet air drybulb temperature mean"
    annotation (Placement(transformation(origin={90,90}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Mean XOut_mean(
    final f=1/600)
    "Measured primary outlet air mass fraction mean"
    annotation (Placement(transformation(origin={90,60}, extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T souSec(
    redeclare final package Medium = MediumA,
    final use_T_in=true,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final nPorts=1)
    "Secondary air source"
    annotation (Placement(transformation(origin={-80,-30}, extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degCSecIn
    "Secondary air inlet temperature to Kelvin"
    annotation (Placement(transformation(origin={-130,-30}, extent={{-10,-10},{10,10}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirPriIn
    "Primary inlet air mass fraction"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirSecIn
    "Secondary inlet air mass fraction"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirPriOut
    "Primary outlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Modelica.Blocks.Math.UnitConversions.To_degC to_degC
    "Measured outlet air temperature to degree C"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=2)
    "Mass flowrate for air rejected to outdoor air"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));


equation
  connect(combiTimeTable.y[5], from_degCPriIn.u) annotation (Line(points={{-167,
          90},{-150,90},{-150,50},{-142,50}}, color={0,0,127}));
  connect(from_degCPriIn.y, souPri.T_in) annotation (Line(points={{-119,50},{-114,
          50},{-114,14},{-92,14}}, color={0,0,127}));
  connect(senMasFra.X, XOut_mean.u)
    annotation (Line(points={{60,31},{60,60},{78,60}}, color={0,0,127}));
  connect(from_degCSecIn.y, souSec.T_in) annotation (Line(points={{-119,-30},{-110,
          -30},{-110,-26},{-92,-26}}, color={0,0,127}));
  connect(indDryEvaCoo.port_b1, senTem.port_a) annotation (Line(points={{8,6},{
          12,6},{12,20},{20,20}},   color={0,127,255}));
  connect(combiTimeTable.y[6], toTotAirPriIn.XiDry) annotation (Line(points={{-167,
          90},{-160,90},{-160,10},{-141,10}}, color={0,0,127}));
  connect(toTotAirPriIn.XiTotalAir, souPri.Xi_in[1]) annotation (Line(points={{-119,
          10},{-100,10},{-100,6},{-92,6}}, color={0,0,127}));
  connect(toTotAirSecIn.XiTotalAir, souSec.Xi_in[1]) annotation (Line(points={{-119,
          -70},{-104,-70},{-104,-34},{-92,-34}}, color={0,0,127}));
  connect(senTem.port_b, senMasFra.port_a)
    annotation (Line(points={{40,20},{50,20}}, color={0,127,255}));
  connect(combiTimeTable.y[8], toTotAirPriOut.XiDry)
    annotation (Line(points={{-167,90},{-81,90}}, color={0,0,127}));
  connect(combiTimeTable.y[9], souPri.m_flow_in) annotation (Line(points={{-167,
          90},{-100,90},{-100,18},{-92,18}}, color={0,0,127}));
  connect(senMasFra.port_b, sin.ports[1]) annotation (Line(points={{70,20},{100,
          20},{100,0},{120,0}},   color={0,127,255}));
  connect(to_degC.y, TOut_mean.u) annotation (Line(points={{61,90},{78,90}},
                        color={0,0,127}));
  connect(to_degC.u, senTem.T)
    annotation (Line(points={{38,90},{30,90},{30,31}}, color={0,0,127}));
  connect(con.y, souSec.m_flow_in) annotation (Line(points={{-118,-110},{-106,
          -110},{-106,-22},{-92,-22}}, color={0,0,127}));
  connect(combiTimeTable.y[1], from_degCSecIn.u) annotation (Line(points={{-167,90},
          {-150,90},{-150,-30},{-142,-30}},     color={0,0,127}));
  connect(combiTimeTable.y[11], toTotAirSecIn.XiDry) annotation (Line(points={{-167,
          90},{-160,90},{-160,-70},{-141,-70}}, color={0,0,127}));
  connect(indDryEvaCoo.port_b2, sin1.ports[1]) annotation (Line(points={{8,-6},{
          40,-6},{40,-36},{120,-36}},  color={0,127,255}));
  connect(souPri.ports[1], indDryEvaCoo.port_a1) annotation (Line(points={{-70,10},
          {-40,10},{-40,6},{-12,6}}, color={0,127,255}));
  connect(souSec.ports[1], indDryEvaCoo.port_a2) annotation (Line(points={{-70,
          -30},{-40,-30},{-40,-6},{-12,-6}}, color={0,127,255}));

annotation (
  Diagram(coordinateSystem(extent={{-200,-180},{180,180}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StopTime=604800, Interval=600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/Validation/IndirectDry.mos"
      "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the indirect dry evaporative cooler model
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.IndirectDry\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.IndirectDry</a>.
</p>
<p>
The EnergyPlus results were generated using the example file <code>IndirectDry.idf</code>
from EnergyPlus 23.1. The results were then used to set-up the boundary conditions
for the model as well as the input signals. To compare the results, the Modelica
outputs are averaged over 600 seconds.
</p>
<p>
Note that EnergyPlus mass fractions (Xi) are in mass of water vapor per mass
of dry air, whereas Modelica uses the total mass as a reference. Also, the
temperatures in Modelica are in Kelvin whereas they are in Celsius in EnergyPlus.
Hence, the EnergyPlus values are corrected by using the appropriate conversion
blocks.
</p>
<p>
The validation generates three subplots.
</p>
<ul>
<li>
Subplot 1 shows the inlet air mass flowrate from the EnergyPlus model varying with the cooling load.
</li>
<li>
Subplot 2 compares the outlet air dry bulb temperature generated by Modelica and EnergyPlus model.
</li>
<li>
Subplot 3 compares the outlet air humidity ratio generated by Modelica and EnergyPlus model.
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
September 20, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end IndirectDry;

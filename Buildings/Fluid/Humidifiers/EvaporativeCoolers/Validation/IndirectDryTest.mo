within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Validation;
model IndirectDryTest
  "Validation model for indirect dry evaporative cooler"

  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air
    "Medium Air";
  replaceable package MediumW = Buildings.Media.Water
    "Medium Water";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal= 0.5
    "Primary water nominal mass flow rate";
  parameter Modelica.Units.SI.Pressure dp1_nominal=6000
    "Nominal heat exchanger pressure drop of medium flow to be cooled";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.IndirectDryTest
                                                             indDryEvaCoo(
    redeclare final package Medium1 = MediumW,
    redeclare final package Medium2 = MediumA,
    final dp1_nominal=200,
    final dp2_nominal=200,
    final m1_flow_nominal=m1_flow_nominal,
    final padAre=0.6,
    redeclare Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.EnergyPlus per(d
        =0.2),
    dat=dat)
    "Indirect dry evaporative cooler"
    annotation (Placement(transformation(origin={-2,0}, extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare final package Medium = MediumA,
    final nPorts=1) "Sink for secondary airflow"
    annotation (Placement(transformation(origin={130,-40}, extent={{10,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant evaCooAct(
    final k=true)
    "Boolean pulse signal for active evaporative cooling"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  parameter HeatExchangers.CoolingTowers.Data.DryCooler.Generic
    dat(
    Q_flow_nominal=-m1_flow_nominal*4200*(35 - 30),
    TCooIn_nominal=308.15,
    TCooOut_nominal=303.15,
    dp_nominal=dp1_nominal,
    TAirIn_nominal=298.15) "Performance data for dry cooler"
    annotation (Placement(transformation(extent={{160,-122},{180,-102}})));
  Movers.FlowControlled_m_flow                 pum(
    redeclare package Medium = MediumW,
    addPowerToMedium=false,
    m_flow_nominal=m1_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for condenser water loop"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Sensors.TemperatureTwoPort                 TEnt(redeclare package Medium =
        MediumW, m_flow_nominal=m1_flow_nominal)
    "Water entering temperature"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo(Q_flow=0.5*
        m1_flow_nominal*4200*5)       "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  MixingVolumes.MixingVolume                 vol(
    nPorts=2,
    redeclare package Medium = MediumW,
    m_flow_nominal=m1_flow_nominal,
    V=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Sources.Boundary_pT                 exp(redeclare package Medium = MediumW,
      nPorts=1)
              "Expansion vessel"
    annotation (Placement(transformation(extent={{140,0},{120,20}})));
  Modelica.Blocks.Logical.OnOffController onOffCon(
    bandwidth=2,
    reference(unit="K", displayUnit="degC"),
    u(unit="K", displayUnit="degC"))
    "On/off controller"
    annotation (Placement(transformation(extent={{-110,120},{-90,140}})));
  Modelica.Blocks.Logical.Switch swi "Control switch for chilled water pump"
    annotation (Placement(transformation(extent={{-70,120},{-50,140}})));
  Modelica.Blocks.Sources.Constant TSwi(k=273.15 + 22)
    "Switch temperature for switching tower pump on"
    annotation (Placement(transformation(extent={{-170,114},{-150,134}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero flow rate"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m1_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-110,152},{-90,172}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Movers.SpeedControlled_y mov(
    redeclare package Medium = MediumA,
    redeclare Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW12 per,
    addPowerToMedium=false)
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Sources.Outside sou(redeclare final package Medium = MediumA, final nPorts=1)
    "Source for secondary airflow" annotation (Placement(transformation(
        origin={-90,-70},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  Modelica.Blocks.Sources.Constant TSetLea(k=273.15 + 18)
    "Setpoint for leaving temperature"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Controls.Continuous.LimPID conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{22,-120},{42,-100}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(final
      computeWetBulbTemperature=false, filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  BoundaryConditions.WeatherData.Bus           weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-130,-140},{-110,-120}}),
        iconTransformation(extent={{-124,-90},{-104,-70}})));
equation

  connect(evaCooAct.y, indDryEvaCoo.evaCooAct) annotation (Line(points={{-58,-10},
          {-40,-10},{-40,0},{-11,0}}, color={255,0,255}));
  connect(pum.port_b, TEnt.port_a)
    annotation (Line(points={{-120,30},{-100,30}}, color={0,127,255}));
  connect(TEnt.port_b, indDryEvaCoo.port_a1) annotation (Line(points={{-80,30},
          {-46,30},{-46,6},{-12,6}}, color={0,127,255}));
  connect(indDryEvaCoo.port_b1, vol.ports[1]) annotation (Line(points={{8,6},{
          50,6},{50,60},{49,60}}, color={0,127,255}));
  connect(exp.ports[1], indDryEvaCoo.port_b1) annotation (Line(points={{120,10},
          {62,10},{62,6},{8,6}}, color={0,127,255}));
  connect(vol.ports[2], pum.port_a) annotation (Line(points={{51,60},{-160,60},
          {-160,30},{-140,30}}, color={0,127,255}));
  connect(fixHeaFlo.port, vol.heatPort) annotation (Line(points={{20,110},{20,
          91},{40,91},{40,70}}, color={191,0,0}));
  connect(onOffCon.y,swi. u2)
   annotation (Line(points={{-89,130},{-72,130}},
                                                color={255,0,255}));
  connect(zer.y,swi. u3)
   annotation (Line(points={{-89,100},{-82,100},{-82,122},{-72,122}},
     color={0,0,127}));
  connect(m_flow.y,swi. u1)
   annotation (Line(points={{-89,162},{-82,162},{-82,138},{-72,138}},
     color={0,0,127}));
  connect(onOffCon.u,TSwi. y)
   annotation (Line(points={{-112,124},{-149,124}},color={0,0,127}));
  connect(TVol.T,onOffCon. reference)
   annotation (Line(points={{-139,170},{-130,170},{-130,136},{-112,136}},
      color={0,0,127}));
  connect(vol.heatPort, TVol.port) annotation (Line(points={{40,70},{-190,70},{
          -190,170},{-160,170}}, color={191,0,0}));
  connect(swi.y, pum.m_flow_in) annotation (Line(points={{-49,130},{-28,130},{
          -28,42},{-130,42}}, color={0,0,127}));
  connect(indDryEvaCoo.port_b2, mov.port_a) annotation (Line(points={{8,-6},{40,
          -6},{40,-40},{60,-40}}, color={0,127,255}));
  connect(mov.port_b, sin1.ports[1])
    annotation (Line(points={{80,-40},{120,-40}}, color={0,127,255}));
  connect(sou.ports[1], indDryEvaCoo.port_a2) annotation (Line(points={{-80,-70},
          {-20,-70},{-20,-6},{-12,-6}}, color={0,127,255}));
  connect(TSetLea.y, conFan.u_s)
    annotation (Line(points={{-19,-110},{20,-110}}, color={0,0,127}));
  connect(conFan.y, mov.y) annotation (Line(points={{43,-110},{50,-110},{50,-28},
          {70,-28}}, color={0,0,127}));
  connect(indDryEvaCoo.TLvg, conFan.u_m) annotation (Line(points={{7,2},{10,2},
          {10,-122},{32,-122}}, color={0,0,127}));
  connect(weaDat.weaBus,weaBus)
   annotation (Line(points={{-140,-130},{-120,-130}},
                                               color={255,204,51}));
  connect(weaBus, sou.weaBus) annotation (Line(
      points={{-120,-130},{-110,-130},{-110,-70.2},{-100,-70.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
annotation (
  Diagram(coordinateSystem(extent={{-200,-180},{180,180}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StartTime=350000, StopTime=604800, Interval=60, Tolerance=1e-6),
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
Subplot 1 shows the inlet air mass flowrate measured from the EnergyPlus model
used to activate the component model.
</li>
<li>
Subplot 2 compares the outlet air dry bulb temperature measurements from the Modelica
(<code>TOut_mean.y</code>) and EnergyPlus (<code>combiTimeTable.y[7]</code>) models.
The Modelica measurements converge on and then track the EnergyPlus measurements
with continuous operation of the component.
</li>
<li>
Subplot 3 compares the outlet air humidity ratio measurements from the Modelica
(<code>XOut_mean.y</code>) and EnergyPlus (<code>toTotAirPriOut.XiTotalAir</code>)
models. Again, the Modelica measurements converge on and then closely track the
EnergyPlus measurements with continuous operation of the component.
</li>
</ul>
<p>
The validation results demostrate that, with time-varying air flow rate, the
Modelica model can effectively capture the dynamics of outlet air humidity ratio
and dry bulb temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end IndirectDryTest;

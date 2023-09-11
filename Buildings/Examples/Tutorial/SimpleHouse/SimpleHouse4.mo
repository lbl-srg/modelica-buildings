within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse4 "Heating model"
  extends SimpleHouse3;

  parameter Modelica.Units.SI.HeatFlowRate QHea_nominal=3000
    "Nominal capacity of heating system";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=0.1
    "Nominal mass flow rate for water loop";
  parameter Boolean constantSourceHeater=true
    "To enable/disable the connection between the constant source and heater";

  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    T_a_nominal=333.15,
    T_b_nominal=313.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    Q_flow_nominal=3000)                          "Radiator"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaWat(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    dp_nominal=5000,
    Q_flow_nominal=QHea_nominal) "Heater for water circuit"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = MediumWater,
    use_inputFilter=false,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=Buildings.Fluid.Types.InputType.Constant)
                                         "Pump"
    annotation (Placement(transformation(extent={{110,-180},{90,-160}})));
  Buildings.Fluid.Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater, nPorts=1)
    "Pressure bound for water circuit" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={10,-170})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
equation
  connect(heaWat.port_b,rad. port_a) annotation (Line(points={{80,-100},{110,-100}},
                       color={0,127,255}));
  connect(rad.port_b,pump. port_a) annotation (Line(points={{130,-100},{148,-100},
          {148,-170},{110,-170}},color={0,127,255}));
  connect(heaWat.port_a,pump. port_b) annotation (Line(points={{60,-100},{49.75,
          -100},{49.75,-170},{90,-170}},  color={0,127,255}));
  connect(rad.heatPortCon, zone.heatPort) annotation (Line(points={{118,-92.8},
          {118,140},{110,140}},color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{122,-92.8},{122,
          -30},{132,-30},{132,1.77636e-15},{140,1.77636e-15}}, color={191,0,0}));
  if constantSourceHeater then
    connect(const.y, heaWat.u) annotation (Line(points={{59,-70},{50,-70},{50,-94},
          {58,-94}}, color={0,0,127}));
  end if;
  connect(bouWat.ports[1], pump.port_b)
    annotation (Line(points={{20,-170},{90,-170}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}})),
    experiment(Tolerance=1e-6, StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
The wall temperature (and therefore the room temperature) is quite low.
In this step a heating system is added to resolve this. It consists of a radiator, a pump and a heater.
The radiator has a nominal power of 3~$kW$ for an inlet and outlet temperature of the radiator of <i>60°C</i>
and <i>40°C</i>, and a room air and radiative temperature of <i>20°C</i>.
The pump has a (nominal) mass flow rate of <i>0.1 kg/s</i>.
Since the heating system uses water as a heat carrier fluid,
the media for the models in the heating circuit should be set to <i>MediumWater</i>.
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2\">
Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
The radiator contains one port for convective heat transfer and one for radiative heat transfer.
Connect both in a reasonable way. Since the heating system uses water as a heat carrier fluid,
the media for the models should be set to <i>MediumWater</i>.
</p>
<p>
The <code>Boundary_pT</code> model needs to be used to set an absolute pressure somewhere in the system.
Otherwise the absolute pressure in the system is undefined.
Pressure difference modelling may be disregarded in the heating circuit
since the chosen pump sets a fixed mass flow rate regardless of the pressure drop.
</p>
<p>
Set the heater input to 1, meaning that it will produce 1 times its nominal power.
</p>
<h4>Reference result</h4>
<p>
The result of the air temperature is plotted in the figure below.
The temperature rises very steeply since the wall is relatively well insulated (<i>k=0.04 W/(m*K)</i>)
and the heater is not disabled when it becomes too warm.
</p>
<p align=\"center\">
<img alt=\"Air temperature as function of time.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result4.png\" width=\"1000\"/>
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse4.mos"
        "Simulate and plot"));
end SimpleHouse4;

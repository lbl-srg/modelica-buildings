within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse4 "Heating model"
  extends SimpleHouse3;

  constant Boolean use_constantHeater=true
    "To enable/disable the connection between the constant source and heater and circulation pump";

  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=3000
    "Nominal capacity of heating system";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=0.1
    "Nominal mass flow rate for water loop";


  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    T_a_nominal=333.15,
    T_b_nominal=313.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    Q_flow_nominal=QHea_flow_nominal) "Radiator"
    annotation (Placement(transformation(extent={{140,-140},{160,-120}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaWat(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    dp_nominal=5000,
    Q_flow_nominal=QHea_flow_nominal) "Heater for water circuit"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));

  Fluid.Movers.Preconfigured.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWater,
    use_inputFilter=false,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false) "Pump"
    annotation (Placement(transformation(extent={{110,-190},{90,-170}})));

  Buildings.Fluid.Sources.Boundary_pT bouWat(
    redeclare package Medium = MediumWater,
    nPorts=1)
    "Pressure bound for water circuit"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={20,-180})));
  Modelica.Blocks.Sources.Constant conHea(k=1)
    if use_constantHeater "Gain for heater"
    annotation (Placement(transformation(extent={{80,-110},{60,-90}})));
  Modelica.Blocks.Sources.Constant conPum(k=mWat_flow_nominal)
    if use_constantHeater "Gain for pump"
    annotation (Placement(transformation(extent={{130,-160},{110,-140}})));
equation
  connect(heaWat.port_b,rad. port_a) annotation (Line(points={{80,-130},{140,-130}},
                       color={0,127,255}));
  connect(rad.port_b, pum.port_a) annotation (Line(points={{160,-130},{175,-130},
          {175,-180},{110,-180}}, color={0,127,255}));
  connect(heaWat.port_a, pum.port_b) annotation (Line(points={{60,-130},{39.75,-130},
          {39.75,-180},{90,-180}},       color={0,127,255}));
  connect(rad.heatPortCon, zon.heatPort) annotation (Line(points={{148,-122.8},{
          148,40},{160,40}},   color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{152,-122.8},{152,
          1.77636e-15},{160,1.77636e-15}},                     color={191,0,0}));
  connect(conPum.y, pum.m_flow_in) annotation (Line(points={{109,-150},{100,-150},
          {100,-168}}, color={0,0,127}));
  connect(conHea.y, heaWat.u) annotation (Line(points={{59,-100},{40,-100},{40,-124},
          {58,-124}}, color={0,0,127}));
  connect(bouWat.ports[1], pum.port_b)
    annotation (Line(points={{30,-180},{90,-180}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -220},{220,220}})),
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
The radiator has a nominal power of <i>3 kW</i> for an inlet and outlet temperature of the radiator of <i>60°C</i>
and <i>40°C</i>, and a room air and radiative temperature of <i>20°C</i>.
The pump has a (nominal) mass flow rate of <i>0.1 kg/s</i>.
Since the heating system uses water as a heat carrier fluid,
the media for the models in the heating circuit should be set to <i>MediumWater</i>.
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2\">
Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow\">
Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow</a>
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
the media for the models should be set to <code>MediumWater</code>.
</p>
<p>
The <code>Boundary_pT</code> model needs to be used to set an absolute pressure somewhere in the system.
Otherwise the absolute pressure in the system is undefined.
Pressure difference modelling may be disregarded in the heating circuit
since the chosen pump sets a fixed mass flow rate regardless of the pressure drop.
</p>
<p>
Set the heater input to <i>1</i>, meaning that it will produce <i>1</i> times its nominal power.
</p>
<h4>Implementation</h4>
<p>
The pump and the heater need a control input, which we set here to a constant
of <i>1</i>.
However, in the next version of this model, we want to connect an actual controller to these models.
We can therefore introduce a <code>Boolean constant</code> (or a <code>Boolean parameter</code>
would also work), and use this to conditionally remove the Modelica block
that outputs the control signal. When Modelica removes such a block, then all
connections to it will also be removed.
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

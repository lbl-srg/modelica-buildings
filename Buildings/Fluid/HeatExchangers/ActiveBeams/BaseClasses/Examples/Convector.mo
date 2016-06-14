within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Examples;
model Convector
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Water model";

  Buildings.Fluid.Sources.MassFlowSource_T wat(
    redeclare package Medium = Medium,
    m_flow=0.094,
    T=288.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = Medium, nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp airFlo(height=0.0792, duration=4)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant rooTem(k=273.15 + 25)
    "Room air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Convector con(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=10000,
    per(
      mAir_flow_nominal=0.0792,
      mWat_flow_nominal=0.094,
      dT_nominal=-10,
      Q_flow_nominal=1092,
      primaryAir(r_V={0,0.5,1}, f={0,0.75,1}),
      water(r_V={0,0.5,1}, f={0,0.75,1}),
      dT(r_dT={0,0.5,1}, f={0,0.75,1})))
    "Convector model"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=0.094)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Sensors.MassFlowRate senMasFlo(
     redeclare package Medium = Medium)
     "Mass flow sensor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(airFlo.y, con.mAir_flow) annotation (Line(points={{-59,80},{-10,80},{-10,
          4},{-2,4}},  color={0,0,127}));
  connect(rooTem.y, con.TRoo) annotation (Line(points={{-59,40},{-14,40},{-14,-6},
          {-2,-6}},  color={0,0,127}));
  connect(con.port_b, senTem.port_a)
    annotation (Line(points={{20,0},{26,0},{30,0}},
                                             color={0,127,255}));
  connect(senTem.port_b, bou.ports[1])
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  connect(wat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-60,0},{-50,0},{-40,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, con.port_a)
    annotation (Line(points={{-20,0},{-10,0},{0,0}}, color={0,127,255}));
  connect(senMasFlo.m_flow, con.mWat_flow) annotation (Line(points={{-30,11},{-30,
          16},{-6,16},{-6,9},{-2,9}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),experiment(StopTime=10),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/BaseClasses/Examples/Convector.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The example tests the implementation of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Convector\">
Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Convector</a>.
The room air temperature and the water mass flow rate are constant while the air flow rate varys with a ramp.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Convector;

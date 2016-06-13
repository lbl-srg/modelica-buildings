within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Examples;
model Convector
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Fluid.Sources.MassFlowSource_T wat(
    m_flow=0.094,
    redeclare package Medium = Buildings.Media.Water,
    nPorts=1,
    T=288.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp airFlo(height=0.0792, duration=4)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant rooTem(k=273.15 + 25)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Convector con(
      redeclare package Medium = Buildings.Media.Water,
      mod(airFlo_nom(k=1/0.0792),
      watFlo_nom(k=1/0.094),
      temDif_nom(k=-1/10)),
    m_flow_nominal=0.094,
    hex(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=0.094)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(airFlo.y, con.airFlo) annotation (Line(points={{-59,80},{-20,80},{-20,
          9},{-12,9}}, color={0,0,127}));
  connect(rooTem.y, con.rooTem) annotation (Line(points={{-59,40},{-40,40},{-40,
          4.8},{-12,4.8}}, color={0,0,127}));
  connect(wat.ports[1], con.port_a)
    annotation (Line(points={{-60,0},{-35,0},{-10,0}}, color={0,127,255}));
  connect(con.port_b, senTem.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(senTem.port_b, bou.ports[1])
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),experiment(StopTime=10),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/BaseClasses/Examples/Convector.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The example tests the implementation of <a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Convector\">
Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Convector</a>. The room air temperature and the water mass flow rate are constant while the air flow rate varys with a ramp.



 <p>

</html>"));
end Convector;

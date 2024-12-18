within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case650FF
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600FF(
      zonHVAC(nPorts=3));
  Buildings.Fluid.Sensors.Density senDen(redeclare package Medium = Buildings.Media.Air,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Modelica.Blocks.Math.Product product1
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Modelica.Blocks.Sources.CombiTimeTable
                          vent(table=[0,-1409/3600; 7*3600,-1409/3600; 7*3600,0;
        18*3600,0; 18*3600,-1409/3600; 24*3600,-1409/3600], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic)
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{90,-90},{70,-70}})));
  Buildings.Fluid.Sources.MassFlowSource_T           sinInf(
    redeclare package Medium = Buildings.Media.Air,
    use_m_flow_in=true,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{8,-90},{-12,-70}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(senDen.d,product1. u1) annotation (Line(points={{71,-30},{84,-30},{84,
          -54},{52,-54}}, color={0,0,127}));
  connect(vent.y[1],product1. u2) annotation (Line(points={{69,-80},{62,-80},{
          62,-66},{52,-66}},
                          color={0,0,127}));
  connect(product1.y,sinInf. m_flow_in) annotation (Line(points={{29,-60},{10,
          -60},{10,-72}},     color={0,0,127}));
  connect(sinInf.ports[1], zonHVAC.ports[1]) annotation (Line(points={{-12,-80},
          {-18,-80},{-18,-8.2},{-13,-8.2}}, color={0,127,255}));
  connect(senDen.port, zonHVAC.ports[2]) annotation (Line(points={{60,-40},{36,
          -40},{36,-8.2},{-13,-8.2}}, color={0,127,255}));
  connect(out.weaBus, zonHVAC.weaBus) annotation (Line(
      points={{-80,60.2},{-84,60.2},{-84,60},{-90,60},{-90,40},{-50,40},{-50,20},
          {10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], zonHVAC.ports[3]) annotation (Line(points={{-60,60},{
          -38,60},{-38,-8.2},{-13,-8.2}}, color={0,127,255}));
 annotation (
experiment(Tolerance=1e-06, Interval=3600,StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case650FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 650FF of the BESTEST validation suite.
Case 650FF is identical to case 650, except that there is no
heating and no cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2024, Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case650FF;

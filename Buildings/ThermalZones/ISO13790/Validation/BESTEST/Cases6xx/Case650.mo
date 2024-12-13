within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case650
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zonHVAC(
        nPorts=3), gaiHea(k=0),
        TSetHea(table=[0, 273.15 -200]),
        TSetCoo(table=[0, 273.15+100;
                    7*3600, 273.15+100;
                    7*3600, 273.15+27;
                   18*3600, 273.15+27;
                   18*3600, 273.15+100;
                   24*3600, 273.15+100], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic));
  Buildings.Fluid.Sensors.Density senDen(redeclare package Medium = Buildings.Media.Air,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Modelica.Blocks.Math.Product product1
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable
                          vent(table=[0,-1409/3600; 7*3600,-1409/3600; 7*3600,0;
        18*3600,0; 18*3600,-1409/3600; 24*3600,-1409/3600], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic)
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sinInf(
    redeclare package Medium = Buildings.Media.Air,
    use_m_flow_in=true,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{8,-70},{-12,-50}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air,
                                                                  nPorts=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(senDen.d,product1. u1) annotation (Line(points={{71,-10},{84,-10},{84,
          -34},{52,-34}}, color={0,0,127}));
  connect(product1.y,sinInf. m_flow_in) annotation (Line(points={{29,-40},{10,-40},
          {10,-52}},          color={0,0,127}));
  connect(out.weaBus, zonHVAC.weaBus) annotation (Line(
      points={{-80,60.2},{-84,60.2},{-84,60},{-90,60},{-90,40},{-50,40},{-50,20},
          {10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));
  connect(vent.y[1], product1.u2) annotation (Line(points={{69,-60},{62,-60},{62,
          -46},{52,-46}}, color={0,0,127}));
  connect(zonHVAC.ports[1], senDen.port) annotation (Line(points={{-13,-8.2},{-6,
          -8.2},{-6,-20},{60,-20}}, color={0,127,255}));
  connect(zonHVAC.ports[2], out.ports[1]) annotation (Line(points={{-13,-8.2},{-44,
          -8.2},{-44,60},{-60,60}}, color={0,127,255}));
  connect(sinInf.ports[1], zonHVAC.ports[3]) annotation (Line(points={{-12,-60},
          {-18,-60},{-18,-8.2},{-13,-8.2}}, color={0,127,255}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case650.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 650 of the BESTEST validation suite.
Case650 is the same as Case600, but with the following modifications:
</p>
<ul>
<li>
From 18h00 hours to 07h00 hours, vent fan = on
</li>
<li>
From 07h00 hours to 18h00 hours, vent fan = off
</li>
<li>
Heating is always off
</li>
<li>
From 07h00 hours to 18h00 hours, cooling is on if zone temperature &gt; 27&deg;C,
otherwise cool = off.
</li>
<li>
From 18h00 hours to 07h00 hours, cooling is always off.
</li>
<li>
Ventilation fan capacity is 1700 standard m<sup>3</sup>/h (in addition to specified
infiltration rate). After adjustment for the altitude, the capacity is 1409 m<sup>3</sup>/h.
</li>
<li>
No waste heat from fan.
</li>
</ul>
</html>", revisions="<html><ul>
<li>
Mar 2, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case650;

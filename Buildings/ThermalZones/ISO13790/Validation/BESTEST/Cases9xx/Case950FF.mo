within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case950FF
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900FF(
      zonHVAC(nPorts=3));
  Buildings.Fluid.Sources.MassFlowSource_T sinInf(
    redeclare package Medium = Buildings.Media.Air,
    use_m_flow_in=true,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{8,-80},{-12,-60}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Math.Product product1
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{50,-60},{30,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable
                          vent(table=[0,-1409/3600; 7*3600,-1409/3600; 7*3600,0;
        18*3600,0; 18*3600,-1409/3600; 24*3600,-1409/3600], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic)
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));
  Buildings.Fluid.Sensors.Density senDen(redeclare package Medium = Buildings.Media.Air,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
equation
  connect(product1.y,sinInf. m_flow_in) annotation (Line(points={{29,-50},{10,-50},
          {10,-62}},          color={0,0,127}));
  connect(vent.y[1],product1. u2) annotation (Line(points={{69,-70},{62,-70},{62,
          -56},{52,-56}}, color={0,0,127}));
  connect(senDen.d,product1. u1) annotation (Line(points={{71,-20},{84,-20},{84,
          -44},{52,-44}}, color={0,0,127}));
  connect(sinInf.ports[1], zonHVAC.ports[1]) annotation (Line(points={{-12,-70},
          {-20,-70},{-20,-8.2},{-13,-8.2}}, color={0,127,255}));
  connect(senDen.port, zonHVAC.ports[2]) annotation (Line(points={{60,-30},{2,-30},
          {2,-8.2},{-13,-8.2}}, color={0,127,255}));
  connect(out.ports[1], zonHVAC.ports[3]) annotation (Line(points={{-60,60},{-40,
          60},{-40,-8.2},{-13,-8.2}}, color={0,127,255}));
  connect(out.weaBus, zonHVAC.weaBus) annotation (Line(
      points={{-80,60.2},{-84,60.2},{-84,60},{-90,60},{-90,40},{-50,40},{-50,20},
          {10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));
 annotation (
 experiment(Tolerance=1e-06, Interval=3600, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case950FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 950FF of the BESTEST validation suite.
Case 950FF is identical to case 950, except that there is no
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
end Case950FF;

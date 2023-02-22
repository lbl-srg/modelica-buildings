within Buildings.ThermalZones.ISO13790.Examples;
model HeatingCoolingHVAC "Illustrates the use of the 5R1C HVAC thermal zone connected to a ventilation system"
  extends FreeFloatingHVAC(zonHVAC(nPorts=2));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(visible=true, transformation(extent={{42,64},{58,80}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) "Gain for heating"
    annotation (Placement(visible=true,
        transformation(
        origin={12,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) "Controller for heating"
    annotation (Placement(visible=true, transformation(
        origin={-10,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 20) "Set-point for heating"
    annotation (Placement(
        visible=true, transformation(
        origin={-34,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Buildings.Media.Air,
    use_m_flow_in=true,
    T=280.15,
    nPorts=1) "source of air"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27)
    "Set-point for cooling"
    annotation (Placement(
        visible=true, transformation(
        origin={-34,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    yMax=0.07,
    reverseActing=false,
    strict=true) "Controller for cooling"
    annotation (Placement(visible=true, transformation(
        origin={-10,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=1) "Gain for cooling"
    annotation (Placement(visible=true,
        transformation(
        origin={12,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Buildings.Media.Air,
    nPorts=1) "sink"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));
equation
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(TSetHea.y,conHeaPID. u_s)
    annotation (Line(points={{-27.4,72},{-17.2,72}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(gaiHea.y, preHeaCoo.Q_flow) annotation (Line(points={{18.6,72},{42,72}},
                            color={0,0,127}));
  connect(conCooPID.u_s,TSetCoo. y)
    annotation (Line(points={{-17.2,46},{-27.4,46}}, color={0,0,127}));
  connect(gaiCoo.u,conCooPID. y)
    annotation (Line(points={{4.8,46},{-3.4,46}}, color={0,0,127}));
  connect(sin.ports[1], zonHVAC.ports[1]) annotation (Line(points={{70,-70},{22,
          -70},{22,-6.2},{27,-6.2}}, color={0,127,255}));
  connect(preHeaCoo.port, zonHVAC.heaPorAir) annotation (Line(points={{58,72},{
          68,72},{68,8},{44,8},{44,10}}, color={191,0,0}));
  connect(sou.ports[1], zonHVAC.ports[2]) annotation (Line(points={{0,-70},{20,
          -70},{20,-6.2},{27,-6.2}}, color={0,127,255}));
  connect(sou.m_flow_in, gaiCoo.y) annotation (Line(points={{-22,-62},{-28,-62},
          {-28,34},{26,34},{26,46},{18.6,46}},color={0,0,127}));
  connect(zonHVAC.TAir, conCooPID.u_m) annotation (Line(points={{55,10},{60,10},
          {60,28},{-10,28},{-10,38.8}}, color={0,0,127}));
  connect(zonHVAC.TAir, conHeaPID.u_m) annotation (Line(points={{55,10},{60,10},
          {60,60},{-10,60},{-10,64.8}}, color={0,0,127}));
  annotation (experiment(
      StartTime=8640000,
      StopTime=9504000,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Examples/HeatingCoolingHVAC.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC\">
Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC</a> with heating and cooling. Cooling is delivered by
a ventilation system with supply air temperature of <i>7</i>&deg;C.
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoolingHVAC;

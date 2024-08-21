within Buildings.ThermalZones.ISO13790.Examples;
model HeatingCooling "Illustrates the use of the 5R1C thermal zone with heating and cooling"
  extends FreeFloating(zon5R1C(
      airRat=0.5,
      AWin={0,0,3,0},
      UWin=1.8,
      AWal={12,12,9,12},
      ARoo=16,
      UWal=1.3,
      URoo=1.3,
      AFlo=16,
      VRoo=16*3,
      redeclare Buildings.ThermalZones.ISO13790.Data.Light buiMas,
      gFac=0.5) "Thermal zone");
  Modelica.Blocks.Math.Sum sumHeaCoo(nin=2)
    "Sum of heating and cooling heat flow rate"
    annotation (Placement(visible = true, transformation(extent={{44,56},{52,64}},rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(visible=true, transformation(extent={{58,54},{70,66}},rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) "Gain for heating"
    annotation (Placement(visible=true,transformation(origin={12,72},extent={{-6,-6},{6,6}},rotation=0)));
  Buildings.Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) "Controller for heating"
    annotation (Placement(visible=true, transformation(origin={-10,72},extent={{-6,-6},{6,6}},rotation=0)));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 20)
    "Set-point for heating"
    annotation (Placement(visible=true, transformation(origin={-34,72},extent={{-6,-6},{6,6}},rotation=0)));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27)
    "Set-point for cooling"
    annotation (Placement(visible=true, transformation(origin={-34,46},extent={{-6,-6},{6,6}},rotation=0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation (
    Placement(visible = true, transformation(extent={{30,56},{38,64}},      rotation = 0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) "Gain for cooling"
    annotation (Placement(visible=true,transformation(origin={12,46},extent={{-6,-6},{6,6}},rotation=0)));
  Buildings.Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    reverseActing=false,
    strict=true) "Controller for cooling"
    annotation (Placement(visible=true, transformation(origin={-10,46},extent={{-6,-6},{6,6}},rotation=0)));
equation
  connect(sumHeaCoo.y, preHeaCoo.Q_flow)
    annotation (Line(points={{52.4,60},{58,60}}, color={0,0,127}));
  connect(conHeaPID.y, gaiHea.u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(TSetHea.y, conHeaPID.u_s)
    annotation (Line(points={{-27.4,72},{-17.2,72}}, color={0,0,127}));
  connect(multiplex2.y,sumHeaCoo. u)
    annotation (
    Line(points={{38.4,60},{43.2,60}},      color = {0, 0, 127}));
  connect(conCooPID.u_s, TSetCoo.y)
    annotation (Line(points={{-17.2,46},{-27.4,46}}, color={0,0,127}));
  connect(conCooPID.y, gaiCoo.u)
    annotation (Line(points={{-3.4,46},{4.8,46}}, color={0,0,127}));
  connect(conHeaPID.y, gaiHea.u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(gaiHea.y, multiplex2.u1[1])
    annotation (Line(points={{18.6,72},{22,72},{22,62},{28,62},{28,62.4},{29.2,62.4}},
                                                 color={0,0,127}));
  connect(gaiCoo.y, multiplex2.u2[1])
    annotation (Line(points={{18.6,46},{22,46},{22,58},{28,58},{28,57.6},{29.2,57.6}},
                                                 color={0,0,127}));
  connect(gaiCoo.u, conCooPID.y)
    annotation (Line(points={{4.8,46},{-3.4,46}}, color={0,0,127}));
  connect(preHeaCoo.port, zon5R1C.heaPorAir) annotation (Line(points={{70,60},{
          80,60},{80,6},{44,6},{44,10}}, color={191,0,0}));
  connect(zon5R1C.TAir, conCooPID.u_m) annotation (Line(points={{55,10},{60,10},
          {60,30},{-10,30},{-10,38.8}}, color={0,0,127}));
  connect(zon5R1C.TAir, conHeaPID.u_m) annotation (Line(points={{55,10},{60,10},
          {60,30},{-50,30},{-50,60},{-10,60},{-10,64.8}}, color={0,0,127}));
  annotation (experiment(
    StartTime=8640000,
    StopTime=9504000,
    Tolerance=1e-6),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Examples/HeatingCooling.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://Buildings.ThermalZones.ISO13790.Zone5R1C.Zone\">
Buildings.ThermalZones.ISO13790.Zone5R1C.Zone</a> with heating and cooling.
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
end HeatingCooling;

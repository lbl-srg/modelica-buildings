within Buildings.Templates.Plants.Controls.HeatPumps.Validation;
model HybridPlantControlModule
  "Validation model for 4-pipe ASHP integration block"

  Buildings.Templates.Plants.Controls.HeatPumps.HybridPlantControlModule
    ctl(
    final have_heaWat=true,
    final has_sort=true,
    final have_chiWat=true,
    final nHp=3,
    final is_fouPip={false,false,true},
    final staEquCooHea=[0,0,1; 1/2,1/2,1; 1,1,1],
    final staEquOneMod=[1/2,1/2,0; 1,1,0; 1,1,1],
    final idxEquAlt={1,2})
    "Integration block"
    annotation (Placement(transformation(extent={{-10,-14},{10,14}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Constant Boolean True signal"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=3600,
    final shift=1800)
    "Time-varying signal to trigger staging"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Boolean not converter"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k=fill(false,3))
    "Constant Boolean false signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final period=4000,
    final shift=2000)
    "Time-varying signal to trigger staging"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

equation
  connect(booPul.y, ctl.u1Hp[3]) annotation (Line(points={{-58,-40},{-26,-40},{
          -26,0},{-22,0},{-22,2.66667},{-12,2.66667}},
                                                   color={255,0,255}));
  connect(con.y, ctl.u1Hp[1]) annotation (Line(points={{-58,-10},{-22,-10},{-22,
          1.33333},{-12,1.33333}},
                    color={255,0,255}));
  connect(con.y, ctl.uMod[1]) annotation (Line(points={{-58,-10},{-26,-10},{-26,
          -2.66667},{-12,-2.66667}},color={255,0,255}));
  connect(con.y, ctl.u1EnaHea) annotation (Line(points={{-58,-10},{-22,-10},{
          -22,2},{-20,2},{-20,6},{-12,6}},
                                       color={255,0,255}));
  connect(booPul.y, not1.u) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -60},{-42,-60}},
                      color={255,0,255}));
  connect(not1.y, ctl.uMod[2]) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -18},{-20,-18},{-20,-2},{-12,-2}}, color={255,0,255}));
  connect(booPul.y, ctl.uMod[3]) annotation (Line(points={{-58,-40},{-26,-40},{
          -26,-1.33333},{-12,-1.33333}},
                                     color={255,0,255}));
  connect(con.y, ctl.u1PumPriHea[1]) annotation (Line(points={{-58,-10},{-22,
          -10},{-22,-10.6667},{-12,-10.6667}},
                                          color={255,0,255}));
  connect(booPul.y, ctl.u1PumPriHea[3]) annotation (Line(points={{-58,-40},{-24,
          -40},{-24,-9.33333},{-12,-9.33333}}, color={255,0,255}));
  connect(not1.y, ctl.u1Hp[2]) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -18},{-20,-18},{-20,2},{-12,2}}, color={255,0,255}));
  connect(not1.y, ctl.u1PumPriHea[2]) annotation (Line(points={{-18,-60},{-10,-60},
          {-10,-18},{-20,-18},{-20,-10},{-12,-10}}, color={255,0,255}));
  connect(booPul1.y, ctl.u1EnaCoo) annotation (Line(points={{-58,50},{-20,50},{
          -20,10},{-12,10}},
                         color={255,0,255}));
  connect(con1.y, ctl.u1PumPriCoo) annotation (Line(points={{-58,20},{-42,20},{
          -42,-6},{-12,-6}},
                         color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Validation/HybridPlantControlModule.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 29, 2025, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.HybridPlantControlModule\">
Buildings.Templates.Plants.Controls.HeatPumps.HybridPlantControlModule</a>
in a configuration with two equally sized lead/lag alternate
2-pipe air-source heat pumps and a 4-pipe air-source heat pump, which can operate
in one of heating-only, cooling-only, or heating-cooling modes.
</p>
<p>
Simulating this model shows how the controller responds to varying staging
configurations when the plant goes from operating in heating mode to both heating
and cooling mode simultaneously. This is accompanied by one of the 2-pipe ASHPs
getting disabled, and the 4-pipe ASHP getting enabled just before the plant goes
into simultaneous heating and cooling.
</p>
<ul>
<li>
In the first plot, when the 4-pipe ASHP is initially enabled <code>u1Hp[3]</code> in
heating mode, as indicated by <code>uMod[3]</code>, it is operated in heating-only
mode and the appropriate integer signal is output by <code>yMod[3]=2</code>. At that
instant, the 4-pipe ASHP is no longer available for future staging in heating mode
(<code>yAvaFouPipHea[3]=false</code>), but continues to be available for future cooling
mode staging (<code>yAvaFouPipCoo[3]=true</code>). When the cooling plant is finally
enabled (<code>u1EnaCoo=true</code>), the 4-pipe ASHP is ooperated in heating-cooling mode
<code>yMod[3]=3</code> and is no longer available for cooling mode staging
(<code>yAvaFouPipCoo[3]=false</code>).
</li>
<li>
Similarly, in the second plot, the primary chilled water pump is enabled alongwith
the primary hot water pump via signal <code>y1PumPri[3]</code>, when the plant
operates in simultaneous heating and cooling mode (<code>yHeaCoo=true</code>).
</li>
</ul>
</html>"));
end HybridPlantControlModule;

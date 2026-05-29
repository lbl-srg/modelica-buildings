within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model HybridOperation
  "Validation model for 4-pipe ASHP integration block"

  Buildings.Templates.Plants.Controls.StagingRotation.HybridOperation
    ctl(
    final have_heaWat=true,
    final have_chiWat=true,
    final nHp=2,
    final is_HpShc={false,false,true},
    nHpShc=1,
    final staEquDouMod=[0,0,1; 1/2,1/2,1; 1,1,1],
    final staEquSinMod=[1/2,1/2,0; 1,1,0; 1,1,1])
    "Integration block"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

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

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Boolean not converter"
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
  Buildings.Controls.OBC.CDL.Logical.Not not2[3]
    "Not conversion of availability for enable signal"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

equation
  connect(con.y, ctl.u1EnaHea) annotation (Line(points={{-58,-10},{-22,-10},{
          -22,4},{-12,4}},             color={255,0,255}));
  connect(booPul.y, not1.u) annotation (Line(points={{-58,-40},{-50,-40},{-50,
          -60},{-42,-60}},
                      color={255,0,255}));
  connect(con.y, ctl.u1PumPriHea[1]) annotation (Line(points={{-58,-10},{-22,
          -10},{-22,-4},{-12,-4}},        color={255,0,255}));
  connect(booPul.y, ctl.u1PumPriHea[3]) annotation (Line(points={{-58,-40},{-22,
          -40},{-22,-4},{-12,-4}},             color={255,0,255}));
  connect(not1.y, ctl.u1PumPriHea[2]) annotation (Line(points={{-18,-60},{-10,
          -60},{-10,-16},{-20,-16},{-20,-10},{-22,-10},{-22,-4},{-12,-4}},
                                                    color={255,0,255}));
  connect(booPul1.y, ctl.u1EnaCoo) annotation (Line(points={{-58,50},{-20,50},{
          -20,8},{-12,8}},
                         color={255,0,255}));
  connect(con1.y, ctl.u1PumPriCoo) annotation (Line(points={{-58,20},{-26,20},{
          -26,0},{-12,0}},
                         color={255,0,255}));
  connect(not2.y, ctl.u1Hp) annotation (Line(points={{-18,-90},{-6,-90},{-6,-38},
          {-12,-38},{-12,-8}},
                           color={255,0,255}));
  connect(con.y, not2[1].u) annotation (Line(points={{-58,-10},{-48,-10},{-48,
          -26},{-84,-26},{-84,-90},{-42,-90}}, color={255,0,255}));
  connect(not1.y, not2[2].u) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -74},{-52,-74},{-52,-90},{-42,-90}}, color={255,0,255}));
  connect(not1.y, not2[3].u) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -74},{-52,-74},{-52,-90},{-42,-90}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/HybridOperation.mos"
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
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.HybridOperation\">
Buildings.Templates.Plants.Controls.StagingRotation.HybridOperation</a>
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
mode and the appropriate integer signal is output by <code>yMod[3]=1</code>. At that
instant, the 4-pipe ASHP is no longer available for future staging in heating mode
(<code>yAvaHpShcHea[3]=false</code>), but continues to be available for future cooling
mode staging (<code>yAvaHpShcCoo[3]=true</code>). When the cooling plant is finally
enabled (<code>u1EnaCoo=true</code>), the 4-pipe ASHP is ooperated in heating-cooling mode
<code>yMod[3]=3</code> and is no longer available for cooling mode staging
(<code>yAvaHpShcCoo[3]=false</code>).
</li>
<li>
Similarly, in the second plot, the primary chilled water pump is enabled alongwith
the primary hot water pump via signal <code>y1PumPri[3]</code>, when the plant
operates in simultaneous heating and cooling mode (<code>yHeaCoo=true</code>).
</li>
</ul>
</html>"));
end HybridOperation;

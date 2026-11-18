within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.Validation;
model PlantDisable
    "Validation model for PlantDisable sequence"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable
    plaDis(
    final have_priOnl=true,
    final have_heaPriPum=true,
    final nBoi=2,
    final delBoiDis=180)
    "Plant disable for primary-only plants with headered pumps"
    annotation (Placement(transformation(extent={{12,80},{32,100}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable
    plaDis1(
    final have_priOnl=false,
    final have_heaPriPum=true,
    final nBoi=2,
    final delBoiDis=180)
    "Plant disable for primary-secondary plants with headered pumps"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable
    plaDis2(
    final have_priOnl=false,
    final have_heaPriPum=false,
    final nBoi=2,
    final delBoiDis=180)
    "Plant disable for primary-secondary plants with dedicated pumps"
    annotation (Placement(transformation(extent={{10,-100},{30,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold rising edge signal for visualization"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold rising edge signal for visualization"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold rising edge signal for visualization"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true)
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k={false,true})
    "Boiler status before plant disable"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=900,
    final shift=1)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge detector"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{-28,80},{-8,100}})));

  CDL.Logical.Pre                               pre1  [2](pre_u_start={false,true})
    "Unit delay for valve position"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  CDL.Logical.Pre pre2[2](pre_u_start={false,true}) "Unit delay for valve position"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

equation
  connect(con.y, plaDis.uBoi) annotation (Line(points={{-38,-20},{0,-20},{0,38},
          {-2,38},{-2,94},{10,94}},
                        color={255,0,255}));

  connect(con.y, plaDis1.uBoi) annotation (Line(points={{-38,-20},{-16,-20},{-16,
          -6},{8,-6}},color={255,0,255}));

  connect(con.y, plaDis2.uBoi) annotation (Line(points={{-38,-20},{0,-20},{0,-86},
          {8,-86}},       color={255,0,255}));

  connect(booPul.y, plaDis.uPla) annotation (Line(points={{-68,120},{6,120},{6,98},
          {10,98}},     color={255,0,255}));

  connect(booPul.y, plaDis1.uPla) annotation (Line(points={{-68,120},{6,120},{6,
          -2},{8,-2}},color={255,0,255}));

  connect(booPul.y, plaDis2.uPla) annotation (Line(points={{-68,120},{6,120},{6,
          -82},{8,-82}},  color={255,0,255}));

  connect(plaDis.yStaChaPro, truFalHol.u) annotation (Line(points={{34,84},{50,84},
          {50,70},{58,70}}, color={255,0,255}));

  connect(plaDis1.yStaChaPro, truFalHol1.u) annotation (Line(points={{32,-16},{32,
          -30},{58,-30}},         color={255,0,255}));

  connect(plaDis2.yStaChaPro, truFalHol2.u) annotation (Line(points={{32,-96},{48,
          -96},{48,-100},{58,-100}},
                                   color={255,0,255}));

  connect(booPul.y, edg.u) annotation (Line(points={{-68,120},{-64,120},{-64,
          100},{-62,100}},
                    color={255,0,255}));

  connect(booPul.y, falEdg.u) annotation (Line(points={{-68,120},{-64,120},{-64,
          70},{-62,70}},
                     color={255,0,255}));

  connect(falEdg.y, or2.u2) annotation (Line(points={{-38,70},{-36,70},{-36,82},
          {-30,82}}, color={255,0,255}));

  connect(edg.y, or2.u1) annotation (Line(points={{-38,100},{-36,100},{-36,90},
          {-30,90}},
                color={255,0,255}));

  connect(or2.y, plaDis.uStaChaProEnd) annotation (Line(points={{-6,90},{-4,90},
          {-4,82},{10,82}},color={255,0,255}));

  connect(or2.y, plaDis1.uStaChaProEnd) annotation (Line(points={{-6,90},{-4,90},
          {-4,-18},{8,-18}},
                           color={255,0,255}));

  connect(or2.y, plaDis2.uStaChaProEnd) annotation (Line(points={{-6,90},{-4,90},
          {-4,-98},{8,-98}},   color={255,0,255}));

  connect(con2.y, plaDis1.uPumChaPro) annotation (Line(points={{-38,-50},{-6,-50},
          {-6,-14},{8,-14}},color={255,0,255}));
  connect(con2.y, plaDis2.uPumChaPro) annotation (Line(points={{-38,-50},{-6,-50},
          {-6,-94},{8,-94}},    color={255,0,255}));
  connect(pre2.y, plaDis.uHotWatIsoVal) annotation (Line(points={{-38,40},{2,40},
          {2,90},{10,90}}, color={255,0,255}));
  connect(plaDis.yHotWatIsoVal, pre2.u) annotation (Line(points={{34,88},{38,88},
          {38,24},{-72,24},{-72,40},{-62,40}}, color={255,0,255}));
  connect(pre1.y, plaDis1.uHotWatIsoVal) annotation (Line(points={{-38,-80},{-2,
          -80},{-2,-10},{8,-10}}, color={255,0,255}));
  connect(plaDis1.yHotWatIsoVal, pre1.u) annotation (Line(points={{32,-12},{40,-12},
          {40,10},{-70,10},{-70,-80},{-62,-80}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
    experiment(
      StopTime=900,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Generic/Validation/PlantDisable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable\">
      Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Generic.PlantDisable</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      May 7, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end PlantDisable;

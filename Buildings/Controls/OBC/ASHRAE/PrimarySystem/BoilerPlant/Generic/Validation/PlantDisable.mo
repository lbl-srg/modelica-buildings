within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation;
model PlantDisable
    "Validation model for PlantDisable sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable
    plaDis(
    final have_priOnl=true,
    final have_heaPriPum=true,
    final nBoi=2,
    final chaHotWatIsoRat=1/60,
    final delBoiDis=180)
    "Plant disable for primary-only plants with headered pumps"
    annotation (Placement(transformation(extent={{10,80},{30,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable
    plaDis1(
    final have_priOnl=false,
    final have_heaPriPum=true,
    final nBoi=2,
    final chaHotWatIsoRat=1/60,
    final delBoiDis=180)
    "Plant disable for primary-secondary plants with headered pumps"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable
    plaDis2(
    final have_priOnl=false,
    final have_heaPriPum=false,
    final nBoi=2,
    final chaHotWatIsoRat=1/60,
    final delBoiDis=180)
    "Plant disable for primary-secondary plants with dedicated pumps"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold rising edge signal for visualization"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold rising edge signal for visualization"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold rising edge signal for visualization"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=true)
    "Constant Boolean source"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k={false,true})
    "Boiler status before plant disable"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));

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

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel[2](
    final samplePeriod=fill(1, 2),
    final y_start={0,1})
    "Unit delay for valve position"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1[2](
    final samplePeriod=fill(1, 2),
    final y_start={0,1})
    "Unit delay for valve position"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[2](
    final k={0,1})
    "Valve position when plant is enabled"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[2]
    "Real switch"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=2)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi1[2]
    "Real switch"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

equation
  connect(con.y, plaDis.uBoi) annotation (Line(points={{-68,10},{0,10},{0,94},{
          8,94}},       color={255,0,255}));

  connect(con.y, plaDis1.uBoi) annotation (Line(points={{-68,10},{0,10},{0,4},{
          8,4}},      color={255,0,255}));

  connect(con.y, plaDis2.uBoi) annotation (Line(points={{-68,10},{0,10},{0,-96},
          {8,-96}},       color={255,0,255}));

  connect(booPul.y, plaDis.uPla) annotation (Line(points={{-68,120},{6,120},{6,
          98},{8,98}},  color={255,0,255}));

  connect(booPul.y, plaDis1.uPla) annotation (Line(points={{-68,120},{6,120},{6,
          8},{8,8}},  color={255,0,255}));

  connect(booPul.y, plaDis2.uPla) annotation (Line(points={{-68,120},{6,120},{6,
          -92},{8,-92}},  color={255,0,255}));

  connect(plaDis.yStaChaPro, truFalHol.u) annotation (Line(points={{32,84},{36,84},
          {36,70},{38,70}}, color={255,0,255}));

  connect(plaDis1.yStaChaPro, truFalHol1.u) annotation (Line(points={{32,-6},{36,
          -6},{36,-20},{38,-20}}, color={255,0,255}));

  connect(plaDis2.yStaChaPro, truFalHol2.u) annotation (Line(points={{32,-106},{
          36,-106},{36,-120},{38,-120}},
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
          {-4,82},{8,82}}, color={255,0,255}));

  connect(or2.y, plaDis1.uStaChaProEnd) annotation (Line(points={{-6,90},{-4,90},
          {-4,-8},{8,-8}}, color={255,0,255}));

  connect(or2.y, plaDis2.uStaChaProEnd) annotation (Line(points={{-6,90},{-4,90},
          {-4,-108},{8,-108}}, color={255,0,255}));

  connect(plaDis.yHotWatIsoVal, uniDel1.u) annotation (Line(points={{32,88},{36,
          88},{36,136},{-96,136},{-96,80},{-92,80}},
                                                   color={0,0,127}));

  connect(plaDis1.yHotWatIsoVal, uniDel.u) annotation (Line(points={{32,-2},{34,
          -2},{34,28},{-96,28},{-96,-20},{-92,-20}}, color={0,0,127}));

  connect(con1.y, swi.u1) annotation (Line(points={{-68,-50},{-60,-50},{-60,-42},
          {-52,-42}}, color={0,0,127}));

  connect(uniDel.y, swi.u3) annotation (Line(points={{-68,-20},{-64,-20},{-64,
          -58},{-52,-58}}, color={0,0,127}));

  connect(booPul.y, booRep.u) annotation (Line(points={{-68,120},{-64,120},{-64,
          68},{-96,68},{-96,50},{-92,50}}, color={255,0,255}));

  connect(booRep.y, swi.u2) annotation (Line(points={{-68,50},{-56,50},{-56,-50},
          {-52,-50}}, color={255,0,255}));

  connect(swi.y, plaDis1.uHotWatIsoVal) annotation (Line(points={{-28,-50},{-12,
          -50},{-12,0},{8,0}}, color={0,0,127}));

  connect(uniDel1.y, swi1.u3) annotation (Line(points={{-68,80},{-66,80},{-66,
          42},{-32,42}}, color={0,0,127}));

  connect(swi1.y, plaDis.uHotWatIsoVal)
    annotation (Line(points={{-8,50},{2,50},{2,90},{8,90}}, color={0,0,127}));

  connect(con1.y, swi1.u1) annotation (Line(points={{-68,-50},{-60,-50},{-60,58},
          {-32,58}}, color={0,0,127}));

  connect(booRep.y, swi1.u2)
    annotation (Line(points={{-68,50},{-32,50}}, color={255,0,255}));

  connect(con2.y, plaDis1.uPumChaPro) annotation (Line(points={{-28,-10},{-20,-10},
          {-20,-4},{8,-4}}, color={255,0,255}));
  connect(con2.y, plaDis2.uPumChaPro) annotation (Line(points={{-28,-10},{-20,-10},
          {-20,-104},{8,-104}}, color={255,0,255}));
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
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/Validation/PlantDisable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantDisable</a>.
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

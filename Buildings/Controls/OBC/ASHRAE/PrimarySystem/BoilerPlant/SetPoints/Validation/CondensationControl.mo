within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Validation;
model CondensationControl
    "Validation model for CondensationControl sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl
    conSet(
    primaryOnly=true,
    variablePrimary=false,
    nSta=nSta,
    TRetSet=60,
    TRetMinAll=57.2,
    minSecPumSpe=0.1,
    minPriPumSpeSta={0.2}) "Setpoint generation for primary-only plant"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl
    conSet1(
    primaryOnly=false,
    variablePrimary=true,
    nSta=1,
    TRetSet=60,
    TRetMinAll=57.2,
    minSecPumSpe=0.1,
    minPriPumSpeSta={0.2})
    "Setpoint generation for primary-secondary plant with variable speed primary loop pumps"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl
    conSet2(
    primaryOnly=false,
    variablePrimary=false,
    nSta=1,
    TRetSet=60,
    TRetMinAll=57.2,
    minSecPumSpe=0.1,
    minPriPumSpeSta={0.2})
    "Setpoint generation for primary-secondary plant with constant speed primary loop pumps"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl
    conSet3(
    primaryOnly=false,
    variablePrimary=true,
    nSta=1,
    TRetSet=60,
    TRetMinAll=57.2,
    minSecPumSpe=0.1,
    minPriPumSpeSta={0.2})
    "Setpoint generation when only condensing boilers are operating"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  CDL.Continuous.Sources.Sine                        sin(
    amplitude=5,
    freqHz=1/60,
    offset=60)
    "Sine input"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  CDL.Continuous.Sources.Sine                        sin1(
    amplitude=5,
    freqHz=1/60,
    offset=60)
    "Sine input"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  CDL.Continuous.Sources.Sine                        sin2(
    amplitude=5,
    freqHz=1/60,
    offset=60)
    "Sine input"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  CDL.Continuous.Sources.Sine                        sin3(
    amplitude=5,
    freqHz=1/60,
    offset=60)
    "Sine input"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  CDL.Integers.Sources.Constant conInt(k=1) "Constant Integer source"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Integers.Sources.Constant conInt1(k=1) "Constant Integer source"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  CDL.Integers.Sources.Constant conInt2(k=1) "Constant Integer source"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Integers.Sources.Constant conInt3(k=1) "Constant Integer source"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Integers.Sources.Constant conInt4[nSta](k={2}) "Stage type vector source"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Integers.Sources.Constant conInt5[nSta](k={2}) "Stage type vector source"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  CDL.Integers.Sources.Constant conInt6[nSta](k={2}) "Stage type vector source"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Integers.Sources.Constant conInt7[nSta](k={1}) "Stage type vector source"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  parameter Integer nSta=1 "Number of stages";
equation

  connect(sin.y, conSet.THotWatRet) annotation (Line(points={{-58,80},{-50,80},{
          -50,56},{-42,56}}, color={0,0,127}));
  connect(sin2.y, conSet2.THotWatRet) annotation (Line(points={{-58,-20},{-50,-20},
          {-50,-44},{-42,-44}}, color={0,0,127}));
  connect(sin3.y, conSet3.THotWatRet) annotation (Line(points={{42,-20},{50,-20},
          {50,-44},{58,-44}}, color={0,0,127}));
  connect(conInt.y, conSet.uCurSta)
    annotation (Line(points={{-58,50},{-42,50}}, color={255,127,0}));
  connect(conInt1.y, conSet1.uCurSta)
    annotation (Line(points={{42,50},{58,50}}, color={255,127,0}));
  connect(conInt2.y, conSet2.uCurSta)
    annotation (Line(points={{-58,-50},{-42,-50}}, color={255,127,0}));
  connect(conInt3.y, conSet3.uCurSta)
    annotation (Line(points={{42,-50},{58,-50}}, color={255,127,0}));
  connect(conInt4.y, conSet.uStaTyp) annotation (Line(points={{-58,20},{-50,20},
          {-50,44},{-42,44}}, color={255,127,0}));
  connect(conInt5.y, conSet1.uStaTyp) annotation (Line(points={{42,20},{50,20},{
          50,44},{58,44}}, color={255,127,0}));
  connect(conInt6.y, conSet2.uStaTyp) annotation (Line(points={{-58,-80},{-50,-80},
          {-50,-56},{-42,-56}}, color={255,127,0}));
  connect(conInt7.y, conSet3.uStaTyp) annotation (Line(points={{42,-80},{50,-80},
          {50,-56},{58,-56}}, color={255,127,0}));
  connect(sin1.y, conSet1.THotWatRet) annotation (Line(points={{42,80},{50,80},
          {50,56},{58,56}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
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
      preserveAspectRatio=false)),
    experiment(
      StopTime=60,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/SetPoints/Validation/CondensationControl.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.CondensationControl</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      May 7, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end CondensationControl;

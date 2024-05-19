within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints;
block CondensationControl
    "Sequence to calculate setpoint limits for condensation control in non-condesing boilers"

  parameter Boolean have_priOnl = false
    "True: Primary-only plant; False: Primary-secondary plant";

  parameter Boolean have_varPriPum = true
    "True: Variable speed pumps in primary loop; False: Constant speed pumps in primary loop"
    annotation(Evaluate=true,Dialog(enable=(not have_priOnl)));

  parameter Integer nSta=5
    "Number of stages";

  parameter Real TRetSet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 60
    "Minimum hot water return temperature for optimal non-condensing boiler performance";

  parameter Real TRetMinAll(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 57.2
    "Minimum allowed hot water return temperature for non-condensing boiler";

  parameter Real minSecPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) = 0
    "Minimum secondary pump speed";

  parameter Real minPriPumSpeSta[nSta](
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) = {0,0,0,0,0}
    "Vector of minimum primary pump speed for each stage";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCurSta
    "Current stage"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaTyp[nSta]
    "Stage type vector"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinBypValPos(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if have_priOnl
    "Minimum allowed setpoint of bypass valve position"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinPriPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if (have_varPriPum and not have_priOnl)
    "Minimum allowed primary pump speed"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxSecPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if not have_priOnl
    "Maximum allowed secondary pump speed"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Pass 0 regulation signal if stage type is not non-condensing"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0)
    "Zero source"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.ProportionalRegulator proReg(
    final TRetSet=TRetSet,
    final TRetMinAll=TRetMinAll)
    "Proportional regulator"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Identify stage type for current stage"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler)
    "Identify if current stage is condensing type or non-condensing type"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits pumSpeLim(
    final have_varPriPum=have_varPriPum,
    final nSta=nSta,
    final minSecPumSpe=minSecPumSpe,
    final minPriPumSpeSta=minPriPumSpeSta) if not have_priOnl
    "Block to calculate pump speed limits"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(THotWatRet, proReg.THotWatRet)
    annotation (Line(points={{-120,70},{-92,70}},
                                                color={0,0,127}));

  connect(yMinBypValPos, yMinBypValPos)
    annotation (Line(points={{120,20},{120,20}}, color={0,0,127}));

  connect(uStaTyp, intToRea.u)
    annotation (Line(points={{-120,-70},{-92,-70}},
                                                  color={255,127,0}));

  connect(intToRea.y, extIndSig.u)
    annotation (Line(points={{-68,-70},{-52,-70}},
                                                 color={0,0,127}));

  connect(uCurSta, extIndSig.index) annotation (Line(points={{-120,0},{-60,0},{-60,
          -90},{-40,-90},{-40,-82}},
                                  color={255,127,0}));

  connect(extIndSig.y, greThr.u)
    annotation (Line(points={{-28,-70},{-12,-70}},
                                                 color={0,0,127}));

  connect(proReg.yRegSig, swi.u1) annotation (Line(points={{-68,70},{-60,70},{-60,
          58},{-52,58}},       color={0,0,127}));
  connect(greThr.y, swi.u2) annotation (Line(points={{12,-70},{20,-70},{20,-50},
          {-56,-50},{-56,50},{-52,50}},     color={255,0,255}));
  connect(swi.y, yMinBypValPos) annotation (Line(points={{-28,50},{46,50},{46,
          20},{120,20}},                 color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{-68,30},{-60,30},{-60,42},{-52,
          42}},       color={0,0,127}));
  connect(swi.y, pumSpeLim.uRegSig) annotation (Line(points={{-28,50},{-20,50},{
          -20,-5},{-12,-5}}, color={0,0,127}));
  connect(uCurSta, pumSpeLim.uCurSta) annotation (Line(points={{-120,0},{-60,0},
          {-60,5},{-12,5}}, color={255,127,0}));
  connect(pumSpeLim.yMinPriPumSpe, yMinPriPumSpe)
    annotation (Line(points={{12,5},{40,5},{40,-20},{120,-20}},
                                                           color={0,0,127}));
  connect(pumSpeLim.yMaxSecPumSpe, yMaxSecPumSpe) annotation (Line(points={{12,-5},
          {30,-5},{30,-60},{120,-60}}, color={0,0,127}));
  annotation (defaultComponentName=
    "conSet",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=0.1),
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={28,108,200},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=5,
        borderPattern=BorderPattern.Raised),
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name"),
      Ellipse(
        extent={{-80,80},{80,-80}},
        lineColor={28,108,200},
        fillColor={170,255,213},
        fillPattern=FillPattern.Solid)},
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
  Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(
    info="<html>
    <p>
    Block that generates condensation control setpoints according to ASHRAE RP-1711,
    March, 2020 draft, section 5.3.5.
    </p>
    <p>
    The sequence calculates the condensation control setpoints for minimum bypass
    valve position <code>yMinBypValPos</code>, minimum primary pump speed <code>yMinPriPumSpe</code>
    and maximum secondary pump speed <code>yMaxSecPumSpe</code> using the following calculations:
    <ol>
    <li>
    Block <code>proReg</code> implemented in the class
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.ProportionalRegulator\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.ProportionalRegulator</a>
    uses the measured hot water return temperature <code>THotWatRet</code> to generate a regulation signal with P-only control loop.
    </li>
    <li>
    The regulation signal is used as is for <code>yMinBypValPos</code>.
    </li>
    <li>
    The regulation signal is used by block <code>pumSpeLim</code> implemented in the class
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits</a>
    to generate the pump speed limits <code>yMinPriPumSpe</code> and <code>yMaxSecPumSpe</code>.
    </li>
    </ol>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 18, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end CondensationControl;

within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences;
block ProportionalRegulator
    "Sequence to calculate regulation signal with measured return temperature as input"

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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water return temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=TRetSet, final k=-1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=TRetSet - TRetMinAll, final uMin=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=1/(TRetSet - TRetMinAll))
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRegSig(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1)
    "Regulation signal from P-only loop for condensation control"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

equation
  connect(addPar.u, THotWatRet)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));

  connect(lim.u, addPar.y)
    annotation (Line(points={{-12,0},{-38,0}}, color={0,0,127}));

  connect(lim.y, gai.u)
    annotation (Line(points={{12,0},{38,0}}, color={0,0,127}));

  connect(gai.y, yRegSig)
    annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));

  annotation (defaultComponentName=
    "proReg",
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
        lineColor={0,0,255},
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
    Block that generates proportional regulation signal for condensation control
    in non-condensing boilers according to RP-1711, March, 2020 draft, section
    5.3.5.
    </p>
    <p>
    The minimum bypass valve position <code>yProReg</code> is calculated
    as follows:
    <li>
    The measured hot-water return temperature <code>THotWatRet</code> is compared
    to the minimum hot water return temperature for optimal operation <code>TRetSet</code>,
    with the output <code>yProReg</code> varying linearly from 0% at
    <code>TRetSet</code> to 100% at <code>TRetMinAll</code>.    
    </li>
    <p align=\"center\">
    <img alt=\"Validation plot for ValvePosition\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/SetPoints/Subsequences/ProportionalRegulator.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.Validation.ProportionalRegulator\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.Validation.ProportionalRegulator</a>.
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    July 21, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end ProportionalRegulator;

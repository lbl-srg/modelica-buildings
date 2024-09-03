within Buildings.Utilities.Psychrometrics.Examples;
model TWetBul_TDryBulPhi "Model to test the wet bulb temperature computation"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhi(
    redeclare package Medium = Medium) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant p(k=101325) "Pressure"
                                    annotation (Placement(transformation(extent={{-80,-20},
            {-60,0}})));
    Modelica.Blocks.Sources.Ramp phi(
    duration=1,
    height=1,
    offset=0) "Relative humidity"
                 annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant TDryBul(k=273.15 + 29.4)
    "Dry bulb temperature"          annotation (Placement(transformation(extent={{-80,60},
            {-60,80}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhiApp(
    redeclare package Medium = Medium,
    approximateWetBulb=true) "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulXi(
    redeclare package Medium = Medium)
    "Model for wet bulb temperature using Xi as an input, used to verify consistency with wetBulPhi"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi "Computes mass fraction"
    annotation (Placement(transformation(extent={{-22,-36},{-10,-24}})));

protected
  block Assertions
    extends Modelica.Blocks.Icons.Block;
    constant Modelica.Units.SI.Temperature dT_max=0.1
      "Maximum allowed deviation with reference result";

    Modelica.Blocks.Interfaces.RealInput phi "Relative humidity"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput wetBulPhi_TWetBul
      "Wet bulb temperature from wetBulPhi_phi"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput wetBulXi_TWetBul
      "Wet bulb temperature from wetBulXi_phi"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  equation
    // Validation of one data point based on example 17.1 in
    // Ananthanarayanan, P. N. Basic refrigeration and air conditioning. Tata McGraw-Hill Education, 2013.
    if abs(phi-0.48)<0.001 then
      assert(abs(wetBulPhi_TWetBul - 21.1-273.15) < dT_max,
      "Error in computation of wet bulb temperature, deviation with reference result is larger than "
       + String(dT_max) + " K since the wet bulb temperature equals " +String(wetBulPhi_TWetBul));
    end if;

    assert(abs(wetBulPhi_TWetBul-wetBulXi_TWetBul)<1e-2, "Inconsistent implementation of wetBulPhi and wetBulXi.");
  end Assertions;

  Assertions assertions "Verifies that the results are correct"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  connect(p.y, wetBulPhi.p)
                         annotation (Line(points={{-59,-10},{-40,-10},{-40,42},{
          -1,42}},                                                  color={0,0,
          127}));
  connect(TDryBul.y, wetBulPhi.TDryBul) annotation (Line(
      points={{-59,70},{-32,70},{-32,58},{-1,58}},
      color={0,0,127}));
  connect(phi.y, wetBulPhi.phi) annotation (Line(
      points={{-59,30},{-46,30},{-46,50},{-1,50}},
      color={0,0,127}));
  connect(p.y, wetBulPhiApp.p)
                         annotation (Line(points={{-59,-10},{-40,-10},{-40,2},{-1,
          2}},                                                      color={0,0,
          127}));
  connect(TDryBul.y, wetBulPhiApp.TDryBul)
                                        annotation (Line(
      points={{-59,70},{-32,70},{-32,18},{-1,18}},
      color={0,0,127}));
  connect(phi.y, wetBulPhiApp.phi)
                                annotation (Line(
      points={{-59,30},{-46,30},{-46,10},{-1,10}},
      color={0,0,127}));
  connect(wetBulXi.TDryBul, TDryBul.y) annotation (Line(points={{-1,-22},{-6,-22},
          {-6,-10},{-10,-10},{-32,-10},{-32,70},{-59,70}},
                                        color={0,0,127}));
  connect(wetBulXi.p, p.y) annotation (Line(points={{-1,-38},{-40,-38},{-40,-10},
          {-59,-10}}, color={0,0,127}));
  connect(x_pTphi.p_in, p.y) annotation (Line(points={{-23.2,-26.4},{-40,-26.4},
          {-40,-10},{-59,-10}}, color={0,0,127}));
  connect(x_pTphi.T, TDryBul.y) annotation (Line(points={{-23.2,-30},{-32,-30},{
          -32,70},{-59,70}}, color={0,0,127}));
  connect(x_pTphi.phi, phi.y) annotation (Line(points={{-23.2,-33.6},{-46,-33.6},
          {-46,30},{-59,30}}, color={0,0,127}));
  connect(x_pTphi.X[1], wetBulXi.Xi[1])
    annotation (Line(points={{-9.4,-30},{-1,-30}},          color={0,0,127}));
  connect(wetBulPhi.TWetBul, assertions.wetBulPhi_TWetBul) annotation (Line(
        points={{21,50},{48,50},{48,10},{58,10}}, color={0,0,127}));
  connect(wetBulXi.TWetBul, assertions.wetBulXi_TWetBul) annotation (Line(
        points={{21,-30},{36,-30},{48,-30},{48,4},{58,4}}, color={0,0,127}));
  connect(assertions.phi, phi.y) annotation (Line(points={{58,16},{50,16},{40,16},
          {40,30},{-59,30}}, color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/TWetBul_TDryBulPhi.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the wet bulb computation.
The model on the top uses the accurate computation of the
wet bulb temperature, whereas the model below uses the approximate
computation of the wet bulb temperature.
</p>
<p>
The model contains an assert that validates the model based on a single operating point from Example 17.1 in
Ananthanarayanan (2013).
</p>
<h4>References</h4>
<p>
Ananthanarayanan, P. N. Basic refrigeration and air conditioning. Tata McGraw-Hill Education, 2013.
</p>
</html>", revisions="<html>
<ul>
<li>
June 23, 2016, by Michael Wetter:<br/>
Changed graphical annotation.
</li>
<li>
May 24, 2016, by Filip Jorissen:<br/>
Updated example with validation data.
See  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/474\">#474</a>
for a discussion.
</li>
<li>
October 1, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TWetBul_TDryBulPhi;

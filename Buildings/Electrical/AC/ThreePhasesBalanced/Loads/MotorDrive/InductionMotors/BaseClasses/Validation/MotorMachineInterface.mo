within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.Validation;
model MotorMachineInterface "This example validates model MotorMachineInterface"
  import Modelica.Constants.pi;
  extends Modelica.Icons.Example;

  parameter Integer pole=4 "Number of pole pairs";
  parameter Modelica.Units.SI.Frequency f=60 "Fequency";
  parameter Modelica.Units.SI.Voltage v=120 "Fequency";

  MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface torSpe(pole=pole)
    "Torque speed relationship"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant Vrms(k=v) "Voltage"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=4*pi*f/
    pole,
    startTime=120,
    height=-4*pi*f/pole,
    offset=4*pi*f/pole) "Rotor speed"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Constant fSou(k=f)
    "Frequency"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

equation
  connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-59,30},{-20,30},{-20,
          4},{-12,4}}, color={0,0,127}));
  connect(ramp.y, torSpe.omega_r) annotation (Line(points={{-59,-30},{-20,-30},{
          -20,-4},{-12,-4}}, color={0,0,127}));
  connect(fSou.y, torSpe.f)
    annotation (Line(points={{-59,0},{-12,0}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/BaseClasses/Validations/MotorMachineInterface.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example validates 
<a href=\"modelica://MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface\">MotorMachineInterface</a> 
by checking torque speed relationship for induction motors.</p>
</html>",
revisions="<html>
<ul>
<li>6 March 2019, by Yangyang Fu:<br>First implementation.</li>
</ul>
</html>"));
end MotorMachineInterface;

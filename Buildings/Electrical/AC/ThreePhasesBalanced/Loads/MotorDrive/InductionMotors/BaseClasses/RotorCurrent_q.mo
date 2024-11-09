within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.BaseClasses;
model RotorCurrent_q "q-axis rotor current calculation blck"
  extends Modelica.Blocks.Icons.Block;
   parameter Real Lr;
   parameter Real Rr;
   parameter Real Lm;
  Modelica.Blocks.Interfaces.RealInput v_qr
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput i_qr
    annotation (Placement(transformation(extent={{-140,38},{-100,78}}),
        iconTransformation(extent={{-140,38},{-100,78}})));
  Modelica.Blocks.Interfaces.RealInput der_i_qs
    annotation (Placement(transformation(extent={{-140,-2},{-100,38}}),
        iconTransformation(extent={{-140,-2},{-100,38}})));
  Modelica.Blocks.Interfaces.RealInput omega_r
    annotation (Placement(transformation(extent={{-140,-44},{-100,-4}}),
        iconTransformation(extent={{-140,-44},{-100,-4}})));
  Modelica.Blocks.Interfaces.RealInput i_dr
    annotation (Placement(transformation(extent={{-140,-82},{-100,-42}}),
        iconTransformation(extent={{-140,-82},{-100,-42}})));
  Modelica.Blocks.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealOutput der_i_qr annotation (Placement(
        transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},
            {140,20}})));
equation
  der_i_qr = (((v_qr)/Lr)-((Rr*i_qr)/Lr)-((der_i_qs*Lm)/Lr)-(omega_r*i_dr)-((omega_r*Lm*i_ds)/Lr));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end RotorCurrent_q;

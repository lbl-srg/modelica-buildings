within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model StatorCurrent_d "d-axis stator current calculation block"
  extends Modelica.Blocks.Icons.Block;
   parameter Real Lr;
   parameter Real Rr;
   parameter Real Lm;
   parameter Real Rs;
   parameter Real Ls;
  Modelica.Blocks.Interfaces.RealInput v_ds
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput der_i_dr annotation (Placement(
        transformation(extent={{-140,2},{-100,42}}),  iconTransformation(extent={{-140,2},
            {-100,42}})));
  Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
          extent={{-140,-42},{-100,-2}}),  iconTransformation(extent={{-140,-42},
            {-100,-2}})));
  Modelica.Blocks.Interfaces.RealInput i_qr
    annotation (Placement(transformation(extent={{-140,-84},{-100,-44}}),
        iconTransformation(extent={{-140,-84},{-100,-44}})));
  Modelica.Blocks.Interfaces.RealInput i_qs annotation (Placement(
        transformation(extent={{-140,-120},{-100,-80}}),  iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealOutput der_i_ds annotation (Placement(
        transformation(extent={{100,-26},{154,28}}),iconTransformation(extent={{100,-26},
            {154,28}})));

equation
  der_i_ds =(((v_ds)/Ls)-((Rs*i_ds)/Ls)-((der_i_dr*Lm)/Ls)+(omega*i_qs)+((omega*Lm*i_qr)/Ls));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end StatorCurrent_d;

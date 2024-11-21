within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model StatorCurrent_q "q-axis stator current calculation block"
  extends Modelica.Blocks.Icons.Block;
  parameter Real Lr;
  parameter Real Rr;
  parameter Real Lm;
  parameter Real Rs;
  parameter Real Ls;
  Modelica.Blocks.Interfaces.RealInput v_qs
    annotation (Placement(transformation(extent={{-140,78},{-100,118}}),
        iconTransformation(extent={{-140,78},{-100,118}})));
  Modelica.Blocks.Interfaces.RealInput i_qs
    annotation (Placement(transformation(extent={{-140,38},{-100,78}}),
        iconTransformation(extent={{-140,38},{-100,78}})));
  Modelica.Blocks.Interfaces.RealInput der_i_qr annotation (Placement(
        transformation(extent={{-140,-2},{-100,38}}), iconTransformation(extent={{-140,-2},
            {-100,38}})));
  Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
          extent={{-140,-42},{-100,-2}}),  iconTransformation(extent={{-140,-42},
            {-100,-2}})));
  Modelica.Blocks.Interfaces.RealInput i_dr
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealOutput der_i_qs annotation (Placement(
        transformation(extent={{100,-28},{154,26}}),iconTransformation(extent={{100,-28},
            {154,26}})));

equation
  der_i_qs =(((v_qs)/Ls)-((Rs*i_qs)/Ls)-((der_i_qr*Lm)/Ls)-(omega*i_ds)-((omega*Lm*i_dr)/Ls));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end StatorCurrent_q;

within Buildings.Electrical.PhaseSystems;
package ThreePhase_d "AC system covering only resistive loads with three symmetric phases"
  extends DirectCurrent(phaseSystemName="ThreePhase_d");


  redeclare function phaseVoltages "Return phase to neutral voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage V "system voltage";
    input SI.Angle phi = 0 "phase angle";
    output SI.Voltage v[n] "phase to neutral voltages";
  algorithm
    v := {V}/sqrt(3);
  end phaseVoltages;


  redeclare function systemVoltage
  "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n];
    output SI.Voltage V;
  algorithm
    V := sqrt(3)*v[1];
  end systemVoltage;


  annotation (Icon(graphics={
        Line(
          points={{-70,-10},{-58,10},{-38,30},{-22,10},{-10,-10},{2,-30},{22,
              -50},{40,-30},{50,-10}},
          color={95,95,95},
          smooth=Smooth.Bezier)}), Documentation(info="<html>
<p>
This package declares the functions that are used to implement
the AC three-phase balanced and purely resistive models.
</p>
</html>"));
end ThreePhase_d;

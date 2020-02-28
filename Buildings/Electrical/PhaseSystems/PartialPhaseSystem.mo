within Buildings.Electrical.PhaseSystems;
package PartialPhaseSystem "Base package of all phase systems"
  extends Modelica.Icons.Package;
  constant String phaseSystemName = "UnspecifiedPhaseSystem"
    "Name of the phase system represented by the package";
  constant Integer n "Number of independent voltage and current components";
  constant Integer m "Number of reference angles";

  type Current = Real(unit = "A", quantity = "Current." + phaseSystemName)
    "Current for connector" annotation (Documentation(info="<html>
This type defines the current for a specific connector that extends
<a href=\"modelica://Buildings.Electrical.PhaseSystems.PartialPhaseSystem\">
Buildings.Electrical.PhaseSystems.PartialPhaseSystem</a>.
</html>"));

  type Voltage = Real(unit = "V", quantity = "Voltage." + phaseSystemName)
    "Voltage for connector" annotation (Documentation(info="<html>
This type defines the voltage for a specific connector that extends
<a href=\"modelica://Buildings.Electrical.PhaseSystems.PartialPhaseSystem\">
Buildings.Electrical.PhaseSystems.PartialPhaseSystem</a>.
</html>"));

  type ReferenceAngle "Reference angle for connector"
    extends Modelica.Units.SI.Angle;

    function equalityConstraint "Assert that angles are equal"
      extends Modelica.Icons.Function;
      input ReferenceAngle theta1[:];
      input ReferenceAngle theta2[:];
      output Real residue[0];
    algorithm
      for i in 1:size(theta1, 1) loop
        assert(abs(theta1[i] - theta2[i]) < Modelica.Constants.eps,
          "Angles theta1 and theta2 are not equal over the connection.");
      end for;
    end equalityConstraint;
    annotation (Documentation(info="<html>
This type defines the voltage angle (used by the phasorial approach) for a specific connector that extends
<a href=\"modelica://Buildings.Electrical.PhaseSystems.PartialPhaseSystem\">
Buildings.Electrical.PhaseSystems.PartialPhaseSystem</a>.
</html>"));
  end ReferenceAngle;

  replaceable partial function j "Return vector rotated by 90 degrees"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Real y[n];
  end j;

  replaceable partial function jj "Vectorized version of j"
    extends Modelica.Icons.Function;
    input Real[:,:] xx "array of voltage or current vectors";
    output Real[size(xx,1),size(xx,2)] yy "array of rotated vectors";
  algorithm
    //yy := {j(xx[:,k]) for k in 1:size(xx,2)};
    // Note: Dymola 2013 fails to expand
    for k in 1:size(xx,2) loop
      yy[:,k] := j(xx[:,k]);
    end for;
  end jj;

  replaceable partial function rotate
    "Rotate a vector of an angle theta (anti-counterclock)"
    extends Modelica.Icons.Function;
    input Real x[n];
    input Modelica.Units.SI.Angle theta;
    output Real y[n];
  end rotate;

  replaceable partial function product "Multiply two vectors"
      extends Modelica.Icons.Function;
      input Real x[n];
      input Real y[n];
      output Real z[n];
  end product;

  replaceable partial function divide "Divide two vectors"
      extends Modelica.Icons.Function;
      input Real x[n];
      input Real y[n];
      output Real z[n];
  end divide;

  replaceable partial function thetaRel
    "Return absolute angle of rotating system as offset to thetaRef"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Angle theta[m];
    output Modelica.Units.SI.Angle thetaRel;
  end thetaRel;

  replaceable partial function thetaRef
    "Return absolute angle of rotating reference system"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Angle theta[m];
    output Modelica.Units.SI.Angle thetaRef;
  end thetaRef;

  replaceable partial function phase "Return phase"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Modelica.Units.SI.Angle phase;
  end phase;

  replaceable partial function phaseVoltages "Return phase to neutral voltages"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Voltage V "system voltage";
    input Modelica.Units.SI.Angle phi=0 "phase angle";
    output Modelica.Units.SI.Voltage v[n] "phase to neutral voltages";
  end phaseVoltages;

  replaceable partial function phaseCurrents "Return phase currents"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Current I "system current";
    input Modelica.Units.SI.Angle phi=0 "phase angle";
    output Modelica.Units.SI.Current i[n] "phase currents";
  end phaseCurrents;

  replaceable partial function phasePowers "Return phase powers"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.ActivePower P "active system power";
    input Modelica.Units.SI.Angle phi=0 "phase angle";
    output Modelica.Units.SI.Power p[n] "phase powers";
  end phasePowers;

  replaceable partial function phasePowers_vi "Return phase powers"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Voltage v[n] "phase voltages";
    input Modelica.Units.SI.Current i[n] "phase currents";
    output Modelica.Units.SI.Power p[n] "phase powers";
  end phasePowers_vi;

  replaceable partial function systemVoltage
    "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Voltage v[n];
    output Modelica.Units.SI.Voltage V;
  end systemVoltage;

  replaceable partial function systemCurrent
    "Return system current as function of phase currents"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Current i[n];
    output Modelica.Units.SI.Current I;
  end systemCurrent;

  replaceable partial function activePower
    "Return total power as function of phase powers"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Voltage v[n] "phase voltages";
    input Modelica.Units.SI.Current i[n] "phase currents";
    output Modelica.Units.SI.ActivePower P "active system power";
  end activePower;

annotation (Documentation(info="<html>
<p>
This package declares the functions that are used to implement
the different phase systems.
</p>
</html>"));
end PartialPhaseSystem;

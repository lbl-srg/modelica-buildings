within Districts.Electrical.PhaseSystems;
partial package PartialPhaseSystem "Base package of all phase systems"
  extends Modelica.Icons.Package;
  constant String phaseSystemName = "UnspecifiedPhaseSystem";
  constant Integer n "Number of independent voltage and current components";
  constant Integer m "Number of reference angles";



  replaceable partial function j "Return vector rotated by 90 degrees"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Real y[n];
  end j;


  replaceable function jj "Vectorized version of j"
    input Real[:,:] xx "array of voltage or current vectors";
    output Real[size(xx,1),size(xx,2)] yy "array of rotated vectors";
  algorithm
    //yy := {j(xx[:,k]) for k in 1:size(xx,2)};
    // Note: Dymola 2013 fails to expand
    for k in 1:size(xx,2) loop
      yy[:,k] := j(xx[:,k]);
    end for;
  end jj;


  replaceable function rotate
  "Rotate a vector of an angle Theta (anti-counterclock)"
    extends Modelica.Icons.Function;
    input Real x[n];
    input Modelica.SIunits.Angle theta;
    output Real y[n];
  end rotate;


  replaceable function product "Multiply two vectors"
      extends Modelica.Icons.Function;
      input Real x[n];
      input Real y[n];
      output Real z[n];
  end product;


  replaceable function divide "Divide two vectors"
      extends Modelica.Icons.Function;
      input Real x[n];
      input Real y[n];
      output Real z[n];
  end divide;


  replaceable partial function thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
    input SI.Angle theta[m];
    output SI.Angle thetaRel;
  end thetaRel;


  replaceable partial function thetaRef
  "Return absolute angle of rotating reference system"
    input SI.Angle theta[m];
    output SI.Angle thetaRef;
  end thetaRef;


  replaceable partial function phase "Return phase"
    extends Modelica.Icons.Function;
    input Real x[n];
    output SI.Angle phase;
  end phase;


  replaceable partial function phaseVoltages "Return phase to neutral voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage V "system voltage";
    input SI.Angle phi = 0 "phase angle";
    output SI.Voltage v[n] "phase to neutral voltages";
  end phaseVoltages;


  replaceable partial function phaseCurrents "Return phase currents"
    extends Modelica.Icons.Function;
    input SI.Current I "system current";
    input SI.Angle phi = 0 "phase angle";
    output SI.Current i[n] "phase currents";
  end phaseCurrents;


  replaceable partial function phasePowers "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.ActivePower P "active system power";
    input SI.Angle phi = 0 "phase angle";
    output SI.Power p[n] "phase powers";
  end phasePowers;


  replaceable partial function phasePowers_vi "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.Power p[n] "phase powers";
  end phasePowers_vi;


  replaceable partial function systemVoltage
  "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n];
    output SI.Voltage V;
  end systemVoltage;


  replaceable partial function systemCurrent
  "Return system current as function of phase currents"
    extends Modelica.Icons.Function;
    input SI.Current i[n];
    output SI.Current I;
  end systemCurrent;


  replaceable partial function activePower
  "Return total power as function of phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.ActivePower P "active system power";
  end activePower;


  annotation (Icon(graphics));
end PartialPhaseSystem;
